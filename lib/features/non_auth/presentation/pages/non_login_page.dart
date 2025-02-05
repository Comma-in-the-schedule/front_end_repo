import 'dart:math';
import 'package:flutter/material.dart';

class NonLoginPage extends StatefulWidget {
  const NonLoginPage({super.key});

  @override
  _NonLoginPageState createState() => _NonLoginPageState();
}

class _NonLoginPageState extends State<NonLoginPage> {
  late String backgroundImage;

  @override
  void initState() {
    super.initState();
    // 🔹 배경 이미지를 랜덤하게 선택
    List<String> backgrounds = [
      'assets/icons/bg_gym.png',
      'assets/icons/bg_movie.png'
    ];
    backgroundImage = backgrounds[Random().nextInt(backgrounds.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔹 랜덤 배경 이미지
          Positioned.fill(
            child: Image.asset(
              backgroundImage,
              fit: BoxFit.cover,
            ),
          ),
          // 🔹 로고 및 텍스트 (Stack을 활용해 간격 최소화)
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "바쁜 일상에",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Pretendard-Bold',
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 170), // 🔹 간격 제거
                  ],
                ),
                Transform.translate(
                  offset: const Offset(0, -29), // 🔹 로고를 더 위로 이동
                  child: Image.asset(
                    'assets/icons/logo_w.png',
                    width: 75, // 🔹 크기를 살짝 줄여서 맞추기
                    height: 75,
                    fit: BoxFit.contain,
                  ),
                ),
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 180), // 🔹 로고 크기만큼 밀어주기
                    Text(
                      "쉼표를 찍다,",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Pretendard-Bold',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 🔹 아래에서 올라오는 슬라이드 패널
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.3,
            maxChildSize: 0.7, //슬라이드 최대 높이 조절
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "환영, 합니다",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "빠른 로그인/회원가입 후 개인 맞춤화 쉼표 서비스를 이용해 보세요",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // 🔹 버튼 영역 (추후 디자인 적용)
                        Placeholder(
                          fallbackHeight: 150,
                          color: Colors.grey[400]!,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
