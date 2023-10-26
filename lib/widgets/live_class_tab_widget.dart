// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:convert';
import 'package:elimiafrica/models/live_class_model.dart';
import 'package:elimiafrica/providers/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../screens/webview_screen.dart';
import 'custom_text.dart';
import 'package:http/http.dart' as http;

class LiveClassTabWidget extends StatefulWidget {
  final int courseId;
  const LiveClassTabWidget({Key? key, required this.courseId})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LiveClassTabWidgetState createState() => _LiveClassTabWidgetState();
}

class _LiveClassTabWidgetState extends State<LiveClassTabWidget> {
  dynamic token;

  Future<LiveClassModel>? futureLiveClassModel;

  Future<LiveClassModel> fetchLiveClassModel() async {
    token = await SharedPreferenceHelper().getAuthToken();
    var url =
        '$BASE_URL/api/zoom_live_class?course_id=${widget.courseId}&auth_token=$token';
    try {
      final response = await http.get(Uri.parse(url));

      return LiveClassModel.fromJson(json.decode(response.body));
    } catch (error) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    futureLiveClassModel = fetchLiveClassModel();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LiveClassModel>(
      future: futureLiveClassModel,
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * .50,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (dataSnapshot.error != null) {
            //error
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 15),
                  child: Container(
                    width: double.infinity,
                    color: kNoteColor,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      child: Text(
                        'No live class is scheduled to this course yet. Please come back later.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          wordSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            var dt = DateTime.fromMillisecondsSinceEpoch(int.parse(
                    dataSnapshot.data!.zoomLiveClassDetails!.time.toString()) *
                1000);
            // 12 Hour format:
            var date = DateFormat('hh:mm a : E, dd MMM yyyy').format(dt);
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25.0, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.event_available,
                        color: Colors.black45,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6.0),
                        child: CustomText(
                          text: 'Zoom live class schedule',
                          fontSize: 15,
                          colors: kTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomText(
                  text: date,
                  fontSize: 18,
                  colors: kTextColor,
                  // fontWeight: FontWeight.bold,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 15),
                  child: Container(
                    width: double.infinity,
                    color: kNoteColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      child: Text(
                        dataSnapshot.data!.zoomLiveClassDetails!.noteToStudents
                            .toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          wordSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final token = await SharedPreferenceHelper().getAuthToken();
                    final url =
                        '$BASE_URL/api/zoom_mobile_web_view/${widget.courseId}/$token';
                    // print(_url);
                    Navigator.of(context)
                        .pushNamed(WebViewScreen.routeName, arguments: url);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    primary: kRedColor,
                  ),
                  icon: const Icon(
                    Icons.videocam_rounded,
                  ),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: CustomText(
                      text: 'Join live video class',
                      fontSize: 17,
                      colors: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          }
        }
      },
    );
  }
}
