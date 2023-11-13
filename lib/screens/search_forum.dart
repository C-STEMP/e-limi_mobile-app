import 'dart:convert';
import 'dart:io';
import 'package:elimiafrica/constants.dart';
import 'package:elimiafrica/models/forum_questions_model.dart';
import 'package:elimiafrica/providers/course_forum.dart';
import 'package:elimiafrica/providers/shared_pref_helper.dart';
import 'package:elimiafrica/widgets/app_bar_two.dart';
import 'package:elimiafrica/widgets/ask_question_widget.dart';
import 'package:elimiafrica/widgets/forum_question_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SearchForum extends StatefulWidget {
  final int courseId;
  final String keyWord;
  const SearchForum({Key? key, required this.courseId, required this.keyWord})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SearchForumState createState() => _SearchForumState();
}

class _SearchForumState extends State<SearchForum> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  var _isInit = true;
  var _isLoading = false;
  List<ForumQuestions> activeQuestions = [];
  dynamic userId;

  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      _controller.text = widget.keyWord;

      Provider.of<CourseForum>(context, listen: false)
          .fetchCourseSearchQuestions(widget.courseId, widget.keyWord)
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

  reset() async {
    setState(() {
      _isLoading = true;
    });
    activeQuestions.clear();
    await Provider.of<CourseForum>(context, listen: false)
        .fetchCourseSearchQuestions(widget.courseId, _controller.text)
        .then((_) {
      setState(() {
        _isLoading = false;
        activeQuestions =
            Provider.of<CourseForum>(context, listen: false).questions;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarTwo(),
      backgroundColor: kBackgroundColor,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: kPrimaryColor.withOpacity(0.7)),
            )
          : SingleChildScrollView(
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
                        onFieldSubmitted: (String value) {
                          final String searchValue = _controller.text;
                          if (!globalFormKey.currentState!.validate()) {
                            return;
                          }
                          if (searchValue.isNotEmpty) {
                            reset();
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
                                reset();
                              }
                            },
                            color: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadiusDirectional.circular(10),
                              // side: const BorderSide(color: kPrimaryColor),
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
                          hintStyle: const TextStyle(color: Color(0xFFB3B3B3)),
                          hintText: "Search questions...",
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.only(left: 15),
                        ),
                      ),
                    ),
                    searchBody(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget searchBody() {
    if (_isInit && activeQuestions.isEmpty) {
      return SingleChildScrollView(
        child: SizedBox(
            height: MediaQuery.of(context).size.height * .5,
            child: const Center(child: CircularProgressIndicator())),
      );
    } else {
      return RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          reset();
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Found ${activeQuestions.length} Questions."),
                    TextButton(
                      onPressed: () async {
                        //Use await and then navigate to report page
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                AskQuestionWidget(courseId: widget.courseId)));
                        //After popped back from report page call refresh indicator to refresh page
                        refreshKey.currentState!.show();
                      },
                      child: const Text('Ask a new question'),
                    ),
                  ],
                ),
              ),
              const Divider(),
              ListView.builder(
                itemCount: activeQuestions.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, index) {
                  // return Text(activeQuestions.length.toString());
                  return ForumQuestionGrid(
                    question: activeQuestions[index],
                    index: index,
                    userId: userId.toString(),
                    deleteQuestion: deleteQuestion,
                  );
                },
              ),
            ],
          ),
        ),
      );
    }
  }
}
