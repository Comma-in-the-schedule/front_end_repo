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
  String selectedCategory = "전체"; // 선택된 카테고리

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UserProfile(),
            CategoryBar(
              onCategorySelected: (category) {
                setState(() {
                  selectedCategory = category;
                });
              },
            ),
            // 선택된 카테고리를 ContentList에 전달하여 필터링
            Expanded(child: ContentList(selectedCategory: selectedCategory)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}
