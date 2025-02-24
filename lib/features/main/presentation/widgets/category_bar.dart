import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:comma_in_the_schedule/features/auth/data/auth_api.dart';

class CategoryBar extends StatefulWidget {
  final Function(String) onCategorySelected; // 선택된 카테고리를 상위 위젯으로 전달하는 콜백

  const CategoryBar({super.key, required this.onCategorySelected});

  @override
  // ignore: library_private_types_in_public_api
  _CategoryBarState createState() => _CategoryBarState();
}

class _CategoryBarState extends State<CategoryBar> {
  // API 응답에 따른 카테고리 ID -> 이름 매핑
  final Map<int, String> categoryMapping = {
    1: "팝업스토어",
    2: "전시회",
    // 필요시 다른 매핑 추가 가능
  };

  // API로 받아온 설문조사 데이터
  String nickName = "사용자";
  List<String> userCategories = [];

  // 현재 선택된 카테고리 (API 응답에 따른 리스트의 첫 요소로 기본 설정)
  String selectedCategory = "";

  // 설문조사 API 호출 Future
  Future<Map<String, dynamic>>? _surveyFuture;

  @override
  void initState() {
    super.initState();
    _surveyFuture = _fetchSurvey();
  }

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
      future: _surveyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('오류: ${snapshot.error}'));
        }
        if (snapshot.hasData) {
          final surveyData = snapshot.data!;
          // 헤더에 표시할 닉네임 업데이트
          nickName = surveyData['nickName'] ?? "사용자";
          // API 응답 category는 숫자 리스트 (예: [1,2])
          final List<dynamic> categoryIds = surveyData['category'] ?? [];
          // categoryMapping을 이용하여 해당하는 이름만 추출
          userCategories = categoryIds
              .map((id) => categoryMapping[id] ?? "")
              .where((name) => name.isNotEmpty)
              .toList();
          // "전체"를 항상 맨 앞에 추가 (이미 존재하지 않을 경우)
          if (!userCategories.contains("전체")) {
            userCategories.insert(0, "전체");
          }
          // 기본 선택 카테고리 설정
          if (selectedCategory.isEmpty) {
            selectedCategory = userCategories.first;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더: "[nickName] 님 추천 쉼표"
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, top: 12.0, bottom: 4.0),
                child: Text(
                  "$nickName 님 추천 쉼표",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF262627),
                  ),
                ),
              ),
              // 소제목: "관심 카테고리"
              const Padding(
                padding: EdgeInsets.only(left: 16.0, bottom: 4.0),
                child: Text(
                  "관심 카테고리",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF262627),
                  ),
                ),
              ),
              // 사용자 카테고리만 표시하는 Chip 리스트
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: userCategories
                        .map((category) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 3.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategory = category;
                                  });
                                  widget.onCategorySelected(category);
                                },
                                child: Chip(
                                  label: Text(
                                    category,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: selectedCategory == category
                                          ? Colors.white
                                          : const Color(0xFF262627),
                                    ),
                                  ),
                                  backgroundColor: selectedCategory == category
                                      ? const Color(0xFF262627)
                                      : Colors.grey[200],
                                  shape: const StadiumBorder(),
                                  visualDensity: const VisualDensity(
                                      horizontal: -2, vertical: -2),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
