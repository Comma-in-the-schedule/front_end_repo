import 'package:flutter/material.dart';

class CategoryBar extends StatefulWidget {
  final Function(String) onCategorySelected; // 선택된 카테고리를 상위 위젯으로 전달하는 콜백

  const CategoryBar({super.key, required this.onCategorySelected});

  @override
  // ignore: library_private_types_in_public_api
  _CategoryBarState createState() => _CategoryBarState();
}

class _CategoryBarState extends State<CategoryBar> {
  final List<String> categories = [
    "전체",
    "전시회/팝업",
    "영화",
    "헬스",
    "물류",
    "음식",
    "패션",
    "여행",
    "IT",
    "스포츠",
    "뮤직",
    "도서"
  ];
  String selectedCategory = "전체"; // 현재 선택된 카테고리

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 박준서님 추천 쉼표
        const Padding(
          padding: EdgeInsets.only(left: 16.0, top: 12.0, bottom: 4.0),
          child: Text(
            "박준서님 추천 쉼표",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF262627),
            ),
          ),
        ),
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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal, // 🔹 가로 스크롤 유지
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: categories
                  .map((category) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = category;
                            });
                            widget.onCategorySelected(
                                category); // 선택된 카테고리를 부모 위젯에 전달
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
}
