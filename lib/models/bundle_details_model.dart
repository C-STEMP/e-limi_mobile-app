import 'bundle_courses_model.dart';

class BundleDetails {
  String? id;
  String? userId;
  String? title;
  String? banner;
  String? courseIds;
  String? subscriptionLimit;
  String? price;
  String? bundleDetails;
  String? status;
  String? dateAdded;
  String? userName;
  String? userImage;
  int? averageRating;
  int? numberOfRatings;
  String? subscriptionStatus;
  List<BundleCourses>? bundleCourses;

  BundleDetails(
      {this.id,
      this.userId,
      this.title,
      this.banner,
      this.courseIds,
      this.subscriptionLimit,
      this.price,
      this.bundleDetails,
      this.status,
      this.dateAdded,
      this.userName,
      this.userImage,
      this.averageRating,
      this.numberOfRatings,
      this.subscriptionStatus,
      this.bundleCourses});
}
