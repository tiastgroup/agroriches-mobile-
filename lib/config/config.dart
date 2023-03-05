import 'package:flutter/material.dart';

class Config {
  final String appName = 'Agroriches';
  final String splashIcon = 'assets/images/splash.gif';
  final String supportEmail = 'support@agroriches.com';
  final String privacyPolicyUrl = 'https://agroriches.com';
  final String ourWebsiteUrl = 'https://agroriches.com';
  final String iOSAppId = '000000';

  //social links
  static const String facebookPageUrl = 'https://www.facebook.com/agroriches/';
  static const String youtubeChannelUrl =
      'https://www.youtube.com/@agrorichestv6163';
  static const String twitterUrl =
      'https://twitter.com/agroriches?ref_src=twsrc%5Egoogle%7Ctwcamp%5Eserp%7Ctwgr%5Eauthor';

  //app theme color
  final Color appColor = Color.fromARGB(255, 6, 107, 58);

  //Intro images
  final String introImage1 = 'assets/images/news1.png';
  final String introImage2 = 'assets/images/news6.png';
  final String introImage3 = 'assets/images/news7.png';

  //animation files
  final String doneAsset = 'assets/animation_files/done.json';

  //Language Setup
  final List<String> languages = ['English', 'Chinese', 'French'];

  //initial categories - 4 only (Hard Coded : which are added already on your admin panel)
  final List initialCategories = [
    'News',
    'Articles',
    'Trends',
    'Art and Nutrition'
  ];
}
