import 'dart:async';
import 'dart:convert';
import 'package:elimiafrica/screens/courses_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:elimiafrica/models/app_logo.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'search_widget.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  CustomAppBar({Key? key})
      : preferredSize = const Size.fromHeight(50.0),
        super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final bool _isSearching = false;
  final _controller = StreamController<AppLogo>();
  final searchController = TextEditingController();

  fetchMyLogo() async {
    var url = '$BASE_URL/api/app_logo';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var logo = AppLogo.fromJson(jsonDecode(response.body));
        _controller.add(logo);
      }
      // print(extractedData);
    } catch (error) {
      rethrow;
    }
  }

  void _handleSubmitted(String value) {
    final searchText = searchController.text;
    if (searchText.isEmpty) {
      return;
    }

    searchController.clear();
    Navigator.of(context).pushNamed(
      CoursesScreen.routeName,
      arguments: {
        'category_id': null,
        'seacrh_query': searchText,
        'type': CoursesPageData.Search,
      },
    );
    // print(searchText);
  }

  void _showSearchModal(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return const SearchWidget();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchMyLogo();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      iconTheme: const IconThemeData(
        color: kSecondaryColor, //change your color here
      ),
      leading: StreamBuilder<AppLogo>(
        stream: _controller.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else {
            if (snapshot.error != null) {
              return const Text("Error Occured");
            } else {
              return Transform.scale(
                scale: 3.5,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: CachedNetworkImage(
                    alignment: Alignment.center,
                    imageUrl: snapshot.data!.darkLogo.toString(),
                    fit: BoxFit.contain,
                  ),
                ),
              );
            }
          }
        },
      ),
      title: !_isSearching
          ? Container()
          : Card(
              color: Colors.white,
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Search Here',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
                controller: searchController,
                onFieldSubmitted: _handleSubmitted,
              ),
            ),
      backgroundColor: Colors.white,
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.search,
            color: kSecondaryColor,
          ),
          onPressed: () => _showSearchModal(context),
        ),
      ],
    );
  }
}
