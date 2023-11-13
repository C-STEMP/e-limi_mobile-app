import 'dart:async';
import 'package:elimiafrica/providers/courses.dart';
import 'package:elimiafrica/widgets/wishlist_grid.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class MyWishlistScreen extends StatefulWidget {
  const MyWishlistScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyWishlistScreenState createState() => _MyWishlistScreenState();
}

class _MyWishlistScreenState extends State<MyWishlistScreen> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'My Wishlist',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                ),
              ],
            ),
          ),
          FutureBuilder(
            future:
                Provider.of<Courses>(context, listen: false).fetchMyWishlist(),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: kPrimaryColor.withOpacity(0.7)),
                );
              } else {
                if (dataSnapshot.error != null) {
                  return _connectionStatus == ConnectivityResult.none
                      ? Center(
                          child: Column(
                            children: [
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .15),
                              Image.asset(
                                "assets/images/no_connection.png",
                                height:
                                    MediaQuery.of(context).size.height * .35,
                              ),
                              const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text('There is no Internet connection'),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(
                                    'Please check your Internet connection'),
                              ),
                            ],
                          ),
                        )
                      : const Center(
                          child: Text('Error Occurred'),
                        );
                } else {
                  return Consumer<Courses>(
                    builder: (context, courseData, child) =>
                        AlignedGridView.count(
                      padding: const EdgeInsets.all(10.0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 1,
                      itemCount: courseData.items.length,
                      itemBuilder: (ctx, index) {
                        return WishlistGrid(
                          course: courseData.items[index],
                        );
                        // return Text(myCourseData.items[index].title);
                      },
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
