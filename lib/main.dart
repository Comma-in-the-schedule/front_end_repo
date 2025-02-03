import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'non_logged_in_screen.dart';
import 'register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Pretendard"),
      initialRoute: '/non-logged-in',
      routes: {
        '/': (context) => NonLoggedInScreen(),
        '/non-logged-in': (context) => NonLoggedInScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        // '/home': (context) => HomeScreen(),
        // '/survey': (context) => SurveyScreen(),
      },
    );
  }
}
