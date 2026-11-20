import 'package:flutter/material.dart';

import '../pages/splash_screen.dart';
import '../pages/home_page.dart';
import '../pages/detail_page.dart';
import '../pages/about_page.dart';
import '../pages/wishlist_page.dart';

class AppRouting {
  static const splash = '/';
  static const home = '/home';
  static const detail = '/detail';
  static const about = '/about';
  static const search = '/search';
  static const wishlist = '/wishlist';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    home: (context) => const HomePage(),
    search: (context) => const HomePage(currentIndex: 1, focusSearch: true),
    wishlist: (context) => const WishlistPage(),
    detail: (context) => const DetailPage(),
    about: (context) => const AboutPage(),
  };
}
