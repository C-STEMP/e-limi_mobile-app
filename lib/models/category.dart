import 'package:flutter/foundation.dart';

class Category {
  final int? id;
  final String? title;
  final String? thumbnail;
  final int? numberOfCourses;
  final int? numberOfSubCategories;

  Category({
    @required this.id,
    @required this.title,
    @required this.thumbnail,
    @required this.numberOfCourses,
    @required this.numberOfSubCategories,
  });
}
