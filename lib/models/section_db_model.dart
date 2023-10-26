class SectionDbModel {
  final int? id;
  final int courseId;
  final int sectionId;
  final String sectionTitle;

  SectionDbModel(
      {this.id,
      required this.courseId,
      required this.sectionId,
      required this.sectionTitle});

  factory SectionDbModel.fromMap(Map<String, dynamic> json) => SectionDbModel(
        id: json['id'],
        courseId: json['course_id'],
        sectionId: json['section_id'],
        sectionTitle: json['section_title'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'course_id': courseId,
      'section_id': sectionId,
      'section_title': sectionTitle,
    };
  }
}
