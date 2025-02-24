import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:comma_in_the_schedule/features/auth/data/auth_api.dart';
import 'content_card.dart';

class ContentList extends StatefulWidget {
  final String selectedCategory;
  const ContentList({super.key, required this.selectedCategory});

  @override
  _ContentListState createState() => _ContentListState();
}

class _ContentListState extends State<ContentList> {
  late Future<List<Map<String, String>>> _contentFuture;
  final AuthApi _authApi = AuthApi();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _contentFuture = _fetchRecommendation();
  }

  Future<List<Map<String, String>>> _fetchRecommendation() async {
    final token = await _storage.read(key: 'token');
    final email = await _storage.read(key: 'userEmail');
    if (token == null || email == null) {
      throw Exception("로그인 토큰 또는 이메일 정보가 없습니다.");
    }
    final response =
        await _authApi.fetchRecommendation(token: token, email: email);
    if (response['isSuccess'] == true) {
      final List<dynamic> rawData = response['result'];

      List<Map<String, String>> contentList = [];
      // API 응답은 카테고리별 리스트로 구성됨
      for (var categoryList in rawData) {
        for (var item in categoryList) {
          contentList.add({
            "category": _mapCategory(item['category']),
            "title": item['title'] ?? "",
            "description": item['description'] ?? "",
            "location": item['address'] ?? "",
            "image": item['image'] ?? "",
          });
        }
      }
      return contentList;
    } else {
      throw Exception("추천 콘텐츠를 불러오지 못했습니다: ${response['message']}");
    }
  }

  /// 카테고리 번호를 문자열로 변환 (예: 1 → "팝업스토어", 2 → "전시회")
  String _mapCategory(dynamic categoryId) {
    switch (categoryId) {
      case 1:
        return "팝업스토어";
      case 2:
        return "전시회";
      default:
        return "기타";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, String>>>(
      future: _contentFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('오류: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("추천 콘텐츠가 없습니다."));
        }

        final content = snapshot.data!;
        // 카테고리별로 데이터 그룹화
        Map<String, List<Map<String, String>>> groupedContent = {};
        for (var item in content) {
          groupedContent.putIfAbsent(item["category"]!, () => []).add(item);
        }

        // 선택된 카테고리가 "전체"가 아니라면 해당 그룹만 필터링
        Map<String, List<Map<String, String>>> displayContent;
        if (widget.selectedCategory == "전체") {
          displayContent = groupedContent;
        } else {
          if (groupedContent.containsKey(widget.selectedCategory)) {
            displayContent = {
              widget.selectedCategory: groupedContent[widget.selectedCategory]!
            };
          } else {
            displayContent = {};
          }
        }

        if (displayContent.isEmpty) {
          return const Center(child: Text("선택한 카테고리에 해당하는 콘텐츠가 없습니다."));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: displayContent.keys.map((category) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 카테고리 제목 및 밑줄
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _getCategoryIcon(category),
                            const SizedBox(width: 6),
                            Text(
                              category,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF262627),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 2,
                          width: 40,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                  // 가로 스크롤 콘텐츠 리스트
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: displayContent[category]!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 8.0),
                          child: ContentCard(
                              item: displayContent[category]![index]),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // 카테고리별 아이콘 지정
  Widget _getCategoryIcon(String category) {
    switch (category) {
      case "팝업스토어":
        return const Text("🏬", style: TextStyle(fontSize: 18));
      case "전시회":
        return const Text("🖼", style: TextStyle(fontSize: 18));
      default:
        return const Icon(Icons.category, color: Color(0xFF262627), size: 18);
    }
  }
}
