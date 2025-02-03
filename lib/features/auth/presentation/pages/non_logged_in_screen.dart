import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import 'package:comma_in_the_schedule/routes/app_routes.dart';
import 'package:comma_in_the_schedule/widgets/base_screen.dart';

class NonLoggedInScreen extends StatelessWidget {
  const NonLoggedInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      currentIndex: 1, // 🔹 '캘린더' 버튼이 활성화되도록 설정
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: CustomButton(
                    text: '회원가입',
                    iconPath: 'assets/icons/logo_white.png',
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.register);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomButton(
                    text: '로그인',
                    iconPath: 'assets/icons/logo_white.png',
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.login);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
