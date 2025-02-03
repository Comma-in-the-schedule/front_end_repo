import 'package:flutter/material.dart';
import 'dart:async';
import '../../../main/presentation/pages/main_page.dart'; // 메인 페이지 import

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 설정 (1.5초 동안 실행)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward(); // 실행 시작

    // 0에서 1로 점점 나타나는 애니메이션 설정
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // 3초 후 메인 페이지로 이동
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    });
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
          children: [
            // 왼쪽 텍스트: "바쁜 일상에"
            const Text(
              "바쁜 일상에",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(width: 10), // 간격 추가

            // 로고 아이콘 (애니메이션 적용)
            FadeTransition(
              opacity: _animation, // 투명도 애니메이션 적용
              child: const Icon(
                Icons.cloud, // ☁️ 아이콘 변경
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10), // 간격 추가

            // 오른쪽 텍스트: "쉼표를 찍다"
            const Text(
              "쉼표를 찍다",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
