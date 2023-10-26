import 'package:elimiafrica/screens/sub_category_screen.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class CategoryListItem extends StatelessWidget {
  final int? id;
  final String? title;
  final String? thumbnail;
  final int? numberOfSubCategories;

  const CategoryListItem(
      {Key? key,
      @required this.id,
      @required this.title,
      @required this.thumbnail,
      @required this.numberOfSubCategories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          SubCategoryScreen.routeName,
          arguments: {
            'category_id': id,
            'title': title,
          },
        );
      },
      child: Card(
        // color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/loading_animated.gif',
                    image: thumbnail.toString(),
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                width: double.infinity,
                // height: 80,
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          title!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '$numberOfSubCategories Sub-Categories',
                        style: const TextStyle(color: Colors.black54),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: iCardColor,
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
                    child: ImageIcon(
                      AssetImage("assets/images/long_arrow_right.png"),
                      color: iLongArrowRightColor,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
