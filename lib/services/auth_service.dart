import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gukminexdiary/model/auth_model.dart';
import 'package:gukminexdiary/config/api_config.dart';

class AuthService { 
  // static const String baseUrl = ApiConfig.baseUrl;
  static const String AuthUrl = ApiConfig.authEndpoint;

  // 회원가입
  Future<User> signup(SignupRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$AuthUrl/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return User.fromJson(data);
      } else if (response.statusCode == 409) {
        final Map<String, dynamic> errorData = json.decode(response.body);
        final AuthError error = AuthError.fromJson(errorData);
        throw Exception(error.message);
      } else {
        throw Exception('회원가입 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('회원가입 중 오류 발생: $e');
    }
  }

  // 로그인
  Future<TokenResponse> login(LoginRequest request) async {
    try {
      print(request.toJson());
      print('$AuthUrl/login');
      final response = await http.post(
        Uri.parse('$AuthUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return TokenResponse.fromJson(data);
      } else if (response.statusCode == 401) {
        final Map<String, dynamic> errorData = json.decode(response.body);
        final AuthError error = AuthError.fromJson(errorData);
        throw Exception(error.message);
      } else {
        throw Exception('로그인 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('로그인 중 오류 발생: $e');
    }
  }

  // 토큰 재발급
  Future<TokenResponse> refreshToken(RefreshTokenRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$AuthUrl/refresh'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return TokenResponse.fromJson(data);
      } else if (response.statusCode == 401) {
        final Map<String, dynamic> errorData = json.decode(response.body);
        final AuthError error = AuthError.fromJson(errorData);
        throw Exception(error.message);
      } else {
        throw Exception('토큰 재발급 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('토큰 재발급 중 오류 발생: $e');
    }
  }

  // ID 중복 확인
  Future<bool> checkLoginId(String loginId) async {
    try {
      final response = await http.get(
        Uri.parse('$AuthUrl/check-loginId?loginId=$loginId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return true; // 사용 가능
      } else if (response.statusCode == 409) {
        return false; // 중복됨
      } else {
        throw Exception('ID 중복 확인 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('ID 중복 확인 중 오류 발생: $e');
    }
  }

  // 이메일 중복 확인
  Future<bool> checkEmail(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$AuthUrl/check-email?email=$email'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return true; // 사용 가능
      } else if (response.statusCode == 409) {
        return false; // 중복됨
      } else {
        throw Exception('이메일 중복 확인 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('이메일 중복 확인 중 오류 발생: $e');
    }
  }
}
