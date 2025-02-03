import 'package:flutter/material.dart';
import 'package:comma_in_the_schedule/features/main/presentation/widgets/bottom_nav_bar.dart';

class BaseScreen extends StatelessWidget {
  final Widget body;
  final int currentIndex; // 현재 선택된 탭 인덱스

  const BaseScreen({super.key, required this.body, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: body,
      bottomNavigationBar:
          BottomNavBar(currentIndex: currentIndex), // 🔹 현재 선택된 탭 인덱스를 전달
    );
  }
}
