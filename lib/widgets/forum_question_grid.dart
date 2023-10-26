import 'dart:convert';
import 'dart:io';
import 'package:elimiafrica/models/common_functions.dart';
import 'package:elimiafrica/models/forum_questions_model.dart';
import 'package:elimiafrica/providers/course_forum.dart';
import 'package:elimiafrica/providers/shared_pref_helper.dart';
import 'package:elimiafrica/screens/forum_reply_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'custom_text.dart';

class ForumQuestionGrid extends StatefulWidget {
  final ForumQuestions question;
  final int index;
  final String userId;
  final ValueChanged<dynamic> deleteQuestion;
  const ForumQuestionGrid(
      {Key? key,
      required this.question,
      required this.index,
      required this.userId,
      required this.deleteQuestion})
      : super(key: key);

  @override
  State<ForumQuestionGrid> createState() => _ForumQuestionGridState();
}

class _ForumQuestionGridState extends State<ForumQuestionGrid> {
  bool? isLiked;
  dynamic likedNumber;
  dynamic commentNumber;

  @override
  void initState() {
    isLiked = widget.question.isLiked;
    likedNumber = widget.question.upvotedUserNumber;
    commentNumber = widget.question.commentNumber;
    super.initState();
  }

  Future<void> toggleLike() async {
    try {
      await Provider.of<CourseForum>(context, listen: false)
          .toggleForumQuestionVote(widget.question.id.toString());
      if (isLiked == true) {
        setState(() {
          isLiked = false;
          likedNumber = likedNumber - 1;
        });
      } else if (isLiked == false) {
        setState(() {
          isLiked = true;
          likedNumber = likedNumber + 1;
        });
      }
    } catch (error) {
      rethrow;
    }
  }

  void updateCommentNumber(dynamic task) {
    if (task == 'add') {
      setState(() {
        commentNumber = commentNumber + 1;
      });
    } else if (task == 'sub') {
      setState(() {
        commentNumber = commentNumber - 1;
      });
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
          widget.deleteQuestion(widget.index);
          CommonFunctions.showSuccessToast('Reply has been deleted');
        }
      }
    } catch (error) {
      CommonFunctions.showSuccessToast(error.toString());
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    var dt = DateTime.fromMillisecondsSinceEpoch(
        int.parse(widget.question.dateAdded.toString()) * 1000);
    // 12 Hour format:
    var date = DateFormat('dd-MMM-yyyy').format(dt);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(widget.question.userImage.toString()),
            backgroundColor: Colors.grey,
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: widget.question.title,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    // horizontal: 10,
                    vertical: 10,
                  ),
                  child: CustomText(
                    text: widget.question.description,
                    fontSize: 15,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    // horizontal: 10,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      CustomText(
                        text: widget.question.userName,
                        fontSize: 15,
                      ),
                      const Text('-'),
                      Expanded(
                        flex: 1,
                        child: CustomText(
                          text: date,
                          colors: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                      if (widget.userId == widget.question.userId)
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            _delete(
                                widget.question.id.toString(), widget.index);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForumReplyScreen(
                              photo: widget.question.userImage.toString(),
                              name: widget.question.userName.toString(),
                              title: widget.question.title.toString(),
                              descrption:
                                  widget.question.description.toString(),
                              date: widget.question.dateAdded.toString(),
                              questionId: widget.question.id.toString(),
                              updateCommentNumber: updateCommentNumber,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.question_answer_outlined),
                      iconSize: 22,
                    ),
                    Text(
                      '( $commentNumber )',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: toggleLike,
                        icon: const Icon(Icons.thumb_up_off_alt),
                        iconSize: 22,
                        color: isLiked! ? kBlueColor : Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        '( $likedNumber )',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
