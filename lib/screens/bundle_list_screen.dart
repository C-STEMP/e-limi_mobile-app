import 'package:elimiafrica/constants.dart';
import 'package:elimiafrica/providers/bundles.dart';
import 'package:elimiafrica/widgets/app_bar_two.dart';
import 'package:elimiafrica/widgets/bundle_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BundleListScreen extends StatefulWidget {
  static const routeName = '/bundle-list';
  const BundleListScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BundleListScreenState createState() => _BundleListScreenState();
}

class _BundleListScreenState extends State<BundleListScreen> {
  var _isInit = true;
  var _isLoading = false;
  var bundles = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Bundles>(context).fetchBundle(false).then((_) {
        setState(() {
          _isLoading = false;
          bundles = Provider.of<Bundles>(context, listen: false).bundleItems;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Showing ${bundles.length} Bundles',
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        return Center(
                          child: BundleListItem(
                            id: bundles[index].id,
                            title: bundles[index].title,
                            // ignore: prefer_interpolation_to_compose_strings
                            banner: '$BASE_URL/uploads/course_bundle/banner/' +
                                bundles[index].banner,
                            averageRating: bundles[index].averageRating,
                            numberOfRatings: bundles[index].numberOfRatings,
                            price: bundles[index].price,
                          ),
                        );
                      },
                      itemCount: bundles.length,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
