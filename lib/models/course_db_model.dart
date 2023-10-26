class CourseDbModel {
  final int? id;
  final int courseId;
  final String courseTitle;
  final String thumbnail;

  CourseDbModel(
      {this.id,
      required this.courseId,
      required this.courseTitle,
      required this.thumbnail});

  factory CourseDbModel.fromMap(Map<String, dynamic> json) => CourseDbModel(
        id: json['id'],
        courseId: json['course_id'],
        courseTitle: json['course_title'],
        thumbnail: json['thumbnail'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'course_id': courseId,
      'course_title': courseTitle,
      'thumbnail': thumbnail,
    };
  }
}
