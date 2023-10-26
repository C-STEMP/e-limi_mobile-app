import 'dart:convert';
import 'dart:io';
import 'package:elimiafrica/models/forum_questions_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'shared_pref_helper.dart';

class CourseForum with ChangeNotifier {
  List<ForumQuestions> _questions = [];

  List<ForumQuestions> get questions {
    return [..._questions];
  }

  Future<void> fetchCourseQuestions(int courseId, int pageNumber) async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url = '$BASE_URL/api/forum_questions/$authToken/$courseId/$pageNumber';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      // print(extractedData);
      _questions = buildQuestionList(extractedData);
      notifyListeners();
      if (response.statusCode == 403) {
        _questions = [];
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchCourseSearchQuestions(int courseId, String keyWord) async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url =
        '$BASE_URL/api/search_forum_questions/$authToken/$courseId?search=$keyWord';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      // print(extractedData);
      _questions = buildQuestionList(extractedData);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  List<ForumQuestions> buildQuestionList(List extractedData) {
    final List<ForumQuestions> loadedQuestions = [];
    for (var questionData in extractedData) {
      loadedQuestions.add(ForumQuestions(
        id: questionData['id'],
        userId: questionData['user_id'],
        courseId: questionData['course_id'],
        title: questionData['title'],
        description: questionData['description'],
        upvotedUserId: questionData['upvoted_user_id'],
        isParent: questionData['is_parent'],
        dateAdded: questionData['date_added'],
        userName: questionData['user_name'],
        userImage: questionData['user_image'],
        upvotedUserNumber: questionData['upvoted_user_number'],
        commentNumber: questionData['comment_number'],
        isLiked: questionData['is_liked'],
      ));
    }
    return loadedQuestions;
  }

  Future<void> addForumQuestion(
      int courseId, String title, String description) async {
    final token = await SharedPreferenceHelper().getAuthToken();
    var url = '$BASE_URL/api/forum_add_questions/$courseId';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'auth_token': token,
          'title': title,
          'description': description,
        },
      );
      final responseData = json.decode(response.body);
      if (responseData == null) {
        return;
      }
      if (responseData['status'] == 403) {
        throw const HttpException('Update Failed');
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchForumChildQuestion(String questionId) async {
    var url = '$BASE_URL/api/forum_child_questions/$questionId';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      _questions = buildQuestionList(extractedData);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> toggleForumQuestionVote(String questionId) async {
    final token = await SharedPreferenceHelper().getAuthToken();
    var url = '$BASE_URL/api/forum_question_vote/$questionId/$token/';
    // print(url);
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      var check = extractedData['total'];
      if (check == 'upvoted') {
        for (int i = 0; i < _questions.length; i++) {
          if (_questions[i].id == questionId) {
            _questions[i].isLiked = true;
            notifyListeners();
          }
        }
      } else {
        for (int i = 0; i < _questions.length; i++) {
          if (_questions[i].id == questionId) {
            _questions[i].isLiked = false;
            notifyListeners();
          }
        }
      }
    } catch (error) {
      rethrow;
    }
  }
}
