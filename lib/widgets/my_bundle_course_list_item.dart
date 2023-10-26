import 'dart:convert';
import 'package:elimiafrica/models/common_functions.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../screens/mcbd_one.dart';
import '../screens/mcbd_three.dart';
import '../screens/mcbd_two.dart';
import '../widgets/star_display_widget.dart';
import 'custom_text.dart';
import 'package:http/http.dart' as http;

class MyBundleCourseListItem extends StatefulWidget {
  final int? bundleId;
  final String? subscriptionStatus;
  final int? id;
  final String? title;
  final String? thumbnail;
  final int? rating;
  final String? price;
  final int? numberOfRatings;
  final String? instructorName;
  final String? instructorImage;

  const MyBundleCourseListItem({
    Key? key,
    @required this.bundleId,
    @required this.subscriptionStatus,
    @required this.id,
    @required this.title,
    @required this.thumbnail,
    @required this.rating,
    @required this.price,
    @required this.numberOfRatings,
    @required this.instructorName,
    @required this.instructorImage,
  }) : super(key: key);

  @override
  State<MyBundleCourseListItem> createState() => _MyBundleCourseListItemState();
}

class _MyBundleCourseListItemState extends State<MyBundleCourseListItem> {
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
        if (widget.subscriptionStatus == 'valid') {
          if (liveClassStatus == true && courseForumStatus == true) {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return McbdThree(
                bundleId: widget.bundleId!.toInt(),
                courseId: widget.id!.toInt(),
              );
            }));
          } else if (liveClassStatus == true || courseForumStatus == true) {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return McbdTwo(
                bundleId: widget.bundleId!.toInt(),
                courseId: widget.id!.toInt(),
              );
            }));
          } else {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return McbdOne(
                bundleId: widget.bundleId!.toInt(),
                courseId: widget.id!.toInt(),
              );
            }));
          }
        } else {
          CommonFunctions.showWarningToast('Subscription expired');
        }
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/loading_animated.gif',
                    image: widget.thumbnail.toString(),
                    width: 80,
                    height: 85,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      widget.title.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: kTextColor,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 11,
                          backgroundImage:
                              NetworkImage(widget.instructorImage.toString()),
                          backgroundColor: kLightBlueColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: CustomText(
                            text: widget.instructorName,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 80,
                          child: StarDisplayWidget(
                            value: widget.rating!,
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
                            '( ${widget.rating}.0 )',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Text(
                            '${widget.numberOfRatings} +Ratings',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
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
        ),
      ),
    );
  }
}
