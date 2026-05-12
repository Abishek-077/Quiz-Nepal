import 'package:http/http.dart' as http;

class StudyResourceLinkChecker {
  StudyResourceLinkChecker({http.Client? client})
      : _client = client ?? http.Client();

  static const Map<String, String> _headers = {
    'Accept':
        'text/html,application/xhtml+xml,application/pdf,application/xml;q=0.9,*/*;q=0.8',
    'User-Agent': 'Mozilla/5.0 (Linux; Android 14) QuizBattleNepal/1.0 Mobile',
  };

  final http.Client _client;

  Future<StudyResourceLinkStatus> check(String url) async {
    final uri = Uri.parse(url);
    try {
      final response = await _client.head(uri, headers: _headers).timeout(
            const Duration(seconds: 8),
          );

      if (_isUseful(response.statusCode)) {
        return StudyResourceLinkStatus.fromResponse(response);
      }

      return _checkWithSmallGet(uri);
    } on Exception catch (error) {
      try {
        return _checkWithSmallGet(uri);
      } on Exception {
        return StudyResourceLinkStatus.unavailable(error.toString());
      }
    }
  }

  Future<StudyResourceLinkStatus> _checkWithSmallGet(Uri uri) async {
    final response = await _client.get(
      uri,
      headers: const {
        ..._headers,
        'Range': 'bytes=0-0',
      },
    ).timeout(const Duration(seconds: 8));

    return StudyResourceLinkStatus.fromResponse(response);
  }

  bool _isUseful(int statusCode) {
    return statusCode >= 200 && statusCode < 400;
  }

  void close() {
    _client.close();
  }
}

class StudyResourceLinkStatus {
  const StudyResourceLinkStatus({
    required this.statusCode,
    required this.isAvailable,
    this.contentType,
    this.contentLength,
    this.error,
  });

  factory StudyResourceLinkStatus.fromResponse(http.Response response) {
    return StudyResourceLinkStatus(
      statusCode: response.statusCode,
      isAvailable: response.statusCode >= 200 && response.statusCode < 400,
      contentType: response.headers['content-type'],
      contentLength: response.headers['content-length'],
    );
  }

  factory StudyResourceLinkStatus.unavailable(String error) {
    return StudyResourceLinkStatus(
      statusCode: 0,
      isAvailable: false,
      error: error,
    );
  }

  final int statusCode;
  final bool isAvailable;
  final String? contentType;
  final String? contentLength;
  final String? error;

  String get summary {
    if (!isAvailable) {
      return error == null ? 'Unavailable' : 'Unavailable right now';
    }

    final parts = [
      'HTTP $statusCode',
      if (contentType != null) contentType!,
      if (contentLength != null) _readableBytes(contentLength!),
    ];

    return parts.join(' | ');
  }

  String _readableBytes(String value) {
    final bytes = int.tryParse(value);
    if (bytes == null) {
      return value;
    }
    if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '$bytes B';
  }
}
