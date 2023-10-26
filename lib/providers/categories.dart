import 'package:elimiafrica/models/all_category.dart';
import 'package:elimiafrica/models/sub_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/category.dart';
import '../constants.dart';

class Categories with ChangeNotifier {
  List<Category> _items = [];
  List<SubCategory> _subItems = [];
  List<AllCategory> _allItems = [];

  List<Category> get items {
    return [..._items];
  }

  List<SubCategory> get subItems {
    return [..._subItems];
  }

  List<AllCategory> get allItems {
    return [..._allItems];
  }

  Future<void> fetchCategories() async {
    var url = '$BASE_URL/api/categories';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      // print(extractedData);
      final List<Category> loadedCategories = [];

      for (var catData in extractedData) {
        loadedCategories.add(Category(
          id: int.parse(catData['id']),
          title: catData['name'],
          thumbnail: catData['thumbnail'],
          numberOfCourses: catData['number_of_courses'],
          numberOfSubCategories: catData['number_of_sub_categories'],
        ));

        // print(catData['name']);
      }
      _items = loadedCategories;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchSubCategories(int catId) async {
    var url = '$BASE_URL/api/sub_categories/$catId';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      // print(extractedData);
      final List<SubCategory> loadedCategories = [];

      for (var catData in extractedData) {
        loadedCategories.add(SubCategory(
          id: int.parse(catData['id']),
          title: catData['name'],
          parent: int.parse(catData['parent']),
          numberOfCourses: catData['number_of_courses'],
        ));

        // print(catData['name']);
      }
      _subItems = loadedCategories;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchAllCategory() async {
    var url = '$BASE_URL/api/all_categories';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // print(extractedData);
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      // print(extractedData);
      final List<AllCategory> loadedCategories = [];

      for (var catData in extractedData) {
        loadedCategories.add(AllCategory(
          id: int.parse(catData['id']),
          title: catData['name'],
          subCategory:
              buildSubCategory(catData['sub_categories'] as List<dynamic>),
        ));

        // print(catData['name']);
      }
      _allItems = loadedCategories;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  List<AllSubCategory> buildSubCategory(List extractedSubCategory) {
    final List<AllSubCategory> loadedSubCategories = [];

    for (var subData in extractedSubCategory) {
      loadedSubCategories.add(AllSubCategory(
        id: int.parse(subData['id']),
        title: subData['name'],
      ));
    }
    // print(loadedLessons.first.title);
    return loadedSubCategories;
  }
}
