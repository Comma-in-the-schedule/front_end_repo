import 'package:flutter/material.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final TextEditingController _nicknameController = TextEditingController();

  // 🔹 선택 가능한 카테고리
  final List<String> categories = ["전시회", "팝업", "헬스", "물류", "영화"];
  final List<String> selectedCategories = [];

  void toggleCategory(String category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "설문조사",
          style: TextStyle(
            fontFamily: 'Pretendard-Bold',
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 로고 및 타이틀
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/icons/logo_black.png',
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "바쁜 일상에",
                        style: TextStyle(
                          fontFamily: 'Pretendard-Bold',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        "쉼표를 찍다",
                        style: TextStyle(
                          fontFamily: 'Pretendard-Bold',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 🔹 닉네임 입력 필드
            const Text(
              "닉네임",
              style: TextStyle(
                fontFamily: 'Pretendard-Bold',
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: _nicknameController,
              decoration: InputDecoration(
                hintText: "쉼표에서 사용할 이름 또는 닉네임을 입력해주세요.",
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 주요 활동 위치
            const Text(
              "주요 활동 위치",
              style: TextStyle(
                fontFamily: 'Pretendard-Bold',
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),

            // 🔹 추천 받고 싶은 쉼표 활동
            const Text(
              "추천 받고 싶은 쉼표 활동",
              style: TextStyle(
                fontFamily: 'Pretendard-Bold',
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),

            // 🔹 선택 가능한 카테고리 버튼
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.map((category) {
                final isSelected = selectedCategories.contains(category);
                return GestureDetector(
                  onTap: () => toggleCategory(category),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        fontFamily: 'Pretendard-Bold',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const Spacer(),

            // 🔹 제출 버튼
            ElevatedButton(
              onPressed: () {
                // TODO: 제출 기능 구현
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/logo_w.png',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "제출하기",
                    style: TextStyle(
                      fontFamily: 'Pretendard-Bold',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
