import 'package:flutter/material.dart';
import 'package:comma_in_the_schedule/widgets/logo_banner.dart'; // 로고 배너 import

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final TextEditingController _nicknameController = TextEditingController();

  // 🔹 선택 가능한 카테고리 리스트
  final List<String> categories = [
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

  List<String> selectedCategories = []; // 다중 선택 가능하도록 변경

  // 🔹 지역 선택 관련 변수
  final List<String> locations = ["서울", "경기"];
  final Map<String, List<String>> subLocations = {
    "서울": ["강남구", "서초구", "마포구", "송파구"],
    "경기": ["수원시", "성남시", "고양시", "용인시"]
  };

  String selectedLocation = "서울"; // 기본 지역 선택
  String? selectedSubLocation; // 기본 하위 지역 선택

  void _onCategorySelected(String category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category); // 선택 해제
      } else {
        selectedCategories.add(category); // 선택 추가
      }
    });
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
              const Text(
                "닉네임",
                style: TextStyle(
                  fontFamily: 'Pretendard-Bold',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  hintText: "쉼표에서 사용할 이름 또는 닉네임을 입력해주세요.",
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 5, horizontal: 15), // 높이 조정
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4), // 둥근 정도 축소
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6), // 둥근 정도 유지
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 주요 활동 위치
              const Text(
                "주요 활동 위치",
                style: TextStyle(
                  fontFamily: 'Pretendard-Bold',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),

              // 🔹 지역 선택 (가로 정렬)
              Row(
                children: [
                  // 상위 지역 (서울, 경기)
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedLocation,
                      items: locations.map((String location) {
                        return DropdownMenuItem<String>(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedLocation = value!;
                          selectedSubLocation = null; // 상위 지역 변경 시 하위 지역 초기화
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15), // 높이 조정
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // 상위 지역과 하위 지역 사이 여백

                  // 하위 지역 (구 선택) - 선택된 경우만 보이도록
                  Visibility(
                    visible: selectedLocation.isNotEmpty,
                    child: Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedSubLocation,
                        hint: const Text("구/시 선택"),
                        items: subLocations[selectedLocation]!
                            .map((String subLocation) {
                          return DropdownMenuItem<String>(
                            value: subLocation,
                            child: Text(subLocation),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedSubLocation = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15), // 높이 조정
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // 🔹 관심 카테고리 선택
              const Text(
                "관심 카테고리",
                style: TextStyle(
                  fontFamily: 'Pretendard-Bold',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
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

              // 제출 버튼 (로고 포함)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: 제출 기능 구현
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF262627),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft, // 버튼의 맨 왼쪽에 로고 배치
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 10), // 왼쪽에서 10px 띄우기
                          child: Image.asset(
                            'assets/icons/logo_w.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                      const Text(
                        "제출하기",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Pretendard-Bold',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
