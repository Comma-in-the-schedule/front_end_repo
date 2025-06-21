## **Comma In The Schedule — Flutter Frontend**

### **프로젝트 개요**

* **이름**: `comma_in_the_schedule`
* **설명**: 쉼표에서 사용할 Flutter 기반 일정 관리 앱의 프론트엔드
* **조직 정보**: (https://github.com/Comma-in-the-schedule)

---

### **개발 환경**

| 항목                          | 값                      |
| --------------------------- | ---------------------- |
| **Flutter SDK**             | `>=3.5.4`              |
| **Dart SDK**                | `>=3.5.4`              |
| **주요 의존성**                  |                        |
| ├─ `dio`                    | `^5.4.0` (HTTP 통신)     |
| ├─ `jwt_decoder`            | `^2.0.1` (JWT 파싱)      |
| ├─ `flutter_secure_storage` | `^4.2.1` (보안 저장소)      |
| ├─ `http`                   | `^1.3.0` (HTTP 요청)     |
| ├─ `shared_preferences`     | `^2.5.1` (로컬 저장소)      |
| ├─ `dart_jsonwebtoken`      | `^2.4.0` (JWT 생성/검증)   |
| ├─ `cupertino_icons`        | `^1.0.8` (iOS 스타일 아이콘) |
| **사용 폰트**                   | `Pretendard` (9종 굵기)   |
| **커스텀 에셋**                  | `/assets/icons/`       |

---

### **프로젝트 구조**

```plaintext
lib/
├── core/                # 테마, 유틸, 전역 설정
│   ├── themes/
│   │   └── app_theme.dart
│   └── utils/
│       └── storage_helper.dart
├── features/            # 기능별 모듈 (auth, main, splash, survey 등)
│   ├── auth/
│   ├── main/
│   ├── non_auth/
│   ├── splash/
│   └── survey/
├── routes/              # 라우팅 설정
│   └── app_routes.dart
├── widgets/             # 공통 재사용 UI 위젯
│   ├── base_screen.dart
│   └── logo_banner.dart
├── main.dart            # 앱 엔트리포인트
```

---

### **디자인 시스템**

**인풋 박스 스타일**

* 배경: `#F2F4F5`
* 테두리: 기본 `#BDBDBD` / 포커스 시 `#262627`
* 패딩: 세로 `5px`, 가로 `15px`
* 텍스트: 플레이스홀더 `#BDBDBD`, 입력값 `Black`
* 사이즈: 너비 `100%`, 높이 자동

**버튼 스타일**

* 배경: `#262627`
* 텍스트: `White`, Bold, 14px
* 모서리 둥글기: `4px`
* 아이콘: 텍스트 왼쪽, `20x20px`, 간격 `10px`

---

### **실행 방법**

```bash
# 의존성 설치
flutter pub get

# 앱 실행 (연결된 디바이스/에뮬레이터)
flutter run
```

---

### **추가 참고**

* `pubspec.yaml`에서 SDK 및 의존성 버전 확인 가능
* 실행 시 `flutter doctor -v` 로 로컬 개발 환경 확인 권장
* 커스텀 폰트는 `Pretendard`를 `/fonts/` 폴더에 포함

---
