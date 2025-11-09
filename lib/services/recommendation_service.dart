import 'dart:convert';

import 'package:gukminexdiary/config/api_config.dart';
import 'package:gukminexdiary/model/exercise_model.dart';
import 'package:gukminexdiary/model/recommendation_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RecommendationService {
  final String _endpoint = ApiConfig.recommendationEndpoint;

  Future<RecommendationResponse> fetchRecommendations({int? count}) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('인증 정보가 없습니다. 다시 로그인해 주세요.');
    }

    final uri = count != null
        ? Uri.parse('$_endpoint?count=$count')
        : Uri.parse(_endpoint);

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      if (response.body.trim().isEmpty) {
        return RecommendationResponse(recommendations: []);
      }

      final decoded = jsonDecode(response.body);
      return RecommendationResponse.fromJson(decoded);
    } else if (response.statusCode == 401) {
      throw Exception('인증에 실패했습니다. 다시 로그인해주세요.');
    } else if (response.statusCode == 404) {
      throw Exception('사용자 정보를 찾을 수 없습니다.');
    } else {
      throw Exception('운동 추천을 가져오는 중 오류가 발생했습니다. (${response.statusCode})');
    }
  }

  Future<List<ExerciseModelResponse>> fetchRecommendationList({int? count}) async {
    final response = await fetchRecommendations(count: count);
    return response.recommendations;
  }
}

