import 'package:flutter/cupertino.dart';

import '../models/lesson.dart';

class Section {
  int? id;
  int? numberOfCompletedLessons;
  String? title;
  String? totalDuration;
  int? lessonCounterStarts;
  int? lessonCounterEnds;
  List<Lesson>? mLesson;

  Section({
    @required this.id,
    @required this.numberOfCompletedLessons,
    @required this.title,
    @required this.totalDuration,
    @required this.lessonCounterEnds,
    @required this.lessonCounterStarts,
    @required this.mLesson,
  });
}
