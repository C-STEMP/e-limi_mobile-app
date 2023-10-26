import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/lesson.dart';
import 'from_network.dart';
import 'from_vimeo_id.dart';
import 'from_youtube.dart';

class LessonListItem extends StatefulWidget {
  final Lesson? lesson;
  final int courseId;

  const LessonListItem(
      {Key? key, @required this.lesson, required this.courseId})
      : super(key: key);

  @override
  State<LessonListItem> createState() => _LessonListItemState();
}

class _LessonListItemState extends State<LessonListItem> {
  void lessonAction(Lesson lesson) async {
    if (lesson.lessonType == 'video') {
      if (lesson.videoTypeWeb == 'system' ||
          lesson.videoTypeWeb == 'html5' ||
          lesson.videoTypeWeb == 'amazon') {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PlayVideoFromNetwork(
                  courseId: widget.courseId,
                  lessonId: lesson.id!,
                  videoUrl: lesson.videoUrlWeb!)),
        );
      } else if (lesson.videoTypeWeb == 'Vimeo') {
        String vimeoVideoId = lesson.videoUrlWeb!.split('/').last;
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayVideoFromVimeoId(
                  courseId: widget.courseId,
                  lessonId: lesson.id!,
                  vimeoVideoId: vimeoVideoId),
            ));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayVideoFromYoutube(
                  courseId: widget.courseId,
                  lessonId: lesson.id!,
                  videoUrl: lesson.videoUrlWeb!),
            ));
      }
    }
  }

  IconData getLessonIcon(String lessonType) {
    // print(lessonType);
    if (lessonType == 'video') {
      return Icons.play_arrow;
    } else if (lessonType == 'quiz') {
      return Icons.help_outline;
    } else {
      return Icons.attach_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Icon(
                  getLessonIcon(widget.lesson!.lessonType.toString()),
                  size: 14,
                  color: Colors.black45,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(widget.lesson!.title.toString(),
                    style:
                        const TextStyle(fontSize: 14, color: Colors.black45)),
              ),
              if (widget.lesson!.isFree == '1')
                InkWell(
                  onTap: () {
                    lessonAction(widget.lesson!);
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.remove_red_eye_outlined,
                        size: 15,
                        color: kBlueColor,
                      ),
                      Text(
                        ' Preview',
                        style: TextStyle(
                          color: kBlueColor,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
