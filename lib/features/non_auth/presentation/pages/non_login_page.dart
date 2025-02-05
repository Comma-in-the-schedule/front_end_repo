import 'dart:math';
import 'package:flutter/material.dart';

class NonLoginPage extends StatefulWidget {
  const NonLoginPage({super.key});

  @override
  _NonLoginPageState createState() => _NonLoginPageState();
}

class _NonLoginPageState extends State<NonLoginPage>
    with SingleTickerProviderStateMixin {
  late String backgroundImage;
  late DraggableScrollableController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = DraggableScrollableController();

    // 배경 이미지를 랜덤하게 선택
    List<String> backgrounds = [
      'assets/icons/bg_gym.png',
      'assets/icons/bg_movie.png'
    ];
    backgroundImage = backgrounds[Random().nextInt(backgrounds.length)];

    // 일정 시간 후 슬라이드 자동 상승 (60%까지 올라가게 수정)
    Future.delayed(const Duration(milliseconds: 500), () {
      _scrollController.animateTo(
        0.6, // 자동으로 올라갈 높이 (60%)
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //  랜덤 배경 이미지
          Positioned.fill(
            child: Image.asset(
              backgroundImage,
              fit: BoxFit.cover,
            ),
          ),
          //  로고 및 텍스트 복구 (백그라운드 위에 배치)
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
                    SizedBox(width: 150),
                  ],
                ),
                Transform.translate(
                  offset: const Offset(0, -27),
                  child: Image.asset(
                    'assets/icons/logo_w.png',
                    width: 75,
                    height: 75,
                    fit: BoxFit.contain,
                  ),
                ),
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 160),
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
          //  아래에서 올라오는 슬라이드 패널
          DraggableScrollableSheet(
            controller: _scrollController,
            initialChildSize: 0.1,
            minChildSize: 0.1,
            maxChildSize: 0.6,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
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
                        const SizedBox(height: 50),
                        const Text(
                          "환영합니다,",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Pretendard-Black',
                            letterSpacing: 0.5,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Pretendard-ExtraBold',
                              color: Color(0xFF989898),
                            ),
                            children: [
                              TextSpan(text: "빠른 로그인/회원가입 후 개인 맞춤화 "),
                              TextSpan(
                                text: "쉼표",
                                style: TextStyle(
                                  fontFamily: 'Pretendard-ExtraBold',
                                  color: Color(0xFF262627),
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              TextSpan(text: " 서비스를\n이용해 보세요,"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 기존 버튼 영역 유지
                        Placeholder(
                          fallbackHeight: 150,
                          color: Colors.grey[400]!,
                        ),

                        // 새로운 버튼 추가
                        const SizedBox(height: 20), // 기존 버튼과의 간격
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center, // 버튼을 정확히 중앙에 배치
                          children: [
                            SizedBox(
                              width: 140, // 버튼 너비 조정 (더 중앙 정렬)
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF262627),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                ),
                                child: Stack(
                                  alignment: Alignment.center, //  내부 요소 중앙 정렬
                                  children: [
                                    Transform.translate(
                                      offset: const Offset(
                                          -50, 0), //  로고를 더 왼쪽으로 이동
                                      child: Image.asset(
                                        'assets/icons/logo_w.png',
                                        width: 18,
                                        height: 18,
                                      ),
                                    ),
                                    const Text(
                                      "회원가입",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Pretendard-Bold', //  폰트 설정
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16), //  버튼 간격 유지
                            SizedBox(
                              width: 140, //  버튼 너비 조정 (더 중앙 정렬)
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF262627),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                ),
                                child: Stack(
                                  alignment: Alignment.center, //  내부 요소 중앙 정렬
                                  children: [
                                    Transform.translate(
                                      offset: const Offset(
                                          -50, 0), //  로고를 더 왼쪽으로 이동
                                      child: Image.asset(
                                        'assets/icons/logo_w.png',
                                        width: 18,
                                        height: 18,
                                      ),
                                    ),
                                    const Text(
                                      "로그인",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Pretendard-Bold', //  폰트 설정
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20), // 하단 여백 조정
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
