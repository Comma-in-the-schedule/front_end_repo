// lib/features/splash/presentation/pages/splash_page.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  // FlutterSecureStorage 인스턴스 생성 (로그인 시 저장한 토큰 및 이메일 사용)
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 설정 (2초 동안 실행)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    // 0에서 1로 점점 나타나는 애니메이션 설정
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // 3초 후 다음 페이지로 이동
    Timer(const Duration(seconds: 3), _navigateNext);
  }

  Future<void> _navigateNext() async {
    // 저장된 토큰 읽어오기
    final token = await _secureStorage.read(key: 'token');
    // 저장된 이메일 읽어오기 (토큰 디코딩 대신 secure storage에서 직접 읽음)
    final email = await _secureStorage.read(key: 'userEmail') ?? "";

    // 디버깅: 저장된 값 출력
    debugPrint('토큰: $token');
    debugPrint('이메일: $email');

    // 토큰이나 이메일이 없으면 로그인 페이지로 이동
    if (token == null || token.isEmpty || email.isEmpty) {
      debugPrint('토큰이나 이메일이 없어서 로그인 페이지로 이동');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const NonLoginPage()),
      );
      return;
    }

    // 설문조사 API 호출: 저장된 이메일을 사용하여 설문조사 결과 확인 (GET 방식)
    final authApi = AuthApi();
    final surveyResponse =
        await authApi.checkSurvey(token: token, email: email);

    // 디버깅: API 응답 출력
    debugPrint('설문조사 API 응답: $surveyResponse');

    // API 응답에 따른 분기 처리
    if (surveyResponse['isSuccess'] == false &&
        surveyResponse['code'] == 'SURVEY301' &&
        surveyResponse['result'] == '_SURVEY_NOT_EXISTS') {
      debugPrint('설문조사가 진행되지 않았으므로 설문조사 페이지로 이동');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SurveyPage()),
      );
    } else if (surveyResponse['isSuccess'] == true &&
        surveyResponse['code'] == 'OK200') {
      debugPrint('설문조사 결과가 존재하므로 메인 페이지로 이동');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } else {
      // 그 외 예상치 못한 API 응답(예: 서버 오류 등)인 경우,
      // 로그인 정보가 유효하지 않은 것으로 간주하여 로그인 페이지로 이동
      debugPrint('예외적인 API 응답 또는 서버 오류로 인해 로그인 페이지로 이동');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const NonLoginPage()),
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
            const SizedBox(width: 0),
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
            const SizedBox(width: 0),
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
