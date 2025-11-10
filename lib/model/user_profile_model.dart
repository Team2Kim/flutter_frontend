class UserProfile {
  final int? userId;
  final String? loginId;
  final String? nickname;
  final String? email;
  final DateTime? createdAt;
  final String? targetGroup;
  final String? fitnessLevelName;
  final String? fitnessFactorName;

  UserProfile({
    this.userId,
    this.loginId,
    this.nickname,
    this.email,
    this.createdAt,
    this.targetGroup,
    this.fitnessLevelName,
    this.fitnessFactorName,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'] as int?,
      loginId: json['loginId'] as String?,
      nickname: json['nickname'] as String? ?? json['nickName'] as String?,
      email: json['email'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      targetGroup: json['targetGroup'] as String?,
      fitnessLevelName: json['fitnessLevelName'] as String?,
      fitnessFactorName: json['fitnessFactorName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'loginId': loginId,
      'nickname': nickname,
      'email': email,
      'createdAt': createdAt?.toIso8601String(),
      'targetGroup': targetGroup,
      'fitnessLevelName': fitnessLevelName,
      'fitnessFactorName': fitnessFactorName,
    };
  }
}

