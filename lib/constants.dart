// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';

const BASE_URL =
    'https://e-limi.africa'; // Example: const BASE_URL = 'http://192.168.0.119/academy-demo';

// const BASE_URL = 'https://vipethi opia.com';

// list of colors that we use in our app
const kBackgroundColor = Color(0xFFF5F9FA);
const kDarkButtonBg = Color(0xFF273546);
const kSecondaryColor = Color(0xFF808080);
const kSelectItemColor = Color(0xFF000000);
const kRedColor = Color(0xFF8D161A);
const kBlueColor = Color(0xFF68B0FF);
const kGreenColor = Color(0xFF43CB65);
const kGreenPurchaseColor = Color(0xFF2BD0A8);
const kToastTextColor = Color(0xFFEEEEEE);
const kTextColor = Color(0xFF273242);
const kTextLightColor = Color(0xFF000000);
const kTextLowBlackColor = Colors.black38;
const kStarColor = Color(0xFFEFD358);
const kDeepBlueColor = Color(0xFF594CF5);
const kTabBarBg = Color(0xFFEEEEEE);
const kDarkGreyColor = Color(0xFF757575);
const kTextBlueColor = Color(0xFF5594bf);
const kTimeColor = Color(0xFF366cc6);
const kTimeBackColor = Color(0xFFe3ebf5);
const kLessonBackColor = Color(0xFFf8e5d2);
// const kLightBlueColor = Color(0xFFE7EEFE);
const kLightBlueColor = Color(0xFF4AA8D4);
const kFormInputColor = Color(0xFFc7c8ca);
const kNoteColor = Color(0xFFbfdde4);
const kLiveClassColor = Color(0xFFfff3cd);
const kSectionTileColor = Color(0xFFdddcdd);
// Color of Categories card, long arrow
const iCardColor = Color(0xFFF4F8F9);
const iLongArrowRightColor = Color(0xFF559595);

const kDefaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(12.0)),
  borderSide: BorderSide(color: Colors.white, width: 2),
);

const kDefaultFocusInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(12.0)),
  borderSide: BorderSide(color: kBlueColor, width: 2),
);
const kDefaultFocusErrorBorder = OutlineInputBorder(
  borderSide: BorderSide(color: kRedColor),
  borderRadius: BorderRadius.all(Radius.circular(12.0)),
);

// our default Shadow
const kDefaultShadow = BoxShadow(
  offset: Offset(20, 10),
  blurRadius: 20,
  color: Colors.black12, // Black color with 12% opacity
);

enum CoursesPageData {
  Category,
  Filter,
  Search,
  All,
}
