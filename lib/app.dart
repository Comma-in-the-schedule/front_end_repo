import 'package:flutter/material.dart';
import 'package:comma_in_the_schedule/routes/app_routes.dart'; // 네비게이션 설정
import 'package:comma_in_the_schedule/core/themes/app_theme.dart'; // 테마 설정

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // 앱의 기본 테마 적용
      initialRoute: AppRoutes.main, // 기본 시작 페이지
      routes: AppRoutes.routes, // 라우팅 설정
    );
  }
}
