import 'package:flutter/material.dart';

class LogoBanner extends StatelessWidget {
  const LogoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, //컨테이너 높이 설정
      color: Colors.red, //추후 지우기
      alignment: Alignment.center, // 전체 정렬
      child: Transform.translate(
        offset: const Offset(0, -5), //전체를 위로 이동
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end, // 글자와 로고 하단 정렬
          children: [
            Transform.translate(
              offset: const Offset(15, 5), // 글자를 왼쪽으로 2px 이동
              child: const Text(
                "바쁜 일상에",
                style: TextStyle(
                  fontSize: 14, // 🔹 글자 크기
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Pretendard-Black',
                  color: Color(0xFF262627), //글자색 변경
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, 8), // 로고를 위로 올려 더 붙이기
              child: Image.asset(
                'assets/icons/logo_b.png',
                width: 70, // 🔹 크기 조정
                height: 70,
                fit: BoxFit.contain,
              ),
            ),
            Transform.translate(
              offset: const Offset(-10, 5), // 글자를 오른쪽으로 2px 이동
              child: const Text(
                "쉼표를 찍다,",
                style: TextStyle(
                  fontSize: 14, // 🔹 글자 크기
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Pretendard-Black',
                  color: Color(0xFF262627), // 글자색 변경
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
