import 'dart:async';

import 'package:flutter/material.dart';

import 'package:comma_in_the_schedule/features/auth/data/auth_api.dart';
import 'package:comma_in_the_schedule/features/auth/presentation/widgets/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthApi _authApi = AuthApi();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  bool _isEmailVerified = false;
  bool _isVerifying = false;

  static const int initialTimerDuration = 60; // 타이머 기본 값 (초)
  int _timer = initialTimerDuration;
  Timer? _countdownTimer;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  /// 📌 이메일 유효성 검사
  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _emailError = '이메일을 입력하세요.';
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
      if (value.isEmpty) {
        _passwordError = null;
      } else if (value.length < 8 || value.length > 20) {
        _passwordError = '비밀번호는 8자 이상 20자 이하로 입력해주세요.';
      } else {
        _passwordError = null;
      }
    });
  }

  /// 📌 비밀번호 확인 유효성 검사
  void _validateConfirmPassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _confirmPasswordError = null;
      } else if (value != _passwordController.text) {
        _confirmPasswordError = '비밀번호가 일치하지 않습니다.';
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  /// 📌 이메일 인증 요청 (API 호출)
  Future<void> _sendEmailVerification() async {
    String email = _emailController.text.trim();

    _validateEmail(email);

    if (_emailError != null) return;

    setState(() => _isVerifying = true);

    try {
      final response = await _authApi.sendEmailVerification(email);

      if (!mounted) return;

      if (response['isSuccess'] == true && response['code'] == 'OK200') {
        _showVerificationDialog();
      } else if (response['isSuccess'] == false &&
          response['code'] == 'USER105') {
        _showDialog(
          title: '오류',
          message1: response['message'], // 이미 인증을 완료한 이메일입니다.
        );
      } else {
        _showDialog(title: '오류', message1: '알 수 없는 오류가 발생했습니다.');
      }
    } catch (e) {
      _showDialog(
        title: '오류',
        message1: '현재 서비스를 이용할 수 없습니다.',
        message2: '잠시 후 다시 시도해주세요.',
      );
    } finally {
      setState(() => _isVerifying = false);
    }
  }

  /// 📌 이메일 인증 확인 (API 호출)
  Future<void> _verifyEmailCode() async {
    String email = _emailController.text.trim();

    setState(() => _isVerifying = true);

    try {
      final response = await _authApi.verifyEmailCode(email);

      if (!mounted) return;

      if (response['isSuccess'] == true && response['code'] == 'OK200') {
        setState(() => _isEmailVerified = true);
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) Navigator.pop(context);
        });
      } else if (response['isSuccess'] == false &&
          response['code'] == 'USER103') {
        if (mounted) Navigator.pop(context);
        _showDialog(
            title: '오류',
            message1: response['message'], // 이메일 인증이 완료되지 않았습니다.
            message2: '다시 시도해주세요.');
        setState(() {
          _isEmailVerified = false;
        });
      } else {
        _showDialog(title: '오류', message1: '알 수 없는 오류가 발생했습니다.');
      }
    } catch (e) {
      _showDialog(
        title: '오류',
        message1: '현재 서비스를 이용할 수 없습니다.',
        message2: '잠시 후 다시 시도해주세요.',
      );
    } finally {
      setState(() => _isVerifying = false);
    }
  }

  /// 📌 회원가입 요청 (API 호출)
  /// - 이메일 인증이 완료되지 않으면 회원가입 불가능
  /// - API 요청 후 성공하면 로그인 페이지로 이동
  Future<void> _register() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    setState(() {
      if (!_isEmailVerified) {
        _emailError = '이메일 인증을 완료해주세요.';
      }

      if (password.isEmpty) {
        _passwordError = '비밀번호를 입력해주세요.';
      }

      if (confirmPassword.isEmpty) {
        _confirmPasswordError = '비밀번호 확인을 입력해주세요.';
      }

      if (confirmPassword != password) {
        _confirmPasswordError = '비밀번호가 일치하지 않습니다.';
      }
    });

    if (!_isEmailVerified ||
        _passwordError != null ||
        _confirmPasswordError != null) {
      return;
    }

    setState(() => _isVerifying = true);

    try {
      print("[회원가입 DEBUG] 회원가입 요청 시작 - email: $email");

      final response = await _authApi.signup(email, password);

      print("[회원가입 DEBUG] 회원가입 API 응답: $response");

      if (!mounted) {
        print("[회원가입 DEBUG] 위젯이 더 이상 마운트되지 않음. 반환.");
        return;
      }

      if (response['isSuccess'] == true && response['code'] == 'OK200') {
        print("[회원가입 DEBUG] 회원가입 성공 - email: $email");
        _showDialog(
          title: '회원가입 완료',
          message1: '회원가입이 완료되었습니다.',
          message2: '로그인 페이지로 이동합니다.',
          navigateTo: '/login',
        );
      } else if (response['isSuccess'] == false &&
          response['code'] == 'USER100') {
        print("[회원가입 DEBUG] 회원가입 실패 - 이미 가입된 계정: $email");
        _showDialog(
          title: '오류',
          message1: response['message'], // 이미 가입된 계정입니다.
        );
      } else if (response['isSuccess'] == false &&
          response['code'] == 'USER103') {
        print("[회원가입 DEBUG] 회원가입 실패 - 이메일 인증 미완료: $email");
        _showDialog(
          title: '오류',
          message1: response['message'], // 이메일 인증이 완료되지 않았습니다.
          message2: '인증을 완료해주세요.',
        );
      } else {
        print("[회원가입 ERROR] 알 수 없는 오류 발생 - 응답 데이터: $response");
        _showDialog(
          title: '오류',
          message1: '알 수 없는 오류가 발생했습니다.',
        );
      }
    } catch (e, stackTrace) {
      print("[회원가입 ERROR] 회원가입 요청 중 예외 발생: $e");
      print("[회원가입 ERROR] 스택 트레이스: $stackTrace");
      _showDialog(
        title: '오류',
        message1: '현재 서비스를 이용할 수 없습니다.',
        message2: '잠시 후 다시 시도해주세요.',
      );
    } finally {
      setState(() {
        _isVerifying = false;
        print("[회원가입 DEBUG] _isVerifying 상태 변경: false");
      });
    }
  }

  /// 📌 이메일 인증 다이얼로그
  /// - 인증시간이 만료되면 다이얼로그를 닫음
  void _showVerificationDialog() {
    bool timerStarted = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            if (!timerStarted) {
              timerStarted = true;
              _startTimer(setDialogState);
            }

            final minutes = _timer ~/ 60;
            final seconds = _timer % 60;
            final timeDisplay =
                "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
            final timerText = timeDisplay;

            return AlertDialog(
              backgroundColor: const Color(0xFF262627),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: const Text(
                '이메일 인증',
                style: TextStyle(
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
                    _timer > 0 ? '인증 이메일이 발송되었습니다.' : '인증시간이 만료되었습니다.',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _timer > 0 ? '메일함을 확인하고 인증 링크를 클릭해주세요.' : '다시 시도해 주세요.',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  if (_timer > 0) ...[
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          timerText,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                        const SizedBox(width: 15),
                        ElevatedButton(
                          onPressed: _isVerifying ? null : _verifyEmailCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF262627),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isVerifying
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
                              : const Text('인증완료'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// 📌 이메일 인증 타이머 (60초)
  void _startTimer(void Function(void Function()) setDialogState) {
    _countdownTimer?.cancel();
    _timer = initialTimerDuration;

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timer == 0 || _isEmailVerified) {
        timer.cancel();
        if (_timer == 0) {
          // setDialogState(() {});
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) Navigator.pop(context);
          });
        }
      } else {
        setDialogState(() => _timer--);
      }
    });
  }

  /// 📌 메시지 다이얼로그
  void _showDialog({
    required String title,
    required String message1,
    String? message2,
    String? navigateTo, // 특정 페이지 이동할 경우 사용
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
          '회원가입',
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

              // 이메일 입력 + 인증요청 버튼
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: _emailController,
                      enabled: !_isEmailVerified,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF2F4F5),
                        hintText: '이메일',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 15,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: _emailError != null
                                ? Color(0xFFB00020)
                                : Color(0xFFBDBDBD),
                            width: 1,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: _emailError != null
                                ? Color(0xFFB00020)
                                : Color(0xFF262627),
                            width: 1,
                          ),
                        ),
                        errorText: _emailError,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: _validateEmail,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed:
                          _isEmailVerified ? null : _sendEmailVerification,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF262627),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.white,
                        disabledForegroundColor: const Color(0xFF262627),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: BorderSide(
                            color: const Color(0xFF262627),
                          ),
                        ),
                      ),
                      child: Text(_isEmailVerified ? '인증완료' : '인증요청'),
                    ),
                  ),
                ],
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
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 11,
                    horizontal: 15,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: _passwordError != null
                          ? Color(0xFFB00020)
                          : Color(0xFFBDBDBD),
                      width: 1,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: _passwordError != null
                          ? Color(0xFFB00020)
                          : Color(0xFF262627),
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
              const SizedBox(height: 16),

              // 비밀번호 확인 입력
              TextField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF2F4F5),
                  hintText: '비밀번호 확인',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 11,
                    horizontal: 15,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: _confirmPasswordError != null
                          ? Color(0xFFB00020)
                          : Color(0xFFBDBDBD),
                      width: 1,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: _confirmPasswordError != null
                          ? Color(0xFFB00020)
                          : Color(0xFF262627),
                      width: 1,
                    ),
                  ),
                  errorText: _confirmPasswordError,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () => setState(() =>
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                  ),
                ),
                onChanged: _validateConfirmPassword,
              ),
              const SizedBox(height: 70),

              // 회원가입 버튼
              CustomButton(
                text: '회원가입',
                iconPath: 'assets/icons/logo_w.png',
                onPressed: _register,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
