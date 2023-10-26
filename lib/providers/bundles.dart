import 'dart:convert';
import 'package:elimiafrica/models/bundle.dart';
import 'package:elimiafrica/models/bundle_courses_model.dart';
import 'package:elimiafrica/models/bundle_details_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'shared_pref_helper.dart';

class Bundles with ChangeNotifier {
  List<Bundle> _bundleItems = [];
  List<BundleDetails> _bundleDetailsitems = [];

  List<Bundle> get bundleItems {
    return [..._bundleItems];
  }

  List<BundleDetails> get getBundleDetail {
    return _bundleDetailsitems;
  }

  Future<void> fetchBundle(bool value) async {
    dynamic url;
    if (value == true) {
      url = '$BASE_URL/api/bundles/10';
    } else {
      url = '$BASE_URL/api/bundles';
    }
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      // print(extractedData);
      _bundleItems = buildBundleList(extractedData);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  List<Bundle> buildBundleList(List extractedData) {
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
        averageRating: bundleData['average_rating'],
        numberOfRatings: bundleData['number_of_ratings'],
      ));
      // print(catData['name']);
    }
    return loadedBundle;
  }

  Future<void> fetchBundleDetailById(int bundleId) async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    dynamic url;
    if (authToken != null) {
      url = '$BASE_URL/api/bundle_courses/$bundleId?auth_token=$authToken';
    } else {
      url = '$BASE_URL/api/bundle_courses/$bundleId';
    }

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
          subscriptionStatus: bundleData['subscription_status'],
          bundleCourses:
              buildBundleCourses(bundleData['bundle_courses'] as List<dynamic>),
        ));
      }
      _bundleDetailsitems = loadedBundleDetails;

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  List<BundleCourses> buildBundleCourses(List extractedBundleCourse) {
    final List<BundleCourses> loadedBundleCourse = [];

    for (var bundleData in extractedBundleCourse) {
      loadedBundleCourse.add(BundleCourses(
        id: bundleData['id'],
        title: bundleData['title'],
        price: bundleData['price'],
        description: bundleData['description'],
        thumbnail: bundleData['thumbnail'],
        isFreeCourse: bundleData['is_free_course'],
        instructorName: bundleData['instructor_name'],
        instructorImage: bundleData['instructor_image'],
        rating: bundleData['rating'],
        numberOfRatings: bundleData['number_of_ratings'],
        totalEnrollment: bundleData['total_enrollment'],
        shareableLink: bundleData['shareable_link'],
        courseOverviewProvider: bundleData['course_overview_provider'],
      ));
    }
    // print(loadedSections.first.title);
    return loadedBundleCourse;
  }
}
