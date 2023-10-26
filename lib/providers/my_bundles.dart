import 'dart:convert';
import 'package:elimiafrica/models/bundle.dart';
import 'package:elimiafrica/models/bundle_courses_model.dart';
import 'package:elimiafrica/models/bundle_details_model.dart';
import 'package:elimiafrica/models/lesson.dart';
import 'package:elimiafrica/models/my_course.dart';
import 'package:elimiafrica/models/section.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'shared_pref_helper.dart';

class MyBundles with ChangeNotifier {
  List<Bundle> _bundleItems = [];
  List<BundleDetails> _bundleDetailsitems = [];
  List<Section> _sectionItems = [];
  List<MyCourse> _items = [];

  List<Bundle> get bundleItems {
    return [..._bundleItems];
  }

  List<Section> get sectionItems {
    return [..._sectionItems];
  }

  List<BundleDetails> get bundleDetail {
    return [..._bundleDetailsitems];
  }

  List<MyCourse> get items {
    return [..._items];
  }

  // BundleCourses findCourseById(int id) {
  //   return _bundleDetailsitems[0]
  //       .bundleCourses!
  //       .firstWhere((course) => course.id == id.toString());
  // }

  Future<void> fetchMybundles() async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url = '$BASE_URL/api/my_bundles?auth_token=$authToken';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData.isEmpty || extractedData == null) {
        return;
      }
      // print(extractedData);
      _bundleItems = buildMyBundleList(extractedData);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  List<Bundle> buildMyBundleList(List extractedData) {
    final List<Bundle> loadedBundle = [];
    for (var bundleData in extractedData) {
      loadedBundle.add(Bundle(
        id: int.parse(bundleData['id']),
        userId: int.parse(bundleData['user_id']),
        title: bundleData['title'],
        banner: bundleData['banner'],
        courseIds: bundleData['course_ids'],
        subscriptionLimit: bundleData['subscription_limit'],
        price: bundleData['price'],
        bundleDetails: bundleData['bundle_details'],
        status: bundleData['status'],
        dateAdded: bundleData['date_added'],
        userName: bundleData['user_name'],
        userImage: bundleData['user_image'],
        averageRating: bundleData['average_rating'],
        numberOfRatings: bundleData['number_of_ratings'],
        subscriptionStatus: bundleData['subscription_status'],
      ));
      // print(catData['name']);
    }
    return loadedBundle;
  }

  Future<void> fetchBundleDetailById(int bundleId) async {
    var url = '$BASE_URL/api/bundle_courses/$bundleId';

    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      if (extractedData.isEmpty) {
        return;
      }

      final List<BundleDetails> loadedBundleDetails = [];
      for (var bundleData in extractedData) {
        loadedBundleDetails.add(BundleDetails(
          id: bundleData['id'],
          userId: bundleData['user_id'],
          title: bundleData['title'],
          banner: bundleData['banner'],
          courseIds: bundleData['course_ids'],
          subscriptionLimit: bundleData['subscription_limit'],
          price: bundleData['price'],
          bundleDetails: bundleData['bundle_details'],
          status: bundleData['status'],
          dateAdded: bundleData['date_added'],
          userName: bundleData['user_name'],
          userImage: bundleData['user_image'],
          averageRating: bundleData['average_rating'],
          numberOfRatings: bundleData['number_of_ratings'],
          bundleCourses:
              buildBundleCourses(bundleData['bundle_courses'] as List<dynamic>),
        ));
      }
      // print(loadedCourseDetails.first.courseOutcomes.last);
      // _items = buildCourseList(extractedData);
      _bundleDetailsitems = loadedBundleDetails;
      // _courseDetail = loadedCourseDetails.first;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  List<BundleCourses> buildBundleCourses(List extractedBundleCourse) {
    final List<BundleCourses> loadedBundleCourse = [];

    for (var courseData in extractedBundleCourse) {
      loadedBundleCourse.add(BundleCourses(
        id: courseData['id'],
        title: courseData['title'],
        price: courseData['price'],
        description: courseData['description'],
        thumbnail: courseData['thumbnail'],
        isFreeCourse: courseData['is_free_course'],
        instructorName: courseData['instructor_name'],
        instructorImage: courseData['instructor_image'],
        rating: courseData['rating'],
        numberOfRatings: courseData['number_of_ratings'],
        totalEnrollment: courseData['total_enrollment'],
        shareableLink: courseData['shareable_link'],
        courseOverviewProvider: courseData['course_overview_provider'],
      ));
    }
    // print(loadedSections.first.title);
    return loadedBundleCourse;
  }

  Future<void> fetchCourse(int bundleId, int courseId) async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url =
        '$BASE_URL/api/my_bundle_course_details/$bundleId/$courseId?auth_token=$authToken';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData.isEmpty || extractedData == null) {
        return;
      }
      // print(extractedData);
      _items = buildCourseList(extractedData);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  List<MyCourse> buildCourseList(List extractedData) {
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
        '$BASE_URL/api/save_course_progress?auth_token=$authToken&lesson_id=$lessonId&progress=$progress';
    try {
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);
      if (responseData['course_id'] != null) {
        // final myCourse = findById(int.parse(responseData['course_id']));
        // myCourse.courseCompletion = responseData['course_progress'];
        // myCourse.totalNumberOfCompletedLessons =
        //     responseData['number_of_completed_lessons'];

        // notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }
}
