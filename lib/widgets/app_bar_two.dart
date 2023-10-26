import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:elimiafrica/models/app_logo.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class CustomAppBarTwo extends StatefulWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  CustomAppBarTwo({Key? key})
      : preferredSize = const Size.fromHeight(50.0),
        super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomAppBarTwoState createState() => _CustomAppBarTwoState();
}

class _CustomAppBarTwoState extends State<CustomAppBarTwo> {
  final _controller = StreamController<AppLogo>();

  fetchMyLogo() async {
    var url = '$BASE_URL/api/app_logo';
    try {
      final response = await http.get(Uri.parse(url));
      // print(response.body);
      if (response.statusCode == 200) {
        var logo = AppLogo.fromJson(jsonDecode(response.body));
        _controller.add(logo);
      }
      // print(extractedData);
    } catch (error) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMyLogo();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.3,
      iconTheme: const IconThemeData(
        color: kSecondaryColor, //change your color here
      ),
      title: StreamBuilder<AppLogo>(
        stream: _controller.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else {
            if (snapshot.error != null) {
              return const Text("Error Occured");
            } else {
              // saveImageUrlToSharedPref(snapshot.data.darkLogo);
              return CachedNetworkImage(
                imageUrl: snapshot.data!.darkLogo.toString(),
                fit: BoxFit.contain,
                height: 27,
              );
            }
          }
        },
      ),
      backgroundColor: Colors.white,
    );
  }
}
