// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:elimiafrica/models/all_category.dart';
import 'package:elimiafrica/models/category.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/misc_provider.dart';
import '../providers/courses.dart';
import '../providers/categories.dart';
import './custom_text.dart';
import './star_display_widget.dart';
import '../screens/courses_screen.dart';
import '../models/common_functions.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  var _isInit = true;
  var _isLoading = false;
  var subIndex = 0;
  var data = <AllSubCategory>[];
  String _selectedCategory = 'all';
  dynamic _selectedSubCat;
  String _selectedPrice = 'all';
  String _selectedLevel = 'all';
  String _selectedLanguage = 'all';
  String _selectedRating = 'all';

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
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Categories>(context, listen: false)
          .fetchAllCategory()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });

      Provider.of<Languages>(context).fetchLanguages().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _resetForm() {
    setState(() {
      _selectedCategory = 'all';
      _selectedSubCat = null;
      _selectedPrice = 'all';
      _selectedLevel = 'all';
      _selectedLanguage = 'all';
      _selectedRating = 'all';
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      if (_selectedSubCat != null) {
        await Provider.of<Courses>(context, listen: false).filterCourses(
            _selectedSubCat,
            _selectedPrice,
            _selectedLevel,
            _selectedLanguage,
            _selectedRating);
      } else {
        await Provider.of<Courses>(context, listen: false).filterCourses(
            _selectedCategory,
            _selectedPrice,
            _selectedLevel,
            _selectedLanguage,
            _selectedRating);
      }
      Navigator.of(context).pushNamed(
        CoursesScreen.routeName,
        arguments: {
          'category_id': null,
          'search_query': null,
          'type': CoursesPageData.Filter,
        },
      );
    } catch (error) {
      const errorMsg = 'Could not process request!';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final catData = Provider.of<Categories>(context, listen: false).items;
    catData.insert(
        0,
        Category(
            id: 0,
            title: 'All Category',
            thumbnail: null,
            numberOfCourses: null,
            numberOfSubCategories: null));
    //print(catData);
    final langData = Provider.of<Languages>(context, listen: false).items;
    langData.insert(
        0, Language(id: 0, value: 'all', displayedValue: 'All Language'));
    final allCategory =
        Provider.of<Categories>(context, listen: false).allItems;
    allCategory.insert(
        0, AllCategory(id: 0, title: 'All Category', subCategory: data));
    return _isLoading
        ? _connectionStatus == ConnectivityResult.none
            ? Center(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * .15),
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
                      child: Text('Please check your Internet connection'),
                    ),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              )
        : Scaffold(
            backgroundColor: kBackgroundColor,
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 25,
                  ),
                  AppBar(
                    automaticallyImplyLeading: false,
                    elevation: 0.5,
                    title: const Text(
                      'Filter Courses',
                      style: TextStyle(
                        fontSize: 18,
                        color: kTextColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    iconTheme: const IconThemeData(
                      color: kSecondaryColor, //change your color here
                    ),
                    backgroundColor: kBackgroundColor,
                    actions: <Widget>[
                      IconButton(
                          icon: const Icon(
                            Icons.cancel_outlined,
                            color: Colors.black38,
                            size: 20,
                          ),
                          onPressed: () => Navigator.of(context).pop()),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: double.infinity,
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: CustomText(
                                text: 'Category',
                                fontSize: 17,
                                colors: kTextColor,
                              ),
                            ),
                            Card(
                              elevation: 0.1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: DropdownButton(
                                  value: _selectedCategory,
                                  icon: const Card(
                                    elevation: 0.1,
                                    color: kBackgroundColor,
                                    child: Icon(
                                        Icons.keyboard_arrow_down_outlined),
                                  ),
                                  underline: const SizedBox(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedSubCat = null;
                                      _selectedCategory = value.toString();
                                      // print(allCategory.indexOf(value));
                                    });
                                  },
                                  isExpanded: true,
                                  items: allCategory.map((cd) {
                                    return DropdownMenuItem(
                                      value:
                                          cd.id == 0 ? 'all' : cd.id.toString(),
                                      onTap: () {
                                        setState(() {
                                          subIndex = allCategory.indexOf(cd);
                                        });
                                      },
                                      child: Text(
                                        cd.title.toString(),
                                        style: const TextStyle(
                                          color: kSecondaryColor,
                                          fontSize: 15,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: CustomText(
                                text: 'Sub Category',
                                fontSize: 17,
                                colors: kTextColor,
                              ),
                            ),
                            Card(
                              elevation: 0.1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: DropdownButton(
                                  value: _selectedSubCat,
                                  icon: const Card(
                                    elevation: 0.1,
                                    color: kBackgroundColor,
                                    child: Icon(
                                        Icons.keyboard_arrow_down_outlined),
                                  ),
                                  underline: const SizedBox(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedSubCat = value.toString();
                                    });
                                  },
                                  isExpanded: true,
                                  hint: const Text('All Sub-Category',
                                      style: TextStyle(
                                        color: kSecondaryColor,
                                        fontSize: 15,
                                      )),
                                  items: allCategory[subIndex]
                                      .subCategory
                                      .map((cd) {
                                    return DropdownMenuItem(
                                      value:
                                          cd.id == 0 ? 'all' : cd.id.toString(),
                                      child: Text(
                                        cd.title.toString(),
                                        style: const TextStyle(
                                          color: kSecondaryColor,
                                          fontSize: 15,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: CustomText(
                                text: 'Pricing',
                                fontSize: 17,
                                colors: kTextColor,
                              ),
                            ),
                            Card(
                              elevation: 0.1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: DropdownButton(
                                  underline: const SizedBox(),
                                  icon: const Card(
                                    elevation: 0.1,
                                    color: kBackgroundColor,
                                    child: Icon(
                                        Icons.keyboard_arrow_down_outlined),
                                  ),
                                  value: _selectedPrice,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedPrice = value.toString();
                                    });
                                  },
                                  isExpanded: true,
                                  items: PriceFilter.getPriceFilter().map((pf) {
                                    return DropdownMenuItem(
                                      value: pf.id,
                                      child: Text(
                                        pf.name,
                                        style: const TextStyle(
                                          color: kSecondaryColor,
                                          fontSize: 15,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: CustomText(
                                text: 'Level',
                                fontSize: 17,
                                colors: kTextColor,
                              ),
                            ),
                            Card(
                              elevation: 0.1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: DropdownButton(
                                  underline: const SizedBox(),
                                  icon: const Card(
                                    elevation: 0.1,
                                    color: kBackgroundColor,
                                    child: Icon(
                                        Icons.keyboard_arrow_down_outlined),
                                  ),
                                  value: _selectedLevel,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedLevel = value.toString();
                                    });
                                  },
                                  isExpanded: true,
                                  items: DifficultyLevel.getDifficultyLevel()
                                      .map((dl) {
                                    return DropdownMenuItem(
                                      value: dl.id,
                                      child: Text(
                                        dl.name,
                                        style: const TextStyle(
                                          color: kSecondaryColor,
                                          fontSize: 15,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: CustomText(
                                text: 'Language',
                                fontSize: 17,
                                colors: kTextColor,
                              ),
                            ),
                            Card(
                              elevation: 0.1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: DropdownButton(
                                  underline: const SizedBox(),
                                  icon: const Card(
                                    elevation: 0.1,
                                    color: kBackgroundColor,
                                    child: Icon(
                                        Icons.keyboard_arrow_down_outlined),
                                  ),
                                  value: _selectedLanguage,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedLanguage = value.toString();
                                    });
                                  },
                                  isExpanded: true,
                                  items: langData.map((ld) {
                                    return DropdownMenuItem(
                                      value: ld.value,
                                      child: Text(
                                        ld.displayedValue.toString(),
                                        style: const TextStyle(
                                          color: kSecondaryColor,
                                          fontSize: 15,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: CustomText(
                                text: 'Rating',
                                fontSize: 17,
                                colors: kTextColor,
                              ),
                            ),
                            Card(
                              elevation: 0.1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: DropdownButton(
                                  underline: const SizedBox(),
                                  icon: const Card(
                                    elevation: 0.1,
                                    color: kBackgroundColor,
                                    child: Icon(
                                        Icons.keyboard_arrow_down_outlined),
                                  ),
                                  value: _selectedRating,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedRating = value.toString();
                                    });
                                  },
                                  isExpanded: true,
                                  items: [0, 1, 2, 3, 4, 5].map((item) {
                                    return DropdownMenuItem(
                                      value:
                                          item == 0 ? 'all' : item.toString(),
                                      child: item == 0
                                          ? const Text(
                                              'All Rating',
                                              style: TextStyle(
                                                color: kSecondaryColor,
                                                fontSize: 15,
                                              ),
                                            )
                                          : StarDisplayWidget(
                                              value: item,
                                              filledStar: const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 15,
                                              ),
                                              unfilledStar: const Icon(
                                                Icons.star,
                                                color: Colors.grey,
                                                size: 15,
                                              ),
                                            ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: MaterialButton(
                                    elevation: 0.5,
                                    onPressed: _resetForm,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    color: Colors.white,
                                    textColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      side:
                                          const BorderSide(color: Colors.white),
                                    ),
                                    child: const Text(
                                      'Reset',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                Expanded(flex: 2, child: Container()),
                                Expanded(
                                  flex: 5,
                                  child: MaterialButton(
                                    elevation: 0.5,
                                    onPressed: _submitForm,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    color: kRedColor,
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      side: const BorderSide(color: kRedColor),
                                    ),
                                    child: const Text(
                                      'Filter',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}
