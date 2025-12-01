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
  
  // 중복 확인 상태
  bool _isCheckingLoginId = false;
  bool _isCheckingEmail = false;
  bool? _loginIdAvailable;
  bool? _emailAvailable;
  String? _loginIdCheckMessage;
  String? _emailCheckMessage;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  User? get user => _user;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  String? get errorMessage => _errorMessage;
  
  // 중복 확인 상태 Getters
  bool get isCheckingLoginId => _isCheckingLoginId;
  bool get isCheckingEmail => _isCheckingEmail;
  bool? get loginIdAvailable => _loginIdAvailable;
  bool? get emailAvailable => _emailAvailable;
  String? get loginIdCheckMessage => _loginIdCheckMessage;
  String? get emailCheckMessage => _emailCheckMessage;

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
    await prefs.remove('loginId');
    await prefs.remove('password');
    await prefs.remove('keepLoggedIn');
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
      
      // 로그인 성공 시 사용자 정보도 저장
      _isAuthenticated = true;
      print('로그인 성공 - 토큰 저장 완료');
      
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
        // 토큰이 있으면 서버에 유효성 검사
        try {
          // 토큰 재발급을 시도해서 유효성 확인
          final isValid = await refreshTokens();
          if (isValid) {
            _isAuthenticated = true;
            print('토큰 유효성 확인 성공 - 로그인 상태 유지');
          } else {
            _isAuthenticated = false;
            print('토큰 유효성 확인 실패 - 로그아웃 처리');
          }
        } catch (e) {
          print('토큰 유효성 검사 중 오류: $e');
          _isAuthenticated = false;
          await _clearTokens();
        }
      } else {
        _isAuthenticated = false;
        print('저장된 토큰 없음 - 비로그인 상태');
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

  // ID 중복 확인
  Future<void> checkLoginIdDuplicate(String loginId) async {
    if (loginId.isEmpty || loginId.length < 3) {
      _loginIdAvailable = null;
      _loginIdCheckMessage = null;
      notifyListeners();
      return;
    }

    try {
      _isCheckingLoginId = true;
      _loginIdCheckMessage = null;
      notifyListeners();

      final isAvailable = await _authService.checkLoginId(loginId);
      _loginIdAvailable = isAvailable;
      _loginIdCheckMessage = isAvailable ? '사용 가능한 아이디입니다.' : '이미 사용 중인 아이디입니다.';
      
      _isCheckingLoginId = false;
      notifyListeners();
    } catch (e) {
      _loginIdAvailable = null;
      _loginIdCheckMessage = 'ID 중복 확인 중 오류가 발생했습니다.';
      _isCheckingLoginId = false;
      notifyListeners();
    }
  }

  // 이메일 중복 확인
  Future<void> checkEmailDuplicate(String email) async {
    if (email.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _emailAvailable = null;
      _emailCheckMessage = null;
      notifyListeners();
      return;
    }

    try {
      _isCheckingEmail = true;
      _emailCheckMessage = null;
      notifyListeners();

      final isAvailable = await _authService.checkEmail(email);
      _emailAvailable = isAvailable;
      _emailCheckMessage = isAvailable ? '사용 가능한 이메일입니다.' : '이미 사용 중인 이메일입니다.';
      
      _isCheckingEmail = false;
      notifyListeners();
    } catch (e) {
      _emailAvailable = null;
      _emailCheckMessage = '이메일 중복 확인 중 오류가 발생했습니다.';
      _isCheckingEmail = false;
      notifyListeners();
    }
  }

  // 중복 확인 상태 초기화
  void clearDuplicateCheckStatus() {
    _loginIdAvailable = null;
    _emailAvailable = null;
    _loginIdCheckMessage = null;
    _emailCheckMessage = null;
    _isCheckingLoginId = false;
    _isCheckingEmail = false;
    notifyListeners();
  }
}
