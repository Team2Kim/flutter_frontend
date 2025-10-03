import 'package:flutter/material.dart';
import 'package:gukminexdiary/services/exercise_service.dart';
import 'package:gukminexdiary/model/exercise_model.dart';

class ExerciseProvider extends ChangeNotifier {
  final ExerciseService _exerciseService = ExerciseService();
  List<ExerciseModelResponse> _exercises = [];
  List<ExerciseModelResponse> _bookmarks = [];

  List<ExerciseModelResponse> get exercises => _exercises;
  List<ExerciseModelResponse> get bookmarks => _bookmarks;

  // List<String> _selectedBodyParts = [];
  // List<String> get selectedBodyParts => _selectedBodyParts;

  // List<String> _selectedMuscles = [];
  // List<String> get selectedMuscles => _selectedMuscles;

  bool get lastPage => _lastPage;
  bool get isLoading => _isLoading;

  int _nowPage = 0;
  bool _lastPage = false;
  bool _isLoading = false;
  String _keyword = '';


  void setExercises(List<ExerciseModelResponse> exercises) {
    _exercises.addAll(exercises);
    notifyListeners();
  }

  // void setSelectedBodyParts(List<String> selectedBodyParts) {
  //   _selectedBodyParts = selectedBodyParts;
  //   notifyListeners();
  // }

  // void setSelectedMuscles(List<String> selectedMuscles) {
  //   _selectedMuscles = selectedMuscles;
  //   notifyListeners();
  // }

  Future<void> getExercisesData(String keyword) async {
    if (_lastPage || _isLoading) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final exercises = await _exerciseService.getExercisesData(_nowPage, 10, keyword);
      print('페이지 $_nowPage 로드됨, 데이터 개수: ${exercises.length}');
      _nowPage++;
      _keyword = keyword;
      if (exercises.length < 10) {
        _lastPage = true;
      }
      setExercises(exercises);
    } catch (e) {
      print('데이터 로드 실패: $e');
      _nowPage--; // 실패시 페이지 번호 되돌리기
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getMoreExercisesData() async {
    getExercisesData(_keyword);
  }

  void resetExercises() {
    _nowPage = 0;
    _lastPage = false;
    _isLoading = false;
    _exercises = [];
    _keyword = '';
    notifyListeners();
  }
}
