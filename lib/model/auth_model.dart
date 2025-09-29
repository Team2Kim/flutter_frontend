class User {
  final int userId;
  final String loginId;
  final String nickname;
  final String email;
  final String createdAt;

  User({
    required this.userId,
    required this.loginId,
    required this.nickname,
    required this.email,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      loginId: json['loginId'],
      nickname: json['nickname'],
      email: json['email'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'loginId': loginId,
      'nickname': nickname,
      'email': email,
      'createdAt': createdAt,
    };
  }
}

class LoginRequest {
  final String loginId;
  final String password;

  LoginRequest({
    required this.loginId,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'loginId': loginId,
      'password': password,
    };
  }
}

class SignupRequest {
  final String loginId;
  final String password;
  final String nickname;
  final String email;

  SignupRequest({
    required this.loginId,
    required this.password,
    required this.nickname,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'loginId': loginId,
      'password': password,
      'nickname': nickname,
      'email': email,
    };
  }
}

class TokenResponse {
  final String grantType;
  final String accessToken;
  final String refreshToken;

  TokenResponse({
    required this.grantType,
    required this.accessToken,
    required this.refreshToken,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      grantType: json['grantType'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'grantType': grantType,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}

class RefreshTokenRequest {
  final String accessToken;
  final String refreshToken;

  RefreshTokenRequest({
    required this.accessToken,
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}

class AuthError {
  final int status;
  final String message;

  AuthError({
    required this.status,
    required this.message,
  });

  factory AuthError.fromJson(Map<String, dynamic> json) {
    return AuthError(
      status: json['status'],
      message: json['message'],
    );
  }
}

