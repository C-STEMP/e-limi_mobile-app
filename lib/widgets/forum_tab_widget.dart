// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:elimiafrica/models/forum_questions_model.dart';
import 'package:elimiafrica/providers/course_forum.dart';
import 'package:elimiafrica/providers/shared_pref_helper.dart';
import 'package:elimiafrica/screens/search_forum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'ask_question_widget.dart';
import 'forum_question_grid.dart';

class ForumTabWidget extends StatefulWidget {
  final int courseId;
  const ForumTabWidget({Key? key, required this.courseId}) : super(key: key);

  @override
  State<ForumTabWidget> createState() => _ForumTabWidgetState();
}

class _ForumTabWidgetState extends State<ForumTabWidget> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _xcrollController = ScrollController();
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  var _isInit = true;
  var _isLoading = false;
  dynamic userId;
  List<ForumQuestions> activeQuestions = [];
  List<ForumQuestions> fetchMoreList = [];
  int _page = 1;
  bool _showLoadingContainer = false;
  dynamic listStatus;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    updatedQuestionList();
    getUserInfo();
    _xcrollController.addListener(() {
      if (_xcrollController.position.pixels ==
          _xcrollController.position.maxScrollExtent) {
        setState(() {
          _page++;
        });
        _showLoadingContainer = true;
        fetchMore();
      }
    });
  }

  fetchMore() async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url =
        '$BASE_URL/api/forum_questions/$authToken/${widget.courseId}/$_page';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      if (extractedData.isEmpty) {
        listStatus = 403;
        return;
      }
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
      setState(() {
        activeQuestions.addAll(loadedQuestions);
      });

      _isInit = false;

      _showLoadingContainer = false;
      await Provider.of<CourseForum>(context, listen: false)
          .fetchCourseQuestions(widget.courseId, _page);
      setState(() {});
      // }
    } catch (e) {
      rethrow;
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<CourseForum>(context, listen: false)
          .fetchCourseQuestions(widget.courseId, _page)
          .then((_) {
        setState(() {
          _isLoading = false;
          activeQuestions =
              Provider.of<CourseForum>(context, listen: false).questions;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  updatedQuestionList() async {
    setState(() {
      _isLoading = true;
    });
    activeQuestions.clear();
    await Provider.of<CourseForum>(context, listen: false)
        .fetchCourseQuestions(widget.courseId, 1)
        .then((_) {
      setState(() {
        _isLoading = false;
        activeQuestions =
            Provider.of<CourseForum>(context, listen: false).questions;
      });
    });
  }

  Future<void> getUserInfo() async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url = '$BASE_URL/api/userdata?auth_token=$authToken';
    try {
      if (authToken == null) {
        throw const HttpException('No Auth User');
      }
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);
      setState(() {
        userId = responseData['id'];
      });
    } catch (error) {
      rethrow;
    }
  }

  void deleteQuestion(dynamic index) {
    setState(() {
      activeQuestions.removeAt(index);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _xcrollController.dispose();
    super.dispose();
  }

  Container buildLoadingContainer() {
    return Container(
      height: _showLoadingContainer ? 20 : 0,
      width: double.infinity,
      color: kBackgroundColor,
      child: Center(
        child: Text(
            listStatus == 403
                ? "No More Questions"
                : "Loading More Questions ...",
            style: const TextStyle(
              color: Colors.black,
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          forumBody(),
          Align(
            alignment: Alignment.bottomCenter,
            child: buildLoadingContainer(),
          ),
        ],
      ),
    );
  }

  forumBody() {
    if (_isInit && activeQuestions.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          updatedQuestionList();
          setState(() {});
        },
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                controller: _xcrollController,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Column(
                    children: [
                      Form(
                        key: globalFormKey,
                        child: TextFormField(
                          style: const TextStyle(
                            fontSize: 17.0,
                          ),
                          textInputAction: TextInputAction.search,
                          keyboardType: TextInputType.text,
                          controller: _controller,
                          onFieldSubmitted: (String value) async {
                            final String searchValue = _controller.text;
                            if (!globalFormKey.currentState!.validate()) {
                              return;
                            }
                            if (searchValue.isNotEmpty) {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchForum(
                                      courseId: widget.courseId,
                                      keyWord: _controller.text),
                                ),
                              );
                              refreshKey.currentState!.show();
                            }
                          },
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide:
                                  BorderSide(color: Colors.black12, width: 1),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide:
                                  BorderSide(color: Colors.black12, width: 1),
                            ),
                            suffixIcon: MaterialButton(
                              onPressed: () async {
                                final String searchValue = _controller.text;
                                if (!globalFormKey.currentState!.validate()) {
                                  return;
                                }
                                if (searchValue.isNotEmpty) {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SearchForum(
                                          courseId: widget.courseId,
                                          keyWord: _controller.text),
                                    ),
                                  );
                                  refreshKey.currentState!.show();
                                }
                              },
                              color: kRedColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadiusDirectional.circular(10),
                                // side: const BorderSide(color: kRedColor),
                              ),
                              child: const Icon(
                                Icons.search,
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black12,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            filled: true,
                            hintStyle:
                                const TextStyle(color: Color(0xFFB3B3B3)),
                            hintText: "Search questions...",
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.only(left: 15),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              "${activeQuestions.length} Questions in this course."),
                          TextButton(
                            onPressed: () async {
                              //Use await and then navigate to report page
                              await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => AskQuestionWidget(
                                          courseId: widget.courseId)));
                              //After popped back from report page call refresh indicator to refresh page
                              refreshKey.currentState!.show();
                            },
                            child: const Text('Ask a new question'),
                          ),
                        ],
                      ),
                      const Divider(),
                      ListView.builder(
                        controller: _scrollController,
                        itemCount: activeQuestions.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, index) {
                          return ForumQuestionGrid(
                            question: activeQuestions[index],
                            index: index,
                            userId: userId.toString(),
                            deleteQuestion: deleteQuestion,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
              ),
      );
    }
  }
}
