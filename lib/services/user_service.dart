import 'dart:convert';

import 'package:gukminexdiary/config/api_config.dart';
import 'package:gukminexdiary/model/user_profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final String _profileEndpoint = ApiConfig.userProfileEndpoint;

  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    if (accessToken == null || accessToken.isEmpty) {
      return null;
    }
    return accessToken;
  }

  Future<UserProfile> fetchProfile() async {
    final accessToken = await _getAccessToken();
    if (accessToken == null) {
      throw Exception('인증 정보가 없습니다. 다시 로그인해 주세요.');
    }

    final response = await http.get(
      Uri.parse(_profileEndpoint),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return UserProfile.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('인증에 실패했습니다. 다시 로그인해 주세요.');
    } else if (response.statusCode == 404) {
      throw Exception('사용자 정보를 찾을 수 없습니다.');
    } else {
      throw Exception('프로필 정보를 가져오는 중 오류가 발생했습니다. (${response.statusCode})');
    }
  }

  Future<void> updateProfile({
    String? targetGroup,
    String? fitnessLevelName,
    String? fitnessFactorName,
  }) async {
    final accessToken = await _getAccessToken();
    if (accessToken == null) {
      throw Exception('인증 정보가 없습니다. 다시 로그인해 주세요.');
    }

    final payload = <String, dynamic>{};

    if (targetGroup != null) payload['targetGroup'] = targetGroup;
    if (fitnessLevelName != null) payload['fitnessLevelName'] = fitnessLevelName;
    if (fitnessFactorName != null) payload['fitnessFactorName'] = fitnessFactorName;

    final response = await http.put(
      Uri.parse(_profileEndpoint),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401) {
      throw Exception('인증에 실패했습니다. 다시 로그인해 주세요.');
    } else if (response.statusCode == 404) {
      throw Exception('사용자 정보를 찾을 수 없습니다.');
    } else {
      throw Exception('프로필 정보를 업데이트하는 중 오류가 발생했습니다. (${response.statusCode})');
    }
  }
}

