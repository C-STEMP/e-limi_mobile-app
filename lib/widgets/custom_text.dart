import 'package:flutter/material.dart';
import '../constants.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final Color? colors;
  final FontWeight? fontWeight;
  const CustomText(
      {Key? key, this.text, this.fontSize, this.colors, this.fontWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text.toString(),
        style: TextStyle(
            fontSize: fontSize ?? 16,
            color: colors ?? kSecondaryColor,
            fontWeight: fontWeight ?? FontWeight.normal));
  }
}
