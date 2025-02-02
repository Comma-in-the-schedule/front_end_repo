import 'package:flutter/material.dart';
import 'custom_button.dart';

class NonLoggedInScreen extends StatelessWidget {
  const NonLoggedInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                      Navigator.pushNamed(context, '/register');
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: CustomButton(
                    text: '로그인',
                    iconPath: 'assets/icons/logo_white.png',
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
