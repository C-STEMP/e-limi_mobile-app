import 'package:elimiafrica/screens/bundle_details_screen.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/star_display_widget.dart';

class BundleGrid extends StatelessWidget {
  final int? id;
  final String? title;
  final String? banner;
  final String? price;
  final int? averageRating;
  final int? numberOfRatings;

  const BundleGrid({
    Key? key,
    @required this.id,
    @required this.title,
    @required this.banner,
    @required this.price,
    @required this.averageRating,
    @required this.numberOfRatings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          BundleDetailsScreen.routeName,
          arguments: {
            'id': id,
            'title': title,
          },
        );
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
                          image: banner.toString(),
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
                        height: 40,
                        child: Text(
                          title.toString().length < 41
                              ? title.toString()
                              : title.toString().substring(0, 40),
                          style: const TextStyle(
                              fontSize: 14, color: kTextLightColor),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          StarDisplayWidget(
                            value: averageRating!,
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
