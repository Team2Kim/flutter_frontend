import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  // 인증 상태
  bool _isAuthenticated = false;
  String? _userId;
  String? _userEmail;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;
  String? get userEmail => _userEmail;

  // 로그인
  Future<void> login(String email, String password) async {
    // TODO: 로그인 로직 구현
    _isAuthenticated = true;
    _userId = 'temp_user_id';
    _userEmail = email;
    notifyListeners();
  }

  // 로그아웃
  Future<void> logout() async {
    // TODO: 로그아웃 로직 구현
    _isAuthenticated = false;
    _userId = null;
    _userEmail = null;
    notifyListeners();
  }

  // 회원가입
  Future<void> signUp(String email, String password) async {
    // TODO: 회원가입 로직 구현
    _isAuthenticated = true;
    _userId = 'temp_user_id';
    _userEmail = email;
    notifyListeners();
  }

  // 인증 상태 확인
  Future<void> checkAuthStatus() async {
    // TODO: 인증 상태 확인 로직 구현
  }
}
