import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gukminexdiary/services/auth_service.dart';
import 'package:gukminexdiary/model/auth_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  // 인증 상태
  bool _isAuthenticated = false;
  bool _isLoading = false;
  User? _user;
  String? _accessToken;
  String? _refreshToken;
  String? _errorMessage;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  User? get user => _user;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  String? get errorMessage => _errorMessage;

  // 에러 메시지 초기화
  void _clearError() {
    _errorMessage = null;
  }

  // 토큰 저장
  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  // 토큰 로드
  Future<void> _loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');
    _refreshToken = prefs.getString('refresh_token');
  }

  // 토큰 삭제
  Future<void> _clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    _accessToken = null;
    _refreshToken = null;
  }

  // 회원가입
  Future<bool> signup({
    required String loginId,
    required String password,
    required String nickname,
    required String email,
  }) async {
    try {
      _isLoading = true;
      _clearError();
      notifyListeners();

      final request = SignupRequest(
        loginId: loginId,
        password: password,
        nickname: nickname,
        email: email,
      );

      final user = await _authService.signup(request);
      _user = user;
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 로그인
  Future<bool> login({
    required String loginId,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _clearError();
      notifyListeners();

      final request = LoginRequest(
        loginId: loginId,
        password: password,
      );

      final tokenResponse = await _authService.login(request);
      await _saveTokens(tokenResponse.accessToken, tokenResponse.refreshToken);
      
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 토큰 재발급
  Future<bool> refreshTokens() async {
    try {
      if (_accessToken == null || _refreshToken == null) {
        return false;
      }

      final request = RefreshTokenRequest(
        accessToken: _accessToken!,
        refreshToken: _refreshToken!,
      );

      final tokenResponse = await _authService.refreshToken(request);
      await _saveTokens(tokenResponse.accessToken, tokenResponse.refreshToken);
      
      return true;
    } catch (e) {
      print('토큰 재발급 실패: $e');
      await logout();
      return false;
    }
  }

  // 로그아웃
  Future<void> logout() async {
    await _clearTokens();
    _isAuthenticated = false;
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  // 인증 상태 확인 (앱 시작 시)
  Future<void> checkAuthStatus() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _loadTokens();
      
      if (_accessToken != null && _refreshToken != null) {
        // 토큰이 있으면 유효성 검사 (선택사항)
        _isAuthenticated = true;
      } else {
        _isAuthenticated = false;
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('인증 상태 확인 실패: $e');
      _isAuthenticated = false;
      _isLoading = false;
      notifyListeners();
    }
  }
}
