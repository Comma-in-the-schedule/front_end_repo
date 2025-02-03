import 'package:flutter/material.dart';

class ContentList extends StatelessWidget {
  final List<Map<String, String>> content; // 필터링된 리스트 데이터

  const ContentList({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    // 카테고리별로 데이터 그룹화
    Map<String, List<Map<String, String>>> groupedContent = {};
    for (var item in content) {
      groupedContent.putIfAbsent(item["category"]!, () => []).add(item);
    }

    return SingleChildScrollView(
      // 🔹 스크롤 가능하게 변경
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: groupedContent.keys.map((category) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 카테고리 제목 + 밑줄
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _getCategoryIcon(category), // 카테고리별 아이콘
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
                      color: Colors.blue, // 밑줄 추가
                    ),
                  ],
                ),
              ),
              // 가로 스크롤 리스트
              SizedBox(
                height: 140, // 🔹 아이템 높이 설정 (조금 증가)
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // 가로 스크롤
                  itemCount: groupedContent[category]!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // 🔹 불필요한 여백 제거
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 네모난 이미지 컨테이너
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[300], // 이미지 없는 경우 회색 박스로 대체
                              borderRadius:
                                  BorderRadius.circular(12), // 모서리 둥글게
                            ),
                            child: const Center(
                              child: Icon(Icons.image,
                                  color: Colors.white, size: 40),
                            ),
                          ),
                          const SizedBox(height: 4),

                          // 콘텐츠 제목
                          SizedBox(
                            width: 100, // 🔹 고정된 너비 설정
                            child: Text(
                              groupedContent[category]![index]["title"]!,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF262627),
                              ),
                              overflow: TextOverflow.ellipsis, // 🔹 너무 길면 "..."
                              maxLines: 1, // 🔹 한 줄로 제한
                              softWrap: true, // 🔹 줄바꿈 가능
                            ),
                          ),

                          // 위치 정보 (없는 경우 "위치 정보 없음" 표시)
                          SizedBox(
                            width: 100, // 🔹 고정된 너비 설정
                            height: 18, // 🔹 높이 증가 (오버플로우 방지)
                            child: Text(
                              groupedContent[category]![index]["location"] ??
                                  "위치 정보 없음", // 🔹 기본값 설정
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                              overflow: TextOverflow.ellipsis, // 🔹 너무 길면 "..."
                              maxLines: 1, // 🔹 한 줄로 제한
                              softWrap: true, // 🔹 줄바꿈 가능
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16), // 카테고리 간 여백 추가
            ],
          );
        }).toList(),
      ),
    );
  }

  // 카테고리별 아이콘 지정
  Widget _getCategoryIcon(String category) {
    switch (category) {
      case "전시회/팝업":
        return const Text("🏛", style: TextStyle(fontSize: 18));
      case "영화":
        return const Text("🎬", style: TextStyle(fontSize: 18));
      case "헬스":
        return const Text("💪", style: TextStyle(fontSize: 18));
      case "물류":
        return const Text("📦", style: TextStyle(fontSize: 18));
      default:
        return const Icon(Icons.category, color: Color(0xFF262627), size: 18);
    }
  }
}
