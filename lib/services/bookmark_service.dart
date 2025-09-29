import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gukminexdiary/config/api_config.dart';
import 'package:gukminexdiary/model/bookmark_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkService {
  final String _baseUrl = ApiConfig.bookmarkEndpoint;
  
  // 즐겨찾기 토글 (추가/삭제) - 서버 API는 토글 방식
  Future<bool> toggleBookmark(int exerciseId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$exerciseId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        // 즐겨찾기 추가 성공
        return true;
      } else if (response.statusCode == 204) {
        // 즐겨찾기 삭제 성공
        return true;
      } else if (response.statusCode == 401) {
        throw Exception('인증에 실패했습니다. 다시 로그인해주세요.');
      } else if (response.statusCode == 404) {
        throw Exception('해당 운동을 찾을 수 없습니다.');
      } else {
        throw Exception('즐겨찾기 처리 중 오류가 발생했습니다.');
      }
    } catch (e) {
      throw Exception('네트워크 오류: ${e.toString()}');
    }
  }

  // 내 즐겨찾기 목록 조회 (페이징)
  Future<BookmarkApiResponse> getBookmarks({
    int page = 0,
    int size = 20,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    try {
      final uri = Uri.parse('$_baseUrl?page=$page&size=$size');
      
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return BookmarkApiResponse.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('인증에 실패했습니다. 다시 로그인해주세요.');
      } else {
        throw Exception('즐겨찾기 목록을 가져오는 중 오류가 발생했습니다.');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('네트워크 오류: ${e.toString()}');
    }
  }
}
  