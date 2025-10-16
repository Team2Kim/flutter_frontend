import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiTestService {
  final String baseUrl = 'https://port-0-exerciesrecord-ai-m09uz3m21c03af28.sel4.cloudtype.app';

  // 특정 날짜 일지 조회
  Future<Map<String, dynamic>> getJournalsByDate({
    required String date,
    required String accessToken,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/api/journals/by-date?date=$date');
      
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      return {
        'statusCode': response.statusCode,
        'headers': response.headers,
        'body': response.body,
        'success': response.statusCode >= 200 && response.statusCode < 300,
      };
    } catch (e) {
      return {
        'statusCode': 0,
        'headers': {},
        'body': 'Error: $e',
        'success': false,
      };
    }
  }

  // AI 운동 추천 (기본)
  Future<Map<String, dynamic>> getBasicRecommendation({
    required String userId,
    required int weeklyFrequency,
    required String splitType,
    required String mainGoal,
    required String experienceLevel,
    required int sessionDuration,
    String? preferredEquipment,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/api/recommendation/basic');
      
      final body = {
        'user_id': userId,
        'weekly_frequency': weeklyFrequency,
        'split_type': splitType,
        'main_goal': mainGoal,
        'experience_level': experienceLevel,
        'session_duration': sessionDuration,
        if (preferredEquipment != null) 'preferred_equipment': preferredEquipment,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      return {
        'statusCode': response.statusCode,
        'headers': response.headers,
        'body': response.body,
        'success': response.statusCode >= 200 && response.statusCode < 300,
      };
    } catch (e) {
      return {
        'statusCode': 0,
        'headers': {},
        'body': 'Error: $e',
        'success': false,
      };
    }
  }

  // 운동 검색
  Future<Map<String, dynamic>> searchExercises({
    String? bodyPart,
    String? category,
    String? difficulty,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (bodyPart != null) queryParams['body_part'] = bodyPart;
      if (category != null) queryParams['category'] = category;
      if (difficulty != null) queryParams['difficulty'] = difficulty;

      final url = Uri.parse('$baseUrl/api/exercises').replace(queryParameters: queryParams);
      
      final response = await http.get(url);

      return {
        'statusCode': response.statusCode,
        'headers': response.headers,
        'body': response.body,
        'success': response.statusCode >= 200 && response.statusCode < 300,
      };
    } catch (e) {
      return {
        'statusCode': 0,
        'headers': {},
        'body': 'Error: $e',
        'success': false,
      };
    }
  }
}
