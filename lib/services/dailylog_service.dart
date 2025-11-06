import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gukminexdiary/config/api_config.dart';
import 'package:gukminexdiary/model/dailylog_model.dart';
import 'package:gukminexdiary/model/workout_analysis_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyLogService {
  final String _baseUrl = ApiConfig.journalsEndpoint;
  final String _analysisUrl = '${ApiConfig.workoutLogEndpoint}/analyze';

  // muscleName (쉼표로 구분된 문자열)을 배열로 변환하는 헬퍼
  List<String> _parseMusclesToList(String? muscleName) {
    if (muscleName == null || muscleName.isEmpty) return [];
    return muscleName.split(',').map((m) => m.trim()).where((m) => m.isNotEmpty).toList();
  }

  // 헤더에 토큰 추가하는 헬퍼 메서드
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    return {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
  }

  // 1. 특정 날짜의 일지 조회 (피드백 포함)
  Future<DailyLogModelResponse?> getDailyLogByDate(String date) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/by-date?date=$date'),
        headers: headers,
      );
  
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final log = DailyLogModelResponse.fromJson(jsonData);
        
        // 피드백이 응답에 포함되어 있지 않으면 별도로 조회
        if (log.feedback == null) {
          try {
            final feedback = await getAIFeedback(log.logId);
            return DailyLogModelResponse(
              logId: log.logId,
              date: log.date,
              memo: log.memo,
              exercises: log.exercises,
              feedback: feedback,
            );
          } catch (e) {
            // 피드백 조회 실패는 무시 (피드백이 없는 경우일 수 있음)
            return log;
          }
        }
        
        return log;
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

  // 8. AI 운동 분석 요청
  Future<WorkoutAnalysisResponse> analyzeWorkoutLog(
    DailyLogModelResponse dailyLog, {
    String model = 'gpt-4o-mini',
  }) async {
    try {
      final headers = await _getHeaders();

      // DailyLogModelResponse를 API 요청 형태로 변환
      final requestBody = {
        'logId': dailyLog.logId,
        'date': dailyLog.date,
        'memo': dailyLog.memo,
        'exercises': dailyLog.exercises.map((exercise) {
          // muscleName을 배열로 변환
          final muscles = _parseMusclesToList(exercise.exercise.muscleName);
          
          return {
            'logExerciseId': exercise.logExerciseId,
            'exercise': {
              'exerciseId': exercise.exercise.exerciseId,
              'title': exercise.exercise.title,
              'muscles': muscles,
              'videoUrl': exercise.exercise.videoUrl,
              'trainingName': exercise.exercise.trainingName,
              'exerciseTool': exercise.exercise.exerciseTool,
              'targetGroup': exercise.exercise.targetGroup,
              'fitnessFactorName': exercise.exercise.fitnessFactorName,
              'fitnessLevelName': exercise.exercise.fitnessLevelName,
              'trainingPlaceName': exercise.exercise.trainingPlaceName,
            },
            'intensity': exercise.intensity,
            'exerciseTime': exercise.exerciseTime,
          };
        }).toList(),
      };

      final response = await http.post(
        Uri.parse('$_analysisUrl?model=$model'),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print(response.body);
        print(jsonDecode(response.body));
        final Map<String, dynamic> jsonData =
            jsonDecode(utf8.decode(response.bodyBytes));
        return WorkoutAnalysisResponse.fromJson(jsonData);
      } else {
        final Map<String, dynamic> jsonData =
            jsonDecode(utf8.decode(response.bodyBytes));
        return WorkoutAnalysisResponse.fromJson(jsonData);
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('네트워크 오류: ${e.toString()}');
    }
  }

  // 9. AI 피드백 저장
  Future<void> saveAIFeedback(int logId, AIFeedback feedback) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$_baseUrl/$logId/feedback'),
        headers: headers,
        body: jsonEncode(feedback.toJson()),
      );

      if (response.statusCode == 200) {
        // 성공
        return;
      } else if (response.statusCode == 401) {
        throw Exception('인증에 실패했습니다. 다시 로그인해주세요.');
      } else if (response.statusCode == 403) {
        throw Exception('권한이 없습니다.');
      } else if (response.statusCode == 404) {
        throw Exception('해당 일지를 찾을 수 없습니다.');
      } else {
        throw Exception('피드백 저장 중 오류가 발생했습니다: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('네트워크 오류: ${e.toString()}');
    }
  }

  // 10. AI 피드백 조회 (내부 사용)
  Future<AIFeedback?> getAIFeedback(int logId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/$logId/feedback'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        return AIFeedback.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        // 피드백이 없음
        return null;
      } else if (response.statusCode == 401) {
        throw Exception('인증에 실패했습니다. 다시 로그인해주세요.');
      } else if (response.statusCode == 403) {
        throw Exception('권한이 없습니다.');
      } else {
        throw Exception('피드백 조회 중 오류가 발생했습니다: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('네트워크 오류: ${e.toString()}');
    }
  }
}

