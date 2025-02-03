import 'package:flutter/material.dart';

class ContentCard extends StatelessWidget {
  final Map<String, String> item;

  const ContentCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
        mainAxisSize: MainAxisSize.min, // 🔹 Column 크기 제한
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: item.containsKey('image')
                  ? DecorationImage(
                      image: AssetImage(item['image']!), // 이미지 불러오기
                      fit: BoxFit.cover,
                    )
                  : null,
              color: item.containsKey('image')
                  ? null
                  : Colors.grey[300], // 이미지 없을 때 회색 박스
            ),
            child: item.containsKey('image')
                ? null
                : const Center(
                    child: Icon(Icons.image,
                        color: Colors.white, size: 40)), // 이미지 없을 때 아이콘
          ),
          const SizedBox(height: 4),

          // 타이틀
          SizedBox(
            width: 100, // 너비 제한
            child: Text(
              item['title']!,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF262627)),
              overflow: TextOverflow.ellipsis, // 너무 길면 "..."
              maxLines: 1, // 한 줄로 표시
              softWrap: true, // 필요 시 줄바꿈
            ),
          ),

          // 위치 정보
          SizedBox(
            width: 100, // 너비 제한
            child: Text(
              item['location']!,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              overflow: TextOverflow.ellipsis, // 너무 길면 "..."
              maxLines: 1, // 한 줄로 표시
              softWrap: true, // 필요 시 줄바꿈
            ),
          ),
        ],
      ),
    );
  }
}
