import 'package:flutter/material.dart';
import 'package:gukminexdiary/model/exercise_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkProvider extends ChangeNotifier {
  List<ExerciseModelResponse> _bookmarks = [];

  List<ExerciseModelResponse> get bookmarks => _bookmarks;

  void addBookmark(ExerciseModelResponse exercise) async {
    if (!isBookmarked(exercise)) {
      _bookmarks.add(exercise);
      await _saveBookmarksToStorage();
      notifyListeners();
    }
  }

  void removeBookmark(ExerciseModelResponse exercise) async {
    _bookmarks.removeWhere((bookmark) => bookmark.exerciseId == exercise.exerciseId);
    await _saveBookmarksToStorage();
    notifyListeners();
  }

  bool isBookmarked(ExerciseModelResponse exercise) {
    return _bookmarks.any((bookmark) => bookmark.exerciseId == exercise.exerciseId);
  }

  Future<void> getBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bookmarksJson = prefs.getString('exercise_bookmarks');
      
      if (bookmarksJson != null && bookmarksJson.isNotEmpty) {
        final List<dynamic> bookmarksList = jsonDecode(bookmarksJson);
        _bookmarks = bookmarksList.map((json) => ExerciseModelResponse.fromJson(json)).toList();
      } else {
        // 첫 실행 시 빈 리스트로 시작
        _bookmarks = [];
      }
      notifyListeners();
    } catch (e) {
      print('북마크 로드 오류: $e');
      _bookmarks = [];
      notifyListeners();
    }
  }

  Future<void> _saveBookmarksToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bookmarksJson = jsonEncode(_bookmarks.map((bookmark) => bookmark.toJson()).toList());
      await prefs.setString('exercise_bookmarks', bookmarksJson);
    } catch (e) {
      print('북마크 저장 오류: $e');
    }
  }
} 