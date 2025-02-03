import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '로그인',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFffffff),
        foregroundColor: const Color(0xFF262627),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '바쁜 일상에',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Image.asset(
                      'assets/icons/logo_black.png',
                      width: 60,
                      height: 60,
                    ),
                  ),
                  const Text(
                    '쉼표를 찍다',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const TextField(
                decoration: InputDecoration(
                  labelText: '이메일',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                style: TextStyle(
                  color: Color(0xFF262627),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                obscureText: true,
                style: TextStyle(
                  color: Color(0xFF262627),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    '비밀번호 찾기',
                    style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: '로그인',
                iconPath: 'assets/icons/logo_white.png',
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text(
                  '회원가입',
                  style: TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
