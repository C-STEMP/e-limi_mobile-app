import 'package:elimiafrica/widgets/custom_text.dart';

import '../screens/course_detail_screen.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/star_display_widget.dart';

class CourseGrid extends StatelessWidget {
  final int? id;
  final String? title;
  final String? thumbnail;
  final String? instructorName;
  final String? instructorImage;
  final int? rating;
  final String? price;

  const CourseGrid({
    Key? key,
    @required this.id,
    @required this.title,
    @required this.thumbnail,
    @required this.instructorName,
    @required this.instructorImage,
    @required this.rating,
    @required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(CourseDetailScreen.routeName, arguments: id);
      },
      child: SizedBox(
        width: 200,
        child: Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/loading_animated.gif',
                          image: thumbnail.toString(),
                          height: 130,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 5, right: 8, left: 8, top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                        child: Text(
                          title.toString().length < 41
                              ? title.toString()
                              : '${title.toString().substring(0, 40)}...',
                          style: const TextStyle(
                              fontSize: 14, color: kTextLightColor),
                        ),
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundImage:
                                NetworkImage(instructorImage.toString()),
                            backgroundColor: kLightBlueColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: CustomText(
                              text: instructorName,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          StarDisplayWidget(
                            value: rating!,
                            filledStar: const Icon(
                              Icons.star,
                              color: kStarColor,
                              size: 18,
                            ),
                            unfilledStar: const Icon(
                              Icons.star_border,
                              color: kStarColor,
                              size: 18,
                            ),
                          ),
                          Text(
                            price!,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: kTextLightColor),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
