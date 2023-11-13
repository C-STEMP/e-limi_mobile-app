// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:elimiafrica/providers/bundles.dart';
import 'package:elimiafrica/widgets/bundle_grid.dart';
import '../providers/categories.dart';
import '../widgets/category_list_item.dart';
import '../widgets/course_grid.dart';
import '../providers/courses.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import 'bundle_list_screen.dart';
import 'courses_screen.dart';
import '../models/common_functions.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isInit = true;
  var _isLoading = false;
  var topCourses = [];
  var bundles = [];
  dynamic bundleStatus;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    addonStatus();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  Future<void> addonStatus() async {
    var url = '$BASE_URL/api/addon_status?unique_identifier=course_bundle';
    final response = await http.get(Uri.parse(url));
    bundleStatus = json.decode(response.body)['status'];
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Courses>(context).fetchTopCourses().then((_) {
        setState(() {
          _isLoading = false;
          topCourses = Provider.of<Courses>(context, listen: false).topItems;
        });
      });
      Provider.of<Courses>(context).filterCourses('all', 'all', 'all', 'all', 'all');
      Provider.of<Bundles>(context).fetchBundle(true).then((_) {
        setState(() {
          bundles = Provider.of<Bundles>(context, listen: false).bundleItems;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> refreshList() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Courses>(context, listen: false).fetchTopCourses();

      setState(() {
        _isLoading = false;
        topCourses = Provider.of<Courses>(context, listen: false).topItems;
      });
    } catch (error) {
      const errorMsg = 'Could not refresh!';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }

    return;
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshList,
      child: SingleChildScrollView(
        child: FutureBuilder(
          future:
              Provider.of<Categories>(context, listen: false).fetchCategories(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * .5,
                child: Center(
                  child: CircularProgressIndicator(color: kPrimaryColor.withOpacity(0.7)),
                ),
              );
            } else {
              if (dataSnapshot.error != null) {
                //error
                return _connectionStatus == ConnectivityResult.none
                    ? Center(
                        child: Column(
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .15),
                            Image.asset(
                              "assets/images/no_connection.png",
                              height: MediaQuery.of(context).size.height * .35,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text('There is no Internet connection'),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(4.0),
                              child:
                                  Text('Please check your Internet connection'),
                            ),
                          ],
                        ),
                      )
                    : const Center(
                        child: Text('Error Occured'),
                        // child: Text(dataSnapshot.error.toString()),
                      );
              } else {
                return Column(
                  children: [
                    if(topCourses.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            'Top Course',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          MaterialButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                CoursesScreen.routeName,
                                arguments: {
                                  'category_id': null,
                                  'seacrh_query': null,
                                  'type': CoursesPageData.All,
                                },
                              );
                            },
                            padding: const EdgeInsets.all(0),
                            child: Row(
                              children: [
                                const Text('All courses'),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: kPrimaryColor.withOpacity(0.7),
                                  size: 18,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    _isLoading
                        ? Center(
                            child: CircularProgressIndicator(color: kPrimaryColor.withOpacity(0.7)),
                          )
                        : topCourses.isNotEmpty 
                          ? Container(
                              margin: const EdgeInsets.symmetric(vertical: 0.0),
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              height: 258.0,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (ctx, index) {
                                  return CourseGrid(
                                    id: topCourses[index].id,
                                    title: topCourses[index].title,
                                    thumbnail: topCourses[index].thumbnail,
                                    instructorName: topCourses[index].instructor,
                                    instructorImage:
                                        topCourses[index].instructorImage,
                                    rating: topCourses[index].rating,
                                    price: topCourses[index].price,
                                  );
                                },
                                itemCount: topCourses.length,
                              ),
                            ) 
                          : const SizedBox(height: 0),
                    if (bundleStatus == true)
                      Column(
                        children: [
                          if(bundles.isNotEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text(
                                  'Bundles',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                      BundleListScreen.routeName,
                                    );
                                  },
                                  padding: const EdgeInsets.all(0),
                                  child: Row(
                                    children: [
                                      const Text('All bundles'),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: kPrimaryColor.withOpacity(0.7),
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          bundles.isNotEmpty 
                            ? Container(
                                margin: const EdgeInsets.symmetric(vertical: 0.0),
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                height: 240.0,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (ctx, index) {
                                    return BundleGrid(
                                      id: bundles[index].id,
                                      title: bundles[index].title,
                                      banner:
                                          // ignore: prefer_interpolation_to_compose_strings
                                          '$BASE_URL/uploads/course_bundle/banner/' +
                                              bundles[index].banner,
                                      averageRating: bundles[index].averageRating,
                                      numberOfRatings:
                                          bundles[index].numberOfRatings,
                                      price: bundles[index].price,
                                    );
                                  },
                                  itemCount: bundles.length,
                                ),
                              ) 
                            : const SizedBox(height: 0),
                        ],
                      ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            'Course Categories',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          MaterialButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                CoursesScreen.routeName,
                                arguments: {
                                  'category_id': null,
                                  'seacrh_query': null,
                                  'type': CoursesPageData.All,
                                },
                              );
                            },
                            padding: const EdgeInsets.all(0),
                            child: Row(
                              children: [
                                const Text('All courses'),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: kPrimaryColor.withOpacity(0.7),
                                  size: 18,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Consumer<Categories>(
                      builder: (context, myCourseData, child) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            return CategoryListItem(
                              id: myCourseData.items[index].id,
                              title: myCourseData.items[index].title,
                              thumbnail: myCourseData.items[index].thumbnail,
                              numberOfSubCategories: myCourseData
                                  .items[index].numberOfSubCategories,
                            );
                          },
                          itemCount: myCourseData.items.length,
                        ),
                      ),
                    ),
                  ],
                );
              }
            }
          },
        ),
      ),
    );
  }
}
