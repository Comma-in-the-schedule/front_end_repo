import 'package:flutter/material.dart';
import 'package:comma_in_the_schedule/routes/app_routes.dart';
import 'package:comma_in_the_schedule/features/non_auth/presentation/pages/non_login_page.dart'; // 🔹 비로그인 페이지 import

class BottomNavBar extends StatefulWidget {
  final int currentIndex; // 현재 선택된 탭 인덱스

  const BottomNavBar({super.key, required this.currentIndex});

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex; // 현재 선택된 탭 인덱스를 유지
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return; // 같은 페이지일 경우 다시 이동하지 않음

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.main, (route) => false);
        break;
      case 1:
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.nonLoggedIn, (route) => false);
        break;
      case 2:
        // 🔹 알림 버튼을 누르면 `NonLoginPage`로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NonLoginPage(),
          ),
        );
        break;
      case 3:
        // 아직 연결할 페이지 없음 (마이페이지)
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: const Color(0xFF262627),
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(fontSize: 8),
      unselectedLabelStyle: const TextStyle(fontSize: 8),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "캘린더"),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "알림"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "마이페이지"),
      ],
    );
  }
}
