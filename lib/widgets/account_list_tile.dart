import 'package:elimiafrica/providers/auth.dart';
import 'package:elimiafrica/screens/downloaded_course_list.dart';
import 'package:elimiafrica/screens/edit_password_screen.dart';
import 'package:elimiafrica/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import './custom_text.dart';

class AccountListTile extends StatelessWidget {
  final String? titleText;
  final IconData? icon;
  final String? actionType;
  final String? courseAccessibility;

  const AccountListTile({
    Key? key,
    @required this.titleText,
    @required this.icon,
    @required this.actionType,
    this.courseAccessibility,
  }) : super(key: key);

  void _actionHandler(BuildContext context) {
    if (actionType == 'logout') {
      if (courseAccessibility == 'publicly') {
        Provider.of<Auth>(context, listen: false).logout().then((_) =>
            Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false));
      } else {
        Provider.of<Auth>(context, listen: false).logout().then((_) =>
            Navigator.pushNamedAndRemoveUntil(
                context, '/auth-private', (r) => false));
      }
    } else if (actionType == 'edit') {
      Navigator.of(context).pushNamed(EditProfileScreen.routeName);
    } else if (actionType == 'change_password') {
      Navigator.of(context).pushNamed(EditPasswordScreen.routeName);
    } else {
      Navigator.of(context).pushNamed(DownloadedCourseList.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: kLightBlueColor,
        radius: 20,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: FittedBox(
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ),
      ),
      title: CustomText(
        text: titleText,
        colors: kTextColor,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: InkWell(
          onTap: () => _actionHandler(context),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: iCardColor,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
              child: ImageIcon(
                AssetImage("assets/images/long_arrow_right.png"),
                color: iLongArrowRightColor,
                size: 25,
              ),
            ),
          ),
        ),
      ),
      // trailing: IconButton(
      //   icon: const Icon(Icons.arrow_forward_ios),
      //   onPressed: () => _actionHandler(context),
      //   color: Colors.grey,
      // ),
    );
  }
}
