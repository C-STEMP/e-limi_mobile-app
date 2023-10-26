import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../constants.dart';
import '../widgets/star_display_widget.dart';
import '../screens/my_course_detail_screen.dart';
import '../models/my_course.dart';
import '../widgets/custom_text.dart';
import 'package:http/http.dart' as http;

class MyCourseGrid extends StatefulWidget {
  final MyCourse? myCourse;

  const MyCourseGrid({
    Key? key,
    @required this.myCourse,
  }) : super(key: key);

  @override
  State<MyCourseGrid> createState() => _MyCourseGridState();
}

class _MyCourseGridState extends State<MyCourseGrid> {
  dynamic liveClassStatus = false;
  dynamic courseForumStatus = false;

  @override
  void initState() {
    super.initState();
    addonStatus('live-class');
    addonStatus('forum');
  }

  Future<void> addonStatus(String identifier) async {
    var url = '$BASE_URL/api/addon_status?unique_identifier=$identifier';
    final response = await http.get(Uri.parse(url));
    if (identifier == 'live-class') {
      setState(() {
        liveClassStatus = json.decode(response.body)['status'];
      });
    } else if (identifier == 'forum') {
      setState(() {
        courseForumStatus = json.decode(response.body)['status'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.of(context).pushNamed(MyCourseDetailScreen.routeName,
        //     arguments: {'id': myCourse!.id, 'len': 3});
        var tabLength = 1;
        if (liveClassStatus == true && courseForumStatus == true) {
          tabLength = tabLength + 2;
        } else if (liveClassStatus == true || courseForumStatus == true) {
          tabLength = tabLength + 1;
        } else if (tabLength == 1) {
          tabLength = 2;
        }
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return MyCourseDetailScreen(
              courseId: widget.myCourse!.id!.toInt(),
              len: tabLength,
              enableDripContent: widget.myCourse!.enableDripContent.toString());
        }));
        // if (widget.myCourse!.enableDripContent == '0') {
        //   Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        //     return MyCourseDetailScreen(
        //         courseId: widget.myCourse!.id!.toInt(),
        //         len: tabLength,
        //         enableDripContent:
        //             widget.myCourse!.enableDripContent.toString());
        //   }));
        // } else {
        //   Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        //     return DripCOntentCourse(
        //         courseId: widget.myCourse!.id!.toInt(),
        //         len: tabLength,
        //         enableDripContent:
        //             widget.myCourse!.enableDripContent.toString());
        //   }));
        // }
      },
      child: SizedBox(
        width: double.infinity,
        // height: 400,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0.1,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/loading_animated.gif',
                      image: widget.myCourse!.thumbnail.toString(),
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 5, right: 8, left: 8, top: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 42,
                      child: CustomText(
                        text: widget.myCourse!.title!.length < 38
                            ? widget.myCourse!.title
                            : widget.myCourse!.title!.substring(0, 37),
                        fontSize: 14,
                        colors: kTextLightColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 80,
                            child: StarDisplayWidget(
                              value: widget.myCourse!.rating!.toInt(),
                              filledStar: const Icon(
                                Icons.star,
                                color: kStarColor,
                                size: 15,
                              ),
                              unfilledStar: const Icon(
                                Icons.star_border,
                                color: kStarColor,
                                size: 15,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 40,
                            child: Text(
                              '( ${widget.myCourse!.totalNumberRating}.0 )',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: LinearPercentIndicator(
                        lineHeight: 8.0,
                        percent: widget.myCourse!.courseCompletion! / 100,
                        progressColor: kRedColor,
                        backgroundColor: kBackgroundColor,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomText(
                              text:
                                  '${widget.myCourse!.courseCompletion}% Completed',
                              fontSize: 12,
                              colors: Colors.black54,
                            ),
                          ),
                          CustomText(
                            text:
                                '${widget.myCourse!.totalNumberOfCompletedLessons}/${widget.myCourse!.totalNumberOfLessons}',
                            fontSize: 12,
                            colors: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
