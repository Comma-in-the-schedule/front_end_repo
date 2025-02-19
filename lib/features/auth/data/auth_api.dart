import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthApi {
  static const String _baseUrl = 'http://13.209.119.248:8080';

  /// 공통 API 요청 함수
  Future<Map<String, dynamic>> _makeRequest({
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
    String? token, // Authorization 토큰 추가
  }) async {
    final headers = {'Content-Type': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    final uri = Uri.parse('$_baseUrl$endpoint');

    try {
      late http.Response response;

      if (method == 'POST') {
        response =
            await http.post(uri, headers: headers, body: jsonEncode(body));
      } else if (method == 'GET') {
        response = await http.get(uri, headers: headers);
      } else {
        throw Exception("지원하지 않는 HTTP 메서드입니다.");
      }

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes); // UTF-8로 변환
        return jsonDecode(decodedBody);
      } else {
        return {
          'isSuccess': false,
          'message': '서버 오류 발생: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'isSuccess': false, 'message': '네트워크 오류가 발생했습니다: $e'};
    }
  }

  /// 회원가입 API
  Future<Map<String, dynamic>> signup(String email, String password) {
    return _makeRequest(
      endpoint: '/membership/auth/signup',
      method: 'POST',
      body: {'email': email, 'password': password},
    );
  }

  /// 로그인 API
  Future<Map<String, dynamic>> login(String email, String password) {
    return _makeRequest(
      endpoint: '/membership/auth/login',
      method: 'POST',
      body: {'email': email, 'password': password},
    );
  }

  /// 이메일 인증 요청 API
  Future<Map<String, dynamic>> sendEmailVerification(String email) {
    return _makeRequest(
      endpoint: '/email/send',
      method: 'POST',
      body: {'email': email},
    );
  }

  /// 이메일 인증 확인 API
  Future<Map<String, dynamic>> verifyEmailCode(String email) {
    return _makeRequest(
      endpoint: '/email/check',
      method: 'POST',
      body: {'email': email},
    );
  }

  /// 설문조사 API 호출 메서드
  /// [token] : 로그인 시 발급받은 토큰에서 추출한 값 사용 (요청 헤더의 Authorization: Bearer {token})
  /// [email] : 토큰에 저장된 이메일
  /// [nickname] : 사용자가 입력한 닉네임
  /// [location] : 선택한 지역 (예: "서울특별시 성동구")
  /// [category] : 선택한 관심 카테고리의 id 리스트 (예: [1, 2])
  Future<Map<String, dynamic>> submitSurvey({
    required String token,
    required String email,
    required String nickname,
    required String location,
    required List<int> category,
  }) {
    return _makeRequest(
      endpoint: '/membership/auth/survey',
      method: 'POST',
      token: token,
      body: {
        'email': email,
        'nickname': nickname,
        'location': location,
        'category': category,
      },
    );
  }
}
