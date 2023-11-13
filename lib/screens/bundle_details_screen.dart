// ignore_for_file: deprecated_member_use

import 'package:elimiafrica/models/bundle_details_model.dart';
import 'package:elimiafrica/models/common_functions.dart';
import 'package:elimiafrica/providers/bundles.dart';
import 'package:elimiafrica/providers/shared_pref_helper.dart';
import 'package:elimiafrica/widgets/app_bar_two.dart';
import 'package:elimiafrica/widgets/course_grid.dart';
import 'package:elimiafrica/widgets/custom_text.dart';
import 'package:elimiafrica/widgets/star_display_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:universal_html/html.dart' as html;
import '../constants.dart';

class BundleDetailsScreen extends StatefulWidget {
  static const routeName = '/bundle';
  const BundleDetailsScreen({Key? key}) : super(key: key);

  @override
  State<BundleDetailsScreen> createState() => _BundleDetailsScreenState();
}

class _BundleDetailsScreenState extends State<BundleDetailsScreen> {
  var _isInit = true;
  var _isLoading = false;
  List<BundleDetails> bundles = [];
  var bundleCourses = [];
  dynamic bundleId;
  dynamic title;
  dynamic loadedBundle;
  dynamic description;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final routeArgs =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      bundleId = routeArgs['id'] as int;
      title = routeArgs['title'];
      Provider.of<Bundles>(context).fetchBundleDetailById(bundleId).then((_) {
        setState(() {
          _isLoading = false;
          bundles =
              Provider.of<Bundles>(context, listen: false).getBundleDetail;
          var text = html.Element.span()
            ..appendHtml(bundles.first.bundleDetails.toString());
          description = text.innerText;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  void _launchURL(String url) async => await canLaunch(url)
      ? await launch(url, forceSafariVC: false)
      : throw 'Could not launch $url';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarTwo(),
      backgroundColor: kBackgroundColor,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: kPrimaryColor.withOpacity(0.7)),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 3.3,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.6),
                                BlendMode.dstATop),
                            image: NetworkImage(
                              '$BASE_URL/uploads/course_bundle/banner/${bundles[0].banner}',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              text: title,
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black),
                            ),
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: Text(''),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 10,
                          ),
                          child: StarDisplayWidget(
                            value: bundles[0].averageRating!,
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
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            '( ${bundles[0].averageRating}.0 )',
                            style: const TextStyle(
                              fontSize: 11,
                              color: kTextColor,
                            ),
                          ),
                        ),
                        CustomText(
                          text: '${bundles[0].numberOfRatings}+ Rating',
                          fontSize: 11,
                          colors: kTextColor,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                        right: 15, left: 15, top: 0, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: CustomText(
                            text: bundles[0].price,
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            colors: kTextColor,
                          ),
                        ),
                        MaterialButton(
                          onPressed: () async {
                            var authToken =
                                await SharedPreferenceHelper().getAuthToken();

                            if (authToken != null) {
                              if (bundles[0].subscriptionStatus == 'invalid' ||
                                  bundles[0].subscriptionStatus == 'expired') {
                                final url =
                                    '$BASE_URL/api/web_redirect_to_buy_bundle/$authToken/$bundleId/academybycreativeitem';
                                _launchURL(url);
                              } else {
                                CommonFunctions.showSuccessToast(
                                    'Already purchased. Check My Course.');
                              }
                            } else {
                              CommonFunctions.showSuccessToast(
                                  'Please login first');
                            }
                          },
                          color: bundles[0].subscriptionStatus == 'valid' ||
                                  bundles[0].subscriptionStatus == 'expired'
                              ? kGreenPurchaseColor
                              : kPrimaryColor,
                          textColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          splashColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                            // side: BorderSide(color: kBlueColor),
                          ),
                          child: Text(
                            bundles[0].subscriptionStatus == 'valid'
                                ? 'Purchased'
                                : bundles[0].subscriptionStatus == 'expired'
                                    ? 'Renew'
                                    : 'Buy Now',
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: const Text(
                      'Included Courses',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 0.0),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 258.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, index) {
                        return CourseGrid(
                          id: int.parse(bundles[0].bundleCourses![index].id!),
                          title: bundles[0].bundleCourses![index].title,
                          thumbnail: bundles[0].bundleCourses![index].thumbnail,
                          instructorName:
                              bundles[0].bundleCourses![index].instructorName,
                          instructorImage:
                              bundles[0].bundleCourses![index].instructorImage,
                          price: bundles[0].bundleCourses![index].price,
                          rating: bundles[0].bundleCourses![index].rating,
                        );
                      },
                      itemCount: bundles[0].bundleCourses!.length,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: const Text(
                      'Description',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      description,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        wordSpacing: 2,
                      ),
                      maxLines: 4,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
    );
  }
}
