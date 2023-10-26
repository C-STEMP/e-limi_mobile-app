import 'package:flutter/foundation.dart';

class Bundle {
  int? id;
  int? userId;
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

  Bundle({
    @required this.id,
    @required this.userId,
    @required this.title,
    @required this.banner,
    @required this.courseIds,
    @required this.subscriptionLimit,
    @required this.price,
    @required this.bundleDetails,
    @required this.status,
    @required this.dateAdded,
    this.userName,
    this.userImage,
    @required this.averageRating,
    @required this.numberOfRatings,
    this.subscriptionStatus,
  });
}
