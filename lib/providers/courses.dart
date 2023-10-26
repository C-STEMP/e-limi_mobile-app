import 'dart:convert';
import 'package:elimiafrica/models/course.dart';
import 'package:elimiafrica/models/course_detail.dart';
import 'package:elimiafrica/models/lesson.dart';
import 'package:elimiafrica/models/section.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'shared_pref_helper.dart';

class Courses with ChangeNotifier {
  List<Course> _items = [];
  List<Course> _topItems = [];
  List<CourseDetail> _courseDetailsitems = [];

  Courses(this._items, this._topItems);

  List<Course> get items {
    return [..._items];
  }

  List<Course> get topItems {
    return [..._topItems];
  }

  CourseDetail get getCourseDetail {
    return _courseDetailsitems.first;
  }

  int get itemCount {
    return _items.length;
  }

  Course findById(int id) {
    // return _topItems.firstWhere((course) => course.id == id);
    return _items.firstWhere((course) => course.id == id,
        orElse: () => _topItems.firstWhere((course) => course.id == id));
  }

  Future<void> fetchTopCourses() async {
    var url = '$BASE_URL/api/top_courses';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      // print(extractedData);
      _topItems = buildCourseList(extractedData);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchCoursesByCategory(int categoryId) async {
    var url = '$BASE_URL/api/category_wise_course?category_id=$categoryId';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      // print(extractedData);

      _items = buildCourseList(extractedData);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchCoursesBySearchQuery(String searchQuery) async {
    var url =
        '$BASE_URL/api/courses_by_search_string?search_string=$searchQuery';
    // print(url);
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      // print(extractedData);

      _items = buildCourseList(extractedData);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> filterCourses(
      String selectedCategory,
      String selectedPrice,
      String selectedLevel,
      String selectedLanguage,
      String selectedRating) async {
    var url =
        '$BASE_URL/api/filter_course?selected_category=$selectedCategory&selected_price=$selectedPrice&selected_level=$selectedLevel&selected_language=$selectedLanguage&selected_rating=$selectedRating&selected_search_string=';
    // print(url);
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      // print(extractedData);

      _items = buildCourseList(extractedData);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchMyWishlist() async {
    var authToken = await SharedPreferenceHelper().getAuthToken();
    var url = '$BASE_URL/api/my_wishlist?auth_token=$authToken';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      // print(extractedData);
      _items = buildCourseList(extractedData);
      // print(_items);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  List<Course> buildCourseList(List extractedData) {
    final List<Course> loadedCourses = [];
    for (var courseData in extractedData) {
      loadedCourses.add(Course(
        id: int.parse(courseData['id']),
        title: courseData['title'],
        thumbnail: courseData['thumbnail'],
        price: courseData['price'],
        isFreeCourse: courseData['is_free_course'],
        instructor: courseData['instructor_name'],
        instructorImage: courseData['instructor_image'],
        rating: courseData['rating'],
        totalNumberRating: courseData['number_of_ratings'],
        numberOfEnrollment: courseData['total_enrollment'],
        shareableLink: courseData['shareable_link'],
        courseOverviewProvider: courseData['course_overview_provider'],
        courseOverviewUrl: courseData['video_url'],
        vimeoVideoId: courseData['vimeo_video_id'],
      ));
      // print(catData['name']);
    }
    return loadedCourses;
  }

  Future<void> toggleWishlist(int courseId, bool removeItem) async {
    var authToken = await SharedPreferenceHelper().getAuthToken();
    var url =
        '$BASE_URL/api/toggle_wishlist_items?auth_token=$authToken&course_id=$courseId';
    if (!removeItem) {
      _courseDetailsitems.first.isWishlisted!
          ? _courseDetailsitems.first.isWishlisted = false
          : _courseDetailsitems.first.isWishlisted = true;
      notifyListeners();
    }
    try {
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);
      if (responseData['status'] == 'removed') {
        if (removeItem) {
          final existingMyCourseIndex =
              _items.indexWhere((mc) => mc.id == courseId);

          _items.removeAt(existingMyCourseIndex);
          notifyListeners();
        } else {
          _courseDetailsitems.first.isWishlisted = false;
        }
      } else if (responseData['status'] == 'added') {
        if (!removeItem) {
          _courseDetailsitems.first.isWishlisted = true;
        }
      }
      // notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchCourseDetailById(int courseId) async {
    var authToken = await SharedPreferenceHelper().getAuthToken();
    var url = '$BASE_URL/api/course_details_by_id?course_id=$courseId';

    if (authToken != null) {
      url =
          '$BASE_URL/api/course_details_by_id?auth_token=$authToken&course_id=$courseId';
    }

    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      if (extractedData.isEmpty) {
        return;
      }

      final List<CourseDetail> loadedCourseDetails = [];
      for (var courseData in extractedData) {
        loadedCourseDetails.add(CourseDetail(
          courseId: int.parse(courseData['id']),
          courseIncludes:
              (courseData['includes'] as List<dynamic>).cast<String>(),
          courseRequirements:
              (courseData['requirements'] as List<dynamic>).cast<String>(),
          courseOutcomes:
              (courseData['outcomes'] as List<dynamic>).cast<String>(),
          isWishlisted: courseData['is_wishlisted'],
          isPurchased: (courseData['is_purchased'] is int)
              ? courseData['is_purchased'] == 1
                  ? true
                  : false
              : courseData['is_purchased'],
          mSection:
              buildCourseSections(courseData['sections'] as List<dynamic>),
        ));
      }
      // print(loadedCourseDetails.first.courseOutcomes.last);
      // _items = buildCourseList(extractedData);
      _courseDetailsitems = loadedCourseDetails;
      // _courseDetail = loadedCourseDetails.first;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getEnrolled(int courseId) async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url =
        '$BASE_URL/api/enroll_free_course?course_id=$courseId&auth_token=$authToken';
    try {
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);
      if (responseData['message'] == 'success') {
        _courseDetailsitems.first.isPurchased = true;

        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  List<Section> buildCourseSections(List extractedSections) {
    final List<Section> loadedSections = [];

    for (var sectionData in extractedSections) {
      loadedSections.add(Section(
        id: int.parse(sectionData['id']),
        numberOfCompletedLessons: sectionData['completed_lesson_number'],
        title: sectionData['title'],
        totalDuration: sectionData['total_duration'],
        lessonCounterEnds: sectionData['lesson_counter_ends'],
        lessonCounterStarts: sectionData['lesson_counter_starts'],
        mLesson: buildCourseLessons(sectionData['lessons'] as List<dynamic>),
      ));
    }
    // print(loadedSections.first.title);
    return loadedSections;
  }

  List<Lesson> buildCourseLessons(List extractedLessons) {
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
}
