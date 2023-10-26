// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:pod_player/pod_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/my_courses.dart';
import '../providers/shared_pref_helper.dart';
import 'package:http/http.dart' as http;

class PlayVideoFromNetwork extends StatefulWidget {
  static const routeName = '/fromNetwork';
  final int courseId;
  final int? lessonId;
  final String videoUrl;
  const PlayVideoFromNetwork(
      {Key? key, required this.courseId, this.lessonId, required this.videoUrl})
      : super(key: key);

  @override
  State<PlayVideoFromNetwork> createState() => _PlayVideoFromAssetState();
}

class _PlayVideoFromAssetState extends State<PlayVideoFromNetwork> {
  late final PodPlayerController controller;

  Timer? timer;

  @override
  void initState() {
    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.networkQualityUrls(
        videoUrls: [
          VideoQalityUrls(
            quality: 360,
            url: widget.videoUrl,
          ),
          VideoQalityUrls(
            quality: 720,
            url: widget.videoUrl,
          ),
        ],
      ),
    )..initialise();
    super.initState();

    if (widget.lessonId != null) {
      timer = Timer.periodic(
          const Duration(seconds: 5), (Timer t) => updateWatchHistory());
    }
  }

  Future<void> updateWatchHistory() async {
    if (controller.isVideoPlaying) {
      var token = await SharedPreferenceHelper().getAuthToken();
      dynamic url;
      if (token != null && token.isNotEmpty) {
        url = "$BASE_URL/api/update_watch_history/$token";
        // print(url);
        // print(controller.currentVideoPosition.inSeconds);
        try {
          final response = await http.post(
            Uri.parse(url),
            body: {
              'course_id': widget.courseId.toString(),
              'lesson_id': widget.lessonId.toString(),
              'current_duration':
                  controller.currentVideoPosition.inSeconds.toString(),
            },
          );

          final responseData = json.decode(response.body);
          // print(responseData);
          if (responseData == null) {
            return;
          } else {
            var isCompleted = responseData['is_completed'];
            if (isCompleted == 1) {
              Provider.of<MyCourses>(context, listen: false)
                  .updateDripContendLesson(
                      widget.courseId,
                      responseData['course_progress'],
                      responseData['number_of_completed_lessons']);
            }
          }
        } catch (error) {
          rethrow;
        }
      } else {
        return;
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    if (widget.lessonId != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kBackgroundColor,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Center(
          child: PodVideoPlayer(
            controller: controller,
            podProgressBarConfig: const PodProgressBarConfig(
              padding: kIsWeb
                  ? EdgeInsets.zero
                  : EdgeInsets.only(
                      bottom: 20,
                      left: 20,
                      right: 20,
                    ),
              playingBarColor: Colors.blue,
              circleHandlerColor: Colors.blue,
              backgroundColor: Colors.blueGrey,
            ),
          ),
        ),
      ),
    );
  }
}
