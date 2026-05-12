import 'dart:convert';

import 'package:http/http.dart' as http;

class OpenTriviaQuestionDataSource {
  OpenTriviaQuestionDataSource({
    http.Client? client,
    Uri? baseUri,
  })  : _client = client ?? http.Client(),
        _baseUri = baseUri ?? Uri.parse('https://opentdb.com/api.php');

  final http.Client _client;
  final Uri _baseUri;

  Future<List<Map<String, dynamic>>> fetchQuestions({
    required int amount,
    int? categoryId,
  }) async {
    final uri = _baseUri.replace(
      queryParameters: {
        'amount': '$amount',
        'type': 'multiple',
        'encode': 'url3986',
        if (categoryId != null) 'category': '$categoryId',
      },
    );

    final response = await _client.get(uri);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw OpenTriviaException('HTTP ${response.statusCode} from $uri');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const OpenTriviaException(
          'OpenTDB response must be a JSON object.');
    }

    final responseCode = decoded['response_code'];
    if (responseCode != 0) {
      throw OpenTriviaException(
          'OpenTDB returned response code $responseCode.');
    }

    final results = decoded['results'];
    if (results is! List<dynamic>) {
      throw const OpenTriviaException('OpenTDB response is missing results.');
    }

    return results.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const OpenTriviaException('OpenTDB question must be an object.');
      }
      return item;
    }).toList(growable: false);
  }
}

class OpenTriviaException implements Exception {
  const OpenTriviaException(this.message);

  final String message;

  @override
  String toString() => 'OpenTriviaException: $message';
}
