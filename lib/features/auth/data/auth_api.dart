import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthApi {
  static const String _baseUrl = 'http://13.209.119.248:8080';

  /// 공통 API 요청 함수
  Future<Map<String, dynamic>> _makeRequest({
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
    String? token,
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
        final decodedBody = utf8.decode(response.bodyBytes);
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

  /// 설문조사 제출 API
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

  /// 설문조사 결과 확인 API (GET 방식, 이메일은 쿼리 파라미터로 전달)
  Future<Map<String, dynamic>> checkSurvey({
    required String token,
    required String email,
  }) {
    final endpoint = '/membership/auth/survey?email=$email';

    return _makeRequest(
      endpoint: endpoint,
      method: 'GET',
      token: token,
    );
  }

  /// 추천 콘텐츠 API 호출 (POST)
  Future<Map<String, dynamic>> fetchRecommendation({
    required String token,
    required String email,
  }) {
    return _makeRequest(
      endpoint: '/activity/recommendation',
      method: 'POST',
      token: token,
      body: {'email': email},
    );
  }
}
