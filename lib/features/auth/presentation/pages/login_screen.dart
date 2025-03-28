import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:comma_in_the_schedule/features/auth/data/auth_api.dart';
import 'package:comma_in_the_schedule/features/auth/presentation/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthApi _authApi = AuthApi();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // FlutterSecureStorage 인스턴스 생성 (공용으로 사용)
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// 📌 이메일 유효성 검사
  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _emailError = null;
      } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
          .hasMatch(value)) {
        _emailError = '올바른 이메일 형식을 입력해주세요.';
      } else {
        _emailError = null;
      }
    });
  }

  /// 📌 비밀번호 유효성 검사
  void _validatePassword(String value) {
    setState(() {
      _passwordError = null;
    });
  }

  /// 📌 로그인 요청 (API 호출)
  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    setState(() {
      if (email.isEmpty) {
        _emailError = '이메일을 입력해주세요.';
      }
      if (password.isEmpty) {
        _passwordError = '비밀번호를 입력해주세요.';
      }
    });

    if (_emailError != null || _passwordError != null) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _authApi.login(email, password);

      if (!mounted) return;

      if (response['isSuccess'] == true && response['code'] == 'OK200') {
        final result = response['result'];

        if (result != null &&
            result['token'] != null &&
            result['refreshToken'] != null &&
            result['userDTO'] != null &&
            result['userDTO']['email'] != null) {
          final String token = result['token'];
          final String refreshToken = result['refreshToken'];
          final String userEmail = result['userDTO']['email'];

          bool isSaved = await _saveUserData(token, refreshToken, userEmail);

          if (isSaved) {
            Navigator.pushNamed(context, '/');
          } else {
            _showDialog(
              title: '오류',
              message1: "로그인에 실패했습니다.",
              message2: "잠시 후 다시 시도해주세요.",
            );
          }
        } else {
          _showDialog(
            title: '오류',
            message1: "로그인에 실패했습니다.",
            message2: "잠시 후 다시 시도해주세요.",
          );
        }
      } else if (response['isSuccess'] == false &&
          (response['code'] == 'USER101' || response['code'] == 'USER102')) {
        _showDialog(
          title: '오류',
          message1: "이메일 또는 비밀번호가 잘못되었습니다.",
        );
      } else {
        _showDialog(title: '오류', message1: "알 수 없는 오류가 발생했습니다.");
      }
    } catch (e) {
      _showDialog(
        title: '오류',
        message1: '현재 서비스를 이용할 수 없습니다.',
        message2: '잠시 후 다시 시도해주세요.',
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 📌 이메일과 토큰을 FlutterSecureStorage에 저장
  Future<bool> _saveUserData(
      String token, String refreshToken, String email) async {
    try {
      await _secureStorage.write(key: 'token', value: token);
      await _secureStorage.write(key: 'refreshToken', value: refreshToken);
      await _secureStorage.write(key: 'userEmail', value: email);

      // 저장된 데이터 확인 (비동기적으로 다시 읽기)
      String? savedToken = await _secureStorage.read(key: 'token');
      String? savedRefreshToken =
          await _secureStorage.read(key: 'refreshToken');
      String? savedEmail = await _secureStorage.read(key: 'userEmail');

      print('✅ 저장된 토큰: $savedToken');
      print('✅ 저장된 이메일: $savedEmail');

      return savedToken == token &&
          savedRefreshToken == refreshToken &&
          savedEmail == email;
    } catch (e) {
      print('❌ 데이터 저장 오류: $e');
      return false;
    }
  }

  /// 📌 메시지 다이얼로그
  void _showDialog({
    required String title,
    required String message1,
    String? message2,
    String? navigateTo,
  }) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF262627),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontFamily: 'Pretendard',
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message1,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontFamily: 'Pretendard',
              ),
            ),
            if (message2 != null) ...[
              const SizedBox(height: 5),
              Text(
                message2,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontFamily: 'Pretendard',
                ),
              ),
            ],
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (navigateTo != null) {
                Navigator.pushReplacementNamed(context, navigateTo);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF262627),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '확인',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'Pretendard',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '로그인',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontFamily: 'Pretendard',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF262627),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '바쁜 일상에',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: Image.asset(
                      'assets/icons/logo_black.png',
                      width: 60,
                      height: 60,
                    ),
                  ),
                  const Text(
                    '쉼표를 찍다',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // 이메일 입력
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF2F4F5),
                  hintText: '이메일',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: _emailError != null
                          ? const Color(0xFFB00020)
                          : const Color(0xFFBDBDBD),
                      width: 1,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: _emailError != null
                          ? const Color(0xFFB00020)
                          : const Color(0xFF262627),
                      width: 1,
                    ),
                  ),
                  errorText: _emailError,
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: _validateEmail,
              ),
              const SizedBox(height: 16),

              // 비밀번호 입력
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF2F4F5),
                  hintText: '비밀번호',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 11, horizontal: 15),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: _passwordError != null
                          ? const Color(0xFFB00020)
                          : const Color(0xFFBDBDBD),
                      width: 1,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: _passwordError != null
                          ? const Color(0xFFB00020)
                          : const Color(0xFF262627),
                      width: 1,
                    ),
                  ),
                  errorText: _passwordError,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible),
                  ),
                ),
                onChanged: _validatePassword,
              ),

              // 비밀번호 찾기
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/forgot-password');
                  },
                  child: const Text(
                    '비밀번호 찾기',
                    style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 로그인 버튼
              CustomButton(
                text: '로그인',
                iconPath: 'assets/icons/logo_w.png',
                onPressed: _login,
              ),

              // 회원가입
              Align(
                alignment: Alignment.center,
                child: TextButton(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
