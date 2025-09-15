class UserModelResponse {
  final int userId;
  final String loginId;
  final String nickName;
  final String passwordHash;
  final String email;
  final DateTime createdAt;

  UserModelResponse(
    {
      required this.userId, 
      required this.loginId, 
      required this.nickName, 
      required this.passwordHash, 
      required this.email, 
      required this.createdAt
    }
  );

  factory UserModelResponse.fromJson(Map<String, dynamic> json) {
    return UserModelResponse(
      userId: json['userId'],
      loginId: json['loginId'],
      nickName: json['nickName'],
      passwordHash: json['passwordHash'],
      email: json['email'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
