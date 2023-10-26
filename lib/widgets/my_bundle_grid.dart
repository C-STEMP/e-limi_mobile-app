import 'package:elimiafrica/models/bundle.dart';
import 'package:elimiafrica/screens/bundle_details_screen.dart';
import 'package:elimiafrica/screens/my_bundle_courses_list_screen.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/star_display_widget.dart';
import '../widgets/custom_text.dart';

class MyBundleGrid extends StatelessWidget {
  final Bundle? myBundle;

  const MyBundleGrid({
    Key? key,
    @required this.myBundle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          MyBundleCoursesListScreen.routeName,
          arguments: {
            'id': myBundle!.id,
            'title': myBundle!.title,
            'subscription_status': myBundle!.subscriptionStatus,
          },
        );
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
                      image:
                          '$BASE_URL/uploads/course_bundle/banner/${myBundle!.banner}',
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
                        text: myBundle!.title!.length < 38
                            ? myBundle!.title
                            : myBundle!.title!.substring(0, 37),
                        fontSize: 14,
                        colors: kTextLightColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 11,
                          backgroundImage:
                              NetworkImage(myBundle!.userImage.toString()),
                          backgroundColor: kLightBlueColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: CustomText(
                            text: myBundle!.userName,
                            fontSize: 13,
                          ),
                        ),
                      ],
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
                              value: myBundle!.averageRating!.toInt(),
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
                              '( ${myBundle!.averageRating}.0 )',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const CustomText(
                          text: 'Status:',
                          fontSize: 15,
                        ),
                        myBundle!.subscriptionStatus == 'valid'
                            ? const Expanded(
                                flex: 1,
                                child: Card(
                                  elevation: 0,
                                  color: kGreenColor,
                                  child: Padding(
                                    padding: EdgeInsets.all(3.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: CustomText(
                                        text: 'Active',
                                        colors: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const Expanded(
                                flex: 1,
                                child: Card(
                                  elevation: 0,
                                  color: kRedColor,
                                  child: Padding(
                                    padding: EdgeInsets.all(3.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: CustomText(
                                        text: 'Expired',
                                        colors: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(
                          width: 30,
                          child: PopupMenuButton(
                            onSelected: (value) {
                              if (value == 'bundle-details') {
                                Navigator.of(context).pushNamed(
                                  BundleDetailsScreen.routeName,
                                  arguments: {
                                    'id': myBundle!.id,
                                    'title': myBundle!.title,
                                  },
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.more_vert,
                            ),
                            itemBuilder: (_) => [
                              const PopupMenuItem(
                                value: 'bundle-details',
                                child: Text('Bundle Details'),
                              ),
                            ],
                          ),
                        ),
                      ],
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
