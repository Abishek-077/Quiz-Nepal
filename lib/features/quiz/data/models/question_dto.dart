import '../../domain/entities/question.dart';

class QuestionDto {
  const QuestionDto._();

  static Question fromJson(Map<String, dynamic> json) {
    final id = _requiredString(json, 'id');
    final optionsJson = json['options'];
    if (optionsJson is! List<dynamic>) {
      throw FormatException('Question $id must include an options array.');
    }

    final options = optionsJson.map((option) {
      if (option is! String || option.trim().isEmpty) {
        throw FormatException('Question $id has an invalid option value.');
      }
      return option.trim();
    }).toList(growable: false);

    if (options.length != 4) {
      throw FormatException('Question $id must have exactly 4 options.');
    }

    final correctIndex = json['correctIndex'];
    if (correctIndex is! int ||
        correctIndex < 0 ||
        correctIndex >= options.length) {
      throw FormatException('Question $id has an invalid correctIndex.');
    }

    final subCategoryValue = json['subCategory'];
    var subCategory = 'general';
    if (subCategoryValue != null) {
      if (subCategoryValue is! String || subCategoryValue.trim().isEmpty) {
        throw FormatException('Question $id has an invalid subCategory.');
      }
      subCategory = subCategoryValue.trim();
    }

    return Question(
      id: id,
      category: _requiredString(json, 'category'),
      subCategory: subCategory,
      question: _requiredString(json, 'question'),
      options: options,
      correctIndex: correctIndex,
      shortExplanation: _requiredString(json, 'shortExplanation'),
      fullExplanation: _requiredString(json, 'fullExplanation'),
    );
  }

  static String _requiredString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! String || value.trim().isEmpty) {
      throw FormatException('Question JSON is missing a valid $key.');
    }
    return value.trim();
  }
}
