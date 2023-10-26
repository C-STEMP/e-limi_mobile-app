import 'dart:convert';

import 'package:elimiafrica/models/lesson.dart';
import 'package:elimiafrica/models/my_course.dart';
import 'package:elimiafrica/models/section.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'shared_pref_helper.dart';

class MyCourses with ChangeNotifier {
  List<MyCourse> _items = [];
  List<Section> _sectionItems = [];

  MyCourses(this._items, this._sectionItems);

  List<MyCourse> get items {
    return [..._items];
  }

  List<Section> get sectionItems {
    return [..._sectionItems];
  }

  int get itemCount {
    return _items.length;
  }

  MyCourse findById(int id) {
    return _items.firstWhere((myCourse) => myCourse.id == id);
  }

  Future<void> fetchMyCourses() async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url = '$BASE_URL/api/my_courses?auth_token=$authToken';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData.isEmpty || extractedData == null) {
        return;
      }
      // print(extractedData);
      _items = buildMyCourseList(extractedData);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  List<MyCourse> buildMyCourseList(List extractedData) {
    final List<MyCourse> loadedCourses = [];
    for (var courseData in extractedData) {
      loadedCourses.add(MyCourse(
        id: int.parse(courseData['id']),
        title: courseData['title'],
        thumbnail: courseData['thumbnail'],
        price: courseData['price'],
        instructor: courseData['instructor_name'],
        rating: courseData['rating'],
        totalNumberRating: courseData['number_of_ratings'],
        numberOfEnrollment: courseData['total_enrollment'],
        shareableLink: courseData['shareable_link'],
        courseOverviewProvider: courseData['course_overview_provider'],
        courseOverviewUrl: courseData['video_url'],
        courseCompletion: courseData['completion'],
        totalNumberOfLessons: courseData['total_number_of_lessons'],
        totalNumberOfCompletedLessons:
            courseData['total_number_of_completed_lessons'],
        enableDripContent: courseData['enable_drip_content'],
      ));
      // print(catData['name']);
    }
    return loadedCourses;
  }

  Future<void> fetchCourseSections(int courseId) async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url =
        '$BASE_URL/api/sections?auth_token=$authToken&course_id=$courseId';

    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      if (extractedData.isEmpty) {
        return;
      }

      final List<Section> loadedSections = [];
      for (var sectionData in extractedData) {
        loadedSections.add(Section(
          id: int.parse(sectionData['id']),
          numberOfCompletedLessons: sectionData['completed_lesson_number'],
          title: sectionData['title'],
          totalDuration: sectionData['total_duration'],
          lessonCounterEnds: sectionData['lesson_counter_ends'],
          lessonCounterStarts: sectionData['lesson_counter_starts'],
          mLesson: buildSectionLessons(sectionData['lessons'] as List<dynamic>),
        ));
      }
      _sectionItems = loadedSections;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  List<Lesson> buildSectionLessons(List extractedLessons) {
    final List<Lesson> loadedLessons = [];

    for (var lessonData in extractedLessons) {
      loadedLessons.add(Lesson(
        id: int.parse(lessonData['id']),
        title: lessonData['title'],
        duration: lessonData['duration'],
        lessonType: lessonData['lesson_type'],
        isFree: lessonData['is_free'],
        videoUrl: lessonData['video_url'],
        summary: lessonData['summary'],
        attachmentType: lessonData['attachment_type'],
        attachment: lessonData['attachment'],
        attachmentUrl: lessonData['attachment_url'],
        isCompleted: lessonData['is_completed'].toString(),
        videoUrlWeb: lessonData['video_url_web'],
        videoTypeWeb: lessonData['video_type_web'],
        vimeoVideoId: lessonData['vimeo_video_id'],
      ));
    }
    // print(loadedLessons.first.title);
    return loadedLessons;
  }

  Future<void> toggleLessonCompleted(int lessonId, int progress) async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url =
        '$BASE_URL/api/save_course_progress?auth_token=$authToken&lesson_id=$lessonId';
    // print(url);
    try {
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);
      if (responseData['course_id'] != null) {
        final myCourse = findById(int.parse(responseData['course_id']));
        myCourse.courseCompletion = responseData['course_progress'];
        myCourse.totalNumberOfCompletedLessons =
            responseData['number_of_completed_lessons'];

        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateDripContendLesson(
      int courseId, int courseProgress, int numberOfCompletedLessons) async {
    final myCourse = findById(courseId);
    myCourse.courseCompletion = courseProgress;
    myCourse.totalNumberOfCompletedLessons = numberOfCompletedLessons;

    notifyListeners();
  }

  Future<void> getEnrolled(int courseId) async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url =
        '$BASE_URL/api/enroll_free_course?course_id=$courseId&auth_token=$authToken';
    try {
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);
      if (responseData == null) {
        return;
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
