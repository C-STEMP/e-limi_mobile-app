import 'package:flutter/foundation.dart';

class SubCategory {
  final int? id;
  final String? title;
  final int? parent;
  final int? numberOfCourses;

  SubCategory({
    @required this.id,
    @required this.title,
    @required this.parent,
    @required this.numberOfCourses,
  });
}
