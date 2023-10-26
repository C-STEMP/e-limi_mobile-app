import 'dart:convert';
import 'dart:io';

import 'package:elimiafrica/constants.dart';
import 'package:elimiafrica/models/common_functions.dart';
import 'package:elimiafrica/models/forum_questions_model.dart';
import 'package:elimiafrica/providers/course_forum.dart';
import 'package:elimiafrica/providers/shared_pref_helper.dart';
import 'package:elimiafrica/widgets/app_bar_two.dart';
import 'package:elimiafrica/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ForumReplyScreen extends StatefulWidget {
  final String photo;
  final String name;
  final String title;
  final String descrption;
  final String date;
  final String questionId;
  final ValueChanged<dynamic>? updateCommentNumber;
  const ForumReplyScreen({
    Key? key,
    required this.photo,
    required this.name,
    required this.title,
    required this.descrption,
    required this.date,
    required this.questionId,
    this.updateCommentNumber,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ForumReplyScreenState createState() => _ForumReplyScreenState();
}

class _ForumReplyScreenState extends State<ForumReplyScreen> {
  var _isInit = true;
  var _isLoading = false;
  dynamic text;
  dynamic userId;
  List<ForumQuestions> activeQuestions = [];

  final TextEditingController _textController = TextEditingController();

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

      Provider.of<CourseForum>(context, listen: false)
          .fetchForumChildQuestion(widget.questionId)
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

  Future<void> _reply() async {
    var token = await SharedPreferenceHelper().getAuthToken();
    // print(widget.questionId);
    if (_textController.text.isEmpty) {
      // Invalid!
      return;
    }
    try {
      var url = "$BASE_URL/api/add_questions_reply/${widget.questionId}";
      final response = await http.post(Uri.parse(url), body: {
        'auth_token': token,
        'description': text,
      });
      if (response.statusCode == 200) {
        _textController.clear();
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForumReplyScreen(
              photo: widget.photo,
              name: widget.name,
              title: widget.title,
              descrption: widget.descrption,
              date: widget.date,
              questionId: widget.questionId,
              updateCommentNumber: widget.updateCommentNumber,
            ),
          ),
        );
        widget.updateCommentNumber!('add');
        CommonFunctions.showSuccessToast('Reply Posted');
        activeQuestions.clear();
      }
    } catch (error) {
      // print(error);
      const errorMsg = 'Could not post reply';
      CommonFunctions.showSuccessToast(errorMsg);
    }
  }

  Future<void> _delete(String questionId, int index) async {
    var token = await SharedPreferenceHelper().getAuthToken();
    var url = "$BASE_URL/api/forum_question_delete/$questionId/$token";
    try {
      final response = await http.get(Uri.parse(url));
      // print(url);
      // print(response.statusCode);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] != 200) {
          throw const HttpException('Could not remove.');
        } else {
          setState(() {
            activeQuestions.removeAt(index);
          });
          CommonFunctions.showSuccessToast('Reply has been deleted');
          widget.updateCommentNumber!('sub');
        }
      }
    } catch (error) {
      CommonFunctions.showSuccessToast(error.toString());
      rethrow;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dt = DateTime.fromMillisecondsSinceEpoch(int.parse(widget.date) * 1000);
    // 12 Hour format:
    var date = DateFormat('dd MMM yyyy').format(dt);
    return Scaffold(
      appBar: CustomAppBarTwo(),
      backgroundColor: kBackgroundColor,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(widget.photo),
                            backgroundColor: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  widget.title,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 10, left: 10, top: 10.0),
                                child: CustomText(
                                  text: widget.descrption,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: [
                                    Text(widget.name),
                                    Expanded(
                                      flex: 1,
                                      child: CustomText(
                                        text: ' - $date',
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Divider(
                      thickness: 1.0,
                    ),
                  ),
                  if (activeQuestions.isNotEmpty)
                    ListView.builder(
                        itemCount: activeQuestions.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var cmDt = DateTime.fromMillisecondsSinceEpoch(
                              int.parse(activeQuestions[index]
                                      .dateAdded
                                      .toString()) *
                                  1000);
                          // 12 Hour format:
                          var commentDate =
                              DateFormat('dd MMM, yy').format(cmDt);
                          return Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundImage: NetworkImage(
                                              activeQuestions[index]
                                                  .userImage
                                                  .toString()),
                                          backgroundColor: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    activeQuestions[index]
                                                        .userName
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: CustomText(
                                                      text: ' - $commentDate',
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  if (userId ==
                                                      activeQuestions[index]
                                                          .userId)
                                                    IconButton(
                                                      padding: EdgeInsets.zero,
                                                      constraints:
                                                          const BoxConstraints(),
                                                      onPressed: () {
                                                        _delete(
                                                            activeQuestions[
                                                                    index]
                                                                .id
                                                                .toString(),
                                                            index);
                                                      },
                                                      color: kRedColor,
                                                      iconSize: 20,
                                                      tooltip: 'Remove',
                                                      icon: const Icon(
                                                        Icons.delete_outline,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10,
                                                  left: 15,
                                                  top: 10.0),
                                              child: CustomText(
                                                text: activeQuestions[index]
                                                    .description
                                                    .toString(),
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding:
                                      EdgeInsets.only(left: 15.0, right: 15.0),
                                  child: Divider(
                                    thickness: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: _textController,
                            maxLines: null,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 17.0,
                            ),
                            onChanged: (value) {
                              setState(() {
                                text = value;
                                // _isDisable = false;
                              });
                            },
                            textAlign: TextAlign.left,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide:
                                    BorderSide(color: Colors.black12, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide:
                                    BorderSide(color: Colors.black12, width: 1),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 10),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                            ),
                          ),
                        ),
                        const Text("  "),
                        Expanded(
                          flex: 1,
                          child: MaterialButton(
                            color: kRedColor,
                            onPressed: _reply,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusDirectional.circular(5),
                              side: const BorderSide(color: kRedColor),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Reply',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
