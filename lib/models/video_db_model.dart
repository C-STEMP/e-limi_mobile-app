class VideoModel {
  final int? id;
  final String title;
  final String path;
  final int lessonId;
  final int courseId;
  final int sectionId;
  final String courseTitle;
  final String sectionTitle;
  final String thumbnail;
  final String downloadId;

  VideoModel(
      {this.id,
      required this.title,
      required this.path,
      required this.lessonId,
      required this.courseId,
      required this.sectionId,
      required this.courseTitle,
      required this.sectionTitle,
      required this.thumbnail,
      required this.downloadId});

  factory VideoModel.fromMap(Map<String, dynamic> json) => VideoModel(
        id: json['id'],
        title: json['title'],
        path: json['path'],
        lessonId: json['lesson_id'],
        courseId: json['course_id'],
        sectionId: json['section_id'],
        courseTitle: json['course_title'],
        sectionTitle: json['section_title'],
        thumbnail: json['thumbnail'],
        downloadId: json['download_id'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'path': path,
      'lesson_id': lessonId,
      'course_id': courseId,
      'section_id': sectionId,
      'course_title': courseTitle,
      'section_title': sectionTitle,
      'thumbnail': thumbnail,
      'download_id': downloadId,
    };
  }
}
