import 'package:flutter/material.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import '../features/main/presentation/pages/main_page.dart';
import '../features/auth/presentation/pages/login_screen.dart';
import '../features/auth/presentation/pages/register_screen.dart'; // 🔹 회원가입 페이지 추가
import '../features/auth/presentation/pages/non_logged_in_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String main = '/main';
  static const String login = '/login';
  static const String register = '/register'; // 🔹 회원가입 라우트 추가
  static const String nonLoggedIn = '/non-logged-in';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashPage(),
    main: (context) => const MainPage(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(), // 🔹 회원가입 페이지 추가
    nonLoggedIn: (context) => const NonLoggedInScreen(),
  };
}
