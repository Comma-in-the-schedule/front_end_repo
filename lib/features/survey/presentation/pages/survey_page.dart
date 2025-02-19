import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:comma_in_the_schedule/widgets/logo_banner.dart';
import 'package:comma_in_the_schedule/features/auth/data/auth_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// jwt_decoder 관련 코드는 더 이상 사용하지 않습니다.

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final TextEditingController _nicknameController = TextEditingController();

  // 🔹 선택 가능한 카테고리 리스트
  final List<String> categories = [
    "전시회",
    "팝업스토어",
    "헬스",
    "영화",
    "음식",
    "패션",
    "여행",
  ];

  List<String> selectedCategories = []; // 다중 선택 가능하도록 변경

  // 🔹 지역 선택 관련 변수
  final List<String> locations = ["서울특별시", "경기"];
  final Map<String, List<String>> subLocations = {
    "서울특별시": ["강남구", "서초구", "마포구", "송파구"],
    "경기": ["수원시", "성남시", "고양시", "용인시"]
  };

  String selectedLocation = "서울특별시"; // 기본 지역 선택
  String? selectedSubLocation; // 기본 하위 지역 선택

  // FlutterSecureStorage 인스턴스 (로그인 시 저장했던 토큰과 이메일 사용)
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final AuthApi _authApi = AuthApi();

  void _onCategorySelected(String category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category); // 선택 해제
      } else {
        selectedCategories.add(category); // 선택 추가
      }
    });
  }

  Future<void> _showRequestBodyDialog(
      Map<String, dynamic> requestBody, String token) async {
    // AlertDialog로 요청 바디 보여주기
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("요청 바디 확인"),
          content: SingleChildScrollView(
            child: Text(
              const JsonEncoder.withIndent("  ").convert(requestBody),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // 취소
              },
              child: const Text("취소"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // 제출하기 선택
              },
              child: const Text("제출하기"),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      debugPrint("사용자가 제출하기를 선택했습니다. API 호출 시작");
      // API 호출
      final response = await _authApi.submitSurvey(
        token: token,
        email: requestBody['email'],
        nickname: requestBody['nickname'],
        location: requestBody['location'],
        category: List<int>.from(requestBody['category']),
      );

      if (response['isSuccess'] == true) {
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("설문조사 완료"),
              content: const Text("설문조사가 제출되었습니다."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("확인"),
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("오류 발생: ${response['message']}")),
        );
      }
    } else {
      debugPrint("사용자가 제출 취소를 선택했습니다.");
    }
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "설문조사",
          style: TextStyle(
            fontFamily: 'Pretendard-Bold',
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 로고 배너 추가
              const LogoBanner(),
              const SizedBox(height: 30),
              // 닉네임 입력 필드
              Row(
                children: const [
                  Text(
                    "* ",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "닉네임",
                    style: TextStyle(
                      fontFamily: 'Pretendard-Bold',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF2F4F5),
                  hintText: "쉼표에서 사용할 이름 또는 닉네임을 입력해주세요.",
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFBDBDBD), width: 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF262627), width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // 주요 활동 위치
              Row(
                children: const [
                  Text(
                    "* ",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "주요 활동 위치",
                    style: TextStyle(
                      fontFamily: 'Pretendard-Bold',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedLocation,
                      items: locations
                          .map((String location) => DropdownMenuItem<String>(
                                value: location,
                                child: Text(location),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedLocation = value!;
                          selectedSubLocation = null;
                        });
                      },
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFF2F4F5),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFBDBDBD), width: 1),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF262627), width: 1),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedSubLocation,
                      items: subLocations[selectedLocation]!
                          .map((String subLocation) => DropdownMenuItem<String>(
                                value: subLocation,
                                child: Text(subLocation),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSubLocation = value;
                        });
                      },
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFF2F4F5),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFBDBDBD), width: 1),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF262627), width: 1),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // 관심 카테고리 선택 추가
              Row(
                children: const [
                  Text(
                    "* ",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "관심 카테고리",
                    style: TextStyle(
                      fontFamily: 'Pretendard-Bold',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((category) {
                  final isSelected = selectedCategories.contains(category);
                  return GestureDetector(
                    onTap: () => _onCategorySelected(category),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              // 제출 버튼 (디자인 수정)
              SizedBox(
                width: double.infinity, // 부모 전체 너비 사용
                height: 50, // 높이 50px
                child: ElevatedButton.icon(
                  onPressed: () async {
                    debugPrint("제출하기 버튼 클릭됨");
                    // 기본 입력값 검증
                    if (_nicknameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("닉네임을 입력해주세요.")),
                      );
                      return;
                    }
                    if (selectedSubLocation == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("하위 지역을 선택해주세요.")),
                      );
                      return;
                    }
                    if (selectedCategories.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("관심 카테고리를 최소 한 개 이상 선택해주세요."),
                        ),
                      );
                      return;
                    }

                    final String nickname = _nicknameController.text.trim();
                    // 선택된 지역 조합 (예: "서울특별시 강남구")
                    final String location =
                        "$selectedLocation $selectedSubLocation";

                    // 선택된 카테고리 이름을 id로 변환 (예: 목록의 index + 1)
                    final List<int> categoryIds = selectedCategories
                        .map((cat) => categories.indexOf(cat) + 1)
                        .toList();

                    // 저장된 토큰 불러오기
                    final String? token = await _storage.read(key: 'token');
                    if (token == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("로그인 토큰이 존재하지 않습니다.")),
                      );
                      return;
                    }

                    // 저장된 이메일 읽어오기 (토큰 디코딩 대신)
                    final String? storedEmail =
                        await _storage.read(key: 'userEmail');
                    if (storedEmail == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("저장된 이메일 정보를 가져오지 못했습니다.")),
                      );
                      return;
                    }

                    // 요청 바디 구성
                    final Map<String, dynamic> requestBody = {
                      'email': storedEmail,
                      'nickname': nickname,
                      'location': location,
                      'category': categoryIds,
                    };

                    debugPrint("요청 바디: ${jsonEncode(requestBody)}");

                    // 요청 바디 AlertDialog로 먼저 보여주기
                    await _showRequestBodyDialog(requestBody, token);
                  },
                  icon: Padding(
                    padding: const EdgeInsets.only(left: 10), // 왼쪽 10px 여백
                    child: Image.asset(
                      'assets/icons/logo_w.png',
                      width: 20, // 20px x 20px 크기
                      height: 20,
                    ),
                  ),
                  label: const Text(
                    "제출하기",
                    style: TextStyle(
                      fontSize: 14, // 기본 폰트 크기
                      fontWeight: FontWeight.bold, // Bold
                      color: Colors.white, // 흰색 텍스트
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF262627), // 배경색 #262627
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4), // 테두리 반경 4px
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
