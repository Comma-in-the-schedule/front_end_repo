# 📱 Flutter 프로젝트 폴더 구조 & UI 디자인 가이드

Flutter 프로젝트를 설계할 때 **유지보수성, 확장성, 모듈화**를 고려하여 구조화하였습니다.  
또한, UI 요소에 대한 **일관된 디자인 시스템**을 구축하여 협업과 유지보수를 효율적으로 만듭니다.

---

## 📁 폴더 구조 전략

### 1. `features/` – 기능 단위 모듈화

**목적:** 앱의 각 기능(로그인, 메인 등)을 독립적으로 관리  
**장점:**
- 기능별 코드 분리 → 유지보수 및 확장 용이
- 새로운 기능 추가 시 기존 코드 영향 최소화

---

### 2. `widgets/` – 공통 UI 컴포넌트 관리

**목적:** 재사용 가능한 UI 요소를 중앙에서 관리  
**장점:**
- 코드 중복 최소화
- UI 일관성 유지
- 유지보수 시 전체 반영 가능

---

### 3. `core/` – 전역 설정 관리

**목적:** 앱 전반에서 사용하는 설정 및 유틸리티 함수 관리  
**장점:**
- 설정 변경 시 한 곳에서 관리 가능
- 중복 코드 방지 및 일관된 환경 유지

---

### 4. `routes/` – 라우팅 중앙 관리

**목적:** 앱 내 모든 페이지 이동 경로를 한 곳에서 정의  
**장점:**
- 네비게이션 구조 명확화
- 유지보수 및 확장 용이

---

## 🎨 UI 디자인 가이드

### ✅ 인풋 박스 스타일

| 속성              | 값 |
|-------------------|----|
| 너비              | 전체 너비 (`Expanded`) |
| 높이              | 자동 조정 |
| 배경 색상         | `#F2F4F5` (연한 회색) |
| 테두리 (기본)     | `1px solid #BDBDBD` |
| 테두리 (포커스 시) | `1px solid #262627` |
| 패딩              | 세로 `5px`, 가로 `15px` |
| 글자 스타일        | 크기 `14px` → `12px` 예정, 색상 `#BDBDBD(플레이스홀더)`, `Black(입력값)` |

```dart
TextField(
  controller: _nicknameController,
  decoration: InputDecoration(
    filled: true,
    fillColor: Color(0xFFF2F4F5),
    hintText: "쉼표에서 사용할 이름 또는 닉네임을 입력해주세요.",
    hintStyle: TextStyle(
      fontSize: 14,
      color: Colors.grey,
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFBDBDBD), width: 1),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF262627), width: 1),
    ),
  ),
)
```
### ✅ 버튼 스타일

| 속성           | 값 |
|----------------|----|
| **너비**        | 100% (부모 컨테이너 전체) |
| **높이**        | `50px` |
| **배경 색상**    | `#262627` (어두운 회색) |
| **글자 색상**    | `White` (흰색) |
| **글자 크기**    | `14px` (기본값) |
| **글자 굵기**    | Bold |
| **모서리 둥글기** | `4px` |
| **아이콘 위치**  | 텍스트 왼쪽 (여백 `10px`), 크기 `20px x 20px` |

```dart
SizedBox(
  width: double.infinity,
  height: 50,
  child: ElevatedButton.icon(
    onPressed: () {
      // TODO: 제출 기능 구현
    },
    icon: Padding(
      padding: EdgeInsets.only(left: 10),
      child: Image.asset(
        'assets/icons/logo_w.png',
        width: 20,
        height: 20,
      ),
    ),
    label: Text("제출하기"),
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF262627),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  ),
)
```

