import 'package:flutter/material.dart';

class ContentCard extends StatelessWidget {
  final Map<String, String> item;

  const ContentCard({super.key, required this.item});

  // 상세 정보를 보여주는 다이얼로그
  void _showContentDetails(BuildContext context, Map<String, String> item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // 다이얼로그 타이틀은 콘텐츠 제목
          title: Text(
            item['title'] ?? "상세 정보",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 이미지가 있다면 상단에 표시
                if (item['image'] != null && item['image']!.isNotEmpty)
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(item['image']!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.image,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                // 설명
                Text(
                  item['description'] ?? "설명 정보 없음",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                // 장소 및 주소
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.place, size: 18, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "${item['location']!.isNotEmpty ? item['location'] : "장소 정보 없음"}",
                        style:
                            const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // 기간 정보
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 18, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item['period'] != null && item['period']!.isNotEmpty
                            ? item['period']!
                            : "기간 정보 없음",
                        style:
                            const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // 개장 시간 (있는 경우)
                if (item['opening_time'] != null &&
                    item['opening_time']!.isNotEmpty)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.access_time,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item['opening_time']!,
                          style:
                              const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("닫기"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // API에서 불러온 이미지 URL이 존재하면 사용, 없으면 기본 이미지(또는 아이콘)를 표시
    final String? imageUrl = item['image'];
    final bool hasImage = imageUrl != null && imageUrl.isNotEmpty;

    return GestureDetector(
      onTap: () => _showContentDetails(context, item),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          mainAxisSize: MainAxisSize.min, // Column 크기 제한
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: hasImage
                    ? DecorationImage(
                        image: NetworkImage(imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: hasImage ? null : Colors.grey[300],
              ),
              child: !hasImage
                  ? const Center(
                      child: Icon(
                        Icons.image,
                        color: Colors.white,
                        size: 40,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 4),
            // 타이틀
            SizedBox(
              width: 100,
              child: Text(
                item['title']!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF262627),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: true,
              ),
            ),
            // 위치 정보
            SizedBox(
              width: 100,
              child: Text(
                item['location']!.isNotEmpty ? item['location']! : "위치 정보 없음",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
