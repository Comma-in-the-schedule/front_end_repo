import 'package:flutter/material.dart';
import 'non_logged_in_screen.dart';
import 'login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Pretendard",
      ),
      initialRoute: '/non-logged-in',
      routes: {
        '/': (context) => NonLoggedInScreen(), // 로딩 화면
        '/non-logged-in': (context) => NonLoggedInScreen(), // 비로그인 화면
        '/login': (context) => LoginScreen(), // 로그인 화면
        // '/register': (context) => RegisterScreen(), // 회원가입 화면
        // '/home': (context) => HomeScreen(), // 홈 화면
        // '/survey': (context) => SurveyScreen(), // 설문 조사 화면
      },
    );
  }
}
