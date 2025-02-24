import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:comma_in_the_schedule/features/auth/data/auth_api.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  Future<Map<String, dynamic>> _fetchSurvey() async {
    final storage = const FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final email = await storage.read(key: 'userEmail');
    if (token == null || email == null) {
      throw Exception("로그인 토큰 또는 이메일 정보가 없습니다.");
    }
    final authApi = AuthApi();
    final response = await authApi.checkSurvey(token: token, email: email);
    if (response['isSuccess'] == true) {
      return response['result'];
    } else {
      throw Exception("설문조사 정보를 불러오지 못했습니다: ${response['message']}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchSurvey(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('오류: ${snapshot.error}'));
        }
        if (snapshot.hasData) {
          final surveyData = snapshot.data!;
          final nickname = surveyData['nickName'] ?? "닉네임";
          final location = surveyData['location'] ?? "서울 강남구";

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // 양쪽 여백 추가
            child: Column(
              children: [
                const SizedBox(height: 50), // 위 공간 추가
                Container(
                  width: 358, // 컨테이너 너비 고정
                  height: 58, // 컨테이너 높이 고정
                  decoration: BoxDecoration(
                    color: Colors.white, // 배경색
                    borderRadius: BorderRadius.circular(12), // 모서리 둥글게
                    boxShadow: const [
                      // 그림자 추가
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(2, 4), // 그림자 위치
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(10.0), // 내부 패딩 추가
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 20, // 크기 조정
                        backgroundImage:
                            AssetImage('assets/btm_nav_pre.png'), // 프로필 이미지
                      ),
                      const SizedBox(width: 12), // 아이콘과 텍스트 사이 간격
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            nickname,
                            style: const TextStyle(
                              fontSize: 13, // 글자 크기
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF262627),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // TODO: 클릭 시 이벤트 추가
                              print("주요 활동 위치 클릭됨");
                            },
                            child: Text(
                              "주요 활동 위치: $location",
                              style: const TextStyle(
                                fontSize: 12, // 글자 크기
                                color: Colors.grey,
                                decoration: TextDecoration.underline, // 밑줄 추가
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
