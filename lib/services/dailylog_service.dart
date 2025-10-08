import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gukminexdiary/config/api_config.dart';
import 'package:gukminexdiary/model/dailylog_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyLogService {
  final String _baseUrl = ApiConfig.journalsEndpoint;

  // 헤더에 토큰 추가하는 헬퍼 메서드
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    return {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
  }

  // 1. 특정 날짜의 일지 조회
  Future<DailyLogModelResponse?> getDailyLogByDate(String date) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/by-date?date=$date'),
        headers: headers,
      );
  
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        return DailyLogModelResponse.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        // 해당 날짜에 일지가 없음
        return null;
      } else if (response.statusCode == 401) {
        throw Exception('인증에 실패했습니다. 다시 로그인해주세요.');
      } else {
        throw Exception('일지를 가져오는 중 오류가 발생했습니다: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('네트워크 오류: ${e.toString()}');
    }
  }

  // 2. 새로운 일지 생성
  Future<DailyLogModelResponse> createDailyLog(CreateDailyLogRequest request) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: headers,
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        return DailyLogModelResponse.fromJson(jsonData);
      } else if (response.statusCode == 409) {
        throw Exception('해당 날짜에 이미 일지가 존재합니다.');
      } else if (response.statusCode == 401) {
        throw Exception('인증에 실패했습니다. 다시 로그인해주세요.');
      } else {
        throw Exception('일지 생성 중 오류가 발생했습니다: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('네트워크 오류: ${e.toString()}');
    }
  }

  // 3. 일지 수정 (메모 수정)
  Future<void> updateDailyLog(int logId, UpdateDailyLogRequest request) async {
    try {
      final headers = await _getHeaders();
      final response = await http.patch(
        Uri.parse('$_baseUrl/$logId'),
        headers: headers,
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        // 성공
        return;
      } else if (response.statusCode == 401) {
        throw Exception('인증에 실패했습니다. 다시 로그인해주세요.');
      } else if (response.statusCode == 404) {
        throw Exception('해당 일지를 찾을 수 없습니다.');
      } else {
        throw Exception('일지 수정 중 오류가 발생했습니다: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('네트워크 오류: ${e.toString()}');
    }
  }

  // 4. 일지 삭제
  Future<void> deleteDailyLog(int logId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$_baseUrl/$logId'),
        headers: headers,
      );

      if (response.statusCode == 204) {
        // 성공
        return;
      } else if (response.statusCode == 401) {
        throw Exception('인증에 실패했습니다. 다시 로그인해주세요.');
      } else if (response.statusCode == 404) {
        throw Exception('해당 일지를 찾을 수 없습니다.');
      } else {
        throw Exception('일지 삭제 중 오류가 발생했습니다: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('네트워크 오류: ${e.toString()}');
    }
  }

  // 5. 일지에 운동 기록 추가
  Future<DailyLogModelResponse> addExerciseToLog(
    int logId,
    AddExerciseToLogRequest request,
  ) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl/$logId/exercises'),
        headers: headers,
        body: jsonEncode(request.toJson()),
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        return DailyLogModelResponse.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('인증에 실패했습니다. 다시 로그인해주세요.');
      } else if (response.statusCode == 404) {
        throw Exception('일지 또는 운동을 찾을 수 없습니다.');
      } else {
        throw Exception('운동 기록 추가 중 오류가 발생했습니다: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('네트워크 오류: ${e.toString()}');
    }
  }

  // 6. 운동 기록 수정
  Future<void> updateLogExercise(
    int logExerciseId,
    UpdateLogExerciseRequest request,
  ) async {
    try {
      final headers = await _getHeaders();
      final response = await http.patch(
        Uri.parse('$_baseUrl/exercises/$logExerciseId'),
        headers: headers,
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        // 성공
        return;
      } else if (response.statusCode == 401) {
        throw Exception('인증에 실패했습니다. 다시 로그인해주세요.');
      } else if (response.statusCode == 404) {
        throw Exception('해당 운동 기록을 찾을 수 없습니다.');
      } else {
        throw Exception('운동 기록 수정 중 오류가 발생했습니다: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('네트워크 오류: ${e.toString()}');
    }
  }

  // 7. 운동 기록 삭제
  Future<void> deleteLogExercise(int logExerciseId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$_baseUrl/exercises/$logExerciseId'),
        headers: headers,
      );

      if (response.statusCode == 204) {
        // 성공
        return;
      } else if (response.statusCode == 401) {
        throw Exception('인증에 실패했습니다. 다시 로그인해주세요.');
      } else if (response.statusCode == 404) {
        throw Exception('해당 운동 기록을 찾을 수 없습니다.');
      } else {
        throw Exception('운동 기록 삭제 중 오류가 발생했습니다: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('네트워크 오류: ${e.toString()}');
    }
  }
}

