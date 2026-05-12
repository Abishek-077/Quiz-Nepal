class Question {
  const Question({
    required this.id,
    required this.category,
    required this.subCategory,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.shortExplanation,
    required this.fullExplanation,
  });

  final String id;
  final String category;
  final String subCategory;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String shortExplanation;
  final String fullExplanation;
}
