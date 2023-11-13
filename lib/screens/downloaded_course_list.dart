import 'dart:io';

import 'package:elimiafrica/models/course_db_model.dart';
import 'package:elimiafrica/models/video_db_model.dart';
import 'package:elimiafrica/providers/database_helper.dart';
import 'package:elimiafrica/screens/download_list_screen.dart';
import 'package:elimiafrica/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../constants.dart';

class DownloadedCourseList extends StatefulWidget {
  static const routeName = '/downloaded-course';
  const DownloadedCourseList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DownloadedCourseListState createState() => _DownloadedCourseListState();
}

class _DownloadedCourseListState extends State<DownloadedCourseList> {
  String? path;

  List<VideoModel> listVideos = [];
  List<int> courseArr = [];


  Future<List<Map<String, dynamic>>?> getVideos() async {
    List<Map<String, dynamic>> listMap =
        await DatabaseHelper.instance.queryAllRows('video_list');
    setState(() {
      for (var map in listMap) {
        // File checkPath = File("${map['path']}/${map['title']}");
        // if(checkPath.existsSync()) {
        //   listVideos.add(VideoModel.fromMap(map));
        //   courseArr.add(map['course_id']);
        // } else {
        //   DatabaseHelper.instance.removeVideo(map['id']);
        // }
        listVideos.add(VideoModel.fromMap(map));
      }
    });
    return null;
  }

  // Future<List<Map<String, dynamic>>?> getCourse() async {
  //   List<Map<String, dynamic>> listMap =
  //       await DatabaseHelper.instance.queryAllRows('course_list');
    
  //   for (var map in listMap) {
  //     if(!courseArr.contains(map['course_id'])){
  //       await DatabaseHelper.instance.removeCourse(map['course_id']);
  //       await DatabaseHelper.instance.removeCourseSection(map['course_id']);
  //     }
  //   }

  //   return null;
  // }

  @override
  void initState() {
    getVideos();
    // getCourse();
    super.initState();
  }

  lessonCounter(courseId) {
    var count = 0;
    for (int i = 0; i < listVideos.length; i++) {
      VideoModel getVideo = listVideos[i];
      File checkPath = File("${getVideo.path}/${getVideo.title}");
      if(checkPath.existsSync()) {
        if (getVideo.courseId == courseId) {
          count = count + 1;
        }
      } else {
        DatabaseHelper.instance.removeVideo(getVideo.id!);
      }
    }
    return CustomText(
      text: 'Total Lessons: $count',
      fontSize: 12,
      colors: Colors.black54,
    );
  }

  // lessonCount(courseId) {
  //   var count = 0;
  //   for (int i = 0; i < listVideos.length; i++) {
  //     VideoModel getVideo = listVideos[i];
  //     File checkPath = File("${getVideo.path}/${getVideo.title}");
  //     if(checkPath.existsSync()) {
  //       if (getVideo.courseId == courseId) {
  //         count = count + 1;
  //       }
  //     } else {
  //       DatabaseHelper.instance.removeVideo(getVideo.id!);
  //     }
  //   }
  //   return count;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Downloaded Course"),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 17),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: FutureBuilder<List<CourseDbModel>>(
        future: DatabaseHelper.instance.getCourse(),
        builder: (BuildContext context,
            AsyncSnapshot<List<CourseDbModel>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text('Loading...'));
          }
          return snapshot.data!.isEmpty
              ? Center(
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .15),
                      Image.asset(
                        "assets/images/no_connection.png",
                        height: MediaQuery.of(context).size.height * .35,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(
                          'No lessons downloaded yet',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                )
              : AlignedGridView.count(
                  padding: const EdgeInsets.all(10.0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return DownloadListScreen(
                            courseId: snapshot.data![index].courseId,
                            title: snapshot.data![index].courseTitle,
                          );
                        }));
                      },
                      child: SizedBox(
                        width: double.infinity,
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
                                      placeholder:
                                          'assets/images/loading_animated.gif',
                                      image: snapshot.data![index].thumbnail,
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 5, right: 8, left: 8, top: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 60,
                                      child: CustomText(
                                        text: snapshot.data![index].courseTitle
                                                    .length <
                                                38
                                            ? snapshot.data![index].courseTitle
                                            : snapshot.data![index].courseTitle
                                                .substring(0, 37),
                                        fontSize: 14,
                                        colors: kTextLightColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    lessonCounter(
                                        snapshot.data![index].courseId),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }, 
                  mainAxisSpacing: 5.0,
                  crossAxisSpacing: 5.0,
                );
        },
      ),
    );
  }
}
