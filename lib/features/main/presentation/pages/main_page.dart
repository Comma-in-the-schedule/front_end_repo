import 'package:flutter/material.dart';
import '../widgets/category_bar.dart';
import '../widgets/content_list.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/user_profile.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String selectedCategory = "전체"; // 기본적으로 전체 리스트 표시

  // 더미 데이터 (추후 API 연결 예정)
  final List<Map<String, String>> allContent = [
    {"title": "전시회1", "category": "전시회/팝업"},
    {"title": "전시회2", "category": "전시회/팝업"},
    {"title": "전시회3", "category": "전시회/팝업"},
    {"title": "전시회4", "category": "전시회/팝업"},
    {"title": "전시회5", "category": "전시회/팝업"},
    {"title": "영화1", "category": "영화"},
    {"title": "영화2", "category": "영화"},
    {"title": "헬스1", "category": "헬스"},
    {"title": "물류1", "category": "물류"},
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredContent = selectedCategory == "전체"
        ? allContent
        : allContent
            .where((item) => item["category"] == selectedCategory)
            .toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UserProfile(), // 🔹 `const` 적용
            CategoryBar(
              onCategorySelected: (category) {
                setState(() {
                  selectedCategory = category;
                });
              },
            ),
            Expanded(
              child: filteredContent.isEmpty
                  ? const Center(
                      child: Text(
                        "표시할 항목이 없습니다",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    )
                  : ContentList(content: filteredContent),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0), // 🔹 `const` 제거
    );
  }
}
