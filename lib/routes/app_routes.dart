import 'package:flutter/material.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import '../features/main/presentation/pages/main_page.dart';
import '../features/auth/presentation/pages/login_screen.dart';
import '../features/auth/presentation/pages/register_screen.dart';
import '../features/auth/presentation/pages/non_logged_in_screen.dart';
import '../features/non_auth/presentation/pages/non_login_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String main = '/main';
  static const String login = '/login';
  static const String register = '/register';
  static const String nonLoggedIn = '/non-logged-in';
  static const String nonLogIn = '/non-log-in';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashPage(),
    main: (context) => const MainPage(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    nonLoggedIn: (context) => const NonLoggedInScreen(),
    nonLogIn: (context) => const NonLoginPage(),
  };
}
