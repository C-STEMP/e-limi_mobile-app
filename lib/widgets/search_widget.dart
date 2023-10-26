import 'package:elimiafrica/constants.dart';
import 'package:elimiafrica/screens/courses_screen.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  static const routeName = '/search-item';

  const SearchWidget({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final bool _isLoading = false;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: Column(
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                AppBar(
                  automaticallyImplyLeading: false,
                  title: TextFormField(
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
                  iconTheme: const IconThemeData(
                    color: kSecondaryColor, //change your color here
                  ),
                  backgroundColor: kBackgroundColor,
                  actions: <Widget>[
                    IconButton(
                        icon: const Icon(
                          Icons.cancel_outlined,
                          color: kSecondaryColor,
                          size: 20,
                        ),
                        onPressed: () => Navigator.of(context).pop()),
                  ],
                ),
                const SizedBox(height: 150),
                const Text(
                  "Type In Search Bar...",
                  style: TextStyle(color: kSecondaryColor),
                ),
              ],
            ),
          );
  }
}
