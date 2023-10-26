// To parse this JSON data, do
//
//     final appLogo = appLogoFromJson(jsonString);

import 'dart:convert';

AppLogo appLogoFromJson(String str) => AppLogo.fromJson(json.decode(str));

String appLogoToJson(AppLogo data) => json.encode(data.toJson());

class AppLogo {
  AppLogo({
    this.bannerImage,
    this.lightLogo,
    this.darkLogo,
    this.smallLogo,
    this.favicon,
  });

  String? bannerImage;
  String? lightLogo;
  String? darkLogo;
  String? smallLogo;
  String? favicon;

  factory AppLogo.fromJson(Map<String, dynamic> json) => AppLogo(
        bannerImage: json["banner_image"],
        lightLogo: json["light_logo"],
        darkLogo: json["dark_logo"],
        smallLogo: json["small_logo"],
        favicon: json["favicon"],
      );

  Map<String, dynamic> toJson() => {
        "banner_image": bannerImage,
        "light_logo": lightLogo,
        "dark_logo": darkLogo,
        "small_logo": smallLogo,
        "favicon": favicon,
      };
}
