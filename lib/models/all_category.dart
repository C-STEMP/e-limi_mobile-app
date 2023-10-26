import 'package:flutter/foundation.dart';

class AllCategory {
  final int? id;
  final String? title;
  List<AllSubCategory> subCategory;

  AllCategory({
    @required this.id,
    @required this.title,
    required this.subCategory
  });
}

class AllSubCategory {
  final int? id;
  final String? title;

  AllSubCategory({
    this.id,
    this.title
  });
}