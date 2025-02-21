// lib/features/splash/presentation/pages/splash_page.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../non_auth/presentation/pages/non_login_page.dart'; // 로그인 페이지
import '../../../survey/presentation/pages/survey_page.dart'; // 설문조사 페이지
import '../../../main/presentation/pages/main_page.dart'; // 메인 페이지
import '../../../auth/data/auth_api.dart'; // AuthApi 클래스

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 설정 (2초 동안 실행)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward(); // 애니메이션 시작

    // 0에서 1로 점점 나타나는 애니메이션 설정
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // 3초 후 다음 페이지로 이동
    Timer(const Duration(seconds: 3), _navigateNext);
  }

  Future<void> _navigateNext() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    // 토큰이 없는 경우 로그인 페이지로 이동
    if (token == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const NonLoginPage()),
      );
      return;
    }

    // 토큰이 있을 경우, 로컬에 저장된 이메일도 조회 (없으면 빈 문자열)
    // 여기서는 "userEmail" 키를 사용
    final email = prefs.getString("userEmail") ?? "";
    if (email.isEmpty) {
      // 이메일이 없으면 예외처리 후 로그인 페이지로 이동
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const NonLoginPage()),
      );
      return;
    }

    // 설문조사 API 호출: 설문조사 결과가 있는지 확인
    final authApi = AuthApi();
    final surveyResponse =
        await authApi.checkSurvey(token: token, email: email);

    // 설문조사가 진행되지 않은 경우
    if (surveyResponse['isSuccess'] == false &&
        surveyResponse['result'] == '_SURVEY_NOT_EXISTS') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SurveyPage()),
      );
    } else {
      // 그 외의 경우 (설문조사 결과가 존재하거나, 성공 응답일 경우) 메인 페이지로 이동
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // 애니메이션 컨트롤러 정리
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF262627), // 배경색 지정
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // 왼쪽 텍스트: "바쁜 일상에"
            const Text(
              "바쁜 일상에",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Pretendard',
                  color: Colors.white),
            ),
            const SizedBox(width: 0), // 간격 추가

            // 로고 이미지 (애니메이션 적용, 위치 살짝 올리기)
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: FadeTransition(
                opacity: _animation,
                child: Image.asset(
                  'assets/icons/logo_w.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 0), // 간격 추가

            // 오른쪽 텍스트: "쉼표를 찍다"
            const Text(
              "쉼표를 찍다",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Pretendard',
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
