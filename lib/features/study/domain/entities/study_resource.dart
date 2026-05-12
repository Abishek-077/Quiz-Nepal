enum StudyResourceType {
  pdf,
  book,
  online,
  officialPortal,
}

class StudyResource {
  const StudyResource({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.sourceName,
    required this.description,
    required this.url,
    required this.type,
  });

  final String id;
  final String categoryId;
  final String title;
  final String sourceName;
  final String description;
  final String url;
  final StudyResourceType type;
}
