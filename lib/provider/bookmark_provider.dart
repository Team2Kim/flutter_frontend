import 'package:flutter/material.dart';
import 'package:gukminexdiary/model/exercise_model.dart';
import 'package:gukminexdiary/model/bookmark_model.dart';
import 'package:gukminexdiary/services/bookmark_service.dart';

class BookmarkProvider extends ChangeNotifier {
  final BookmarkService _bookmarkService = BookmarkService();
  
  List<ExerciseModelResponse> _bookmarks = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<ExerciseModelResponse> get bookmarks => _bookmarks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 에러 메시지 초기화
  void _clearError() {
    _errorMessage = null;
  }

  // 즐겨찾기 추가
  void addBookmark(ExerciseModelResponse exercise) {
    if (!isBookmarked(exercise)) {
      _bookmarks.add(exercise);
      notifyListeners();
    }
  }

  // 즐겨찾기 제거
  void removeBookmark(ExerciseModelResponse exercise) {
    _bookmarks.removeWhere((bookmark) => bookmark.exerciseId == exercise.exerciseId);
    notifyListeners();
  }

  // 즐겨찾기 토글 (추가/삭제)
  Future<bool> toggleBookmark(ExerciseModelResponse exercise) async {
    try {
      _isLoading = true;
      _clearError();
      notifyListeners();

      final success = await _bookmarkService.toggleBookmark(exercise.exerciseId);
      
      if (success) {
        // 로컬 상태 업데이트
        if (isBookmarked(exercise)) {
          // 즐겨찾기에서 제거
          removeBookmark(exercise);
        } else {
          // 즐겨찾기에 추가
          addBookmark(exercise);
        }
      }

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 즐겨찾기 목록 조회 (서버에서 직접 가져오기)
  Future<void> getBookmarks() async {
    try {
      _isLoading = true;
      _clearError();
      notifyListeners();

      // API에서 북마크 목록 가져오기
      final apiResponse = await _bookmarkService.getBookmarks();
      
      // 서버 북마크에서 운동 데이터 추출
      _bookmarks = apiResponse.content.map((bookmark) => bookmark.exercise).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  // 특정 운동이 즐겨찾기되었는지 확인
  bool isBookmarked(ExerciseModelResponse exercise) {
    return _bookmarks.any((bookmark) => bookmark.exerciseId == exercise.exerciseId);
  }

  // 즐겨찾기 목록 초기화
  void clearBookmarks() {
    _bookmarks.clear();
    _clearError();
    notifyListeners();
  }

  // 북마크 개수
  int get bookmarkCount => _bookmarks.length;
} 