import 'package:flutter/material.dart';
import 'package:gukminexdiary/services/exercise_service.dart';
import 'package:gukminexdiary/model/exercise_model.dart';

class ExerciseProvider extends ChangeNotifier {
  final ExerciseService _exerciseService = ExerciseService();
  List<ExerciseModelResponse> _exercises = [];
  List<ExerciseModelResponse> _bookmarks = [];
  
  // 근육별 검색을 위한 변수들
  List<ExerciseModelResponse> _muscleExercises = [];
  int _muscleNowPage = 0;
  bool _muscleLastPage = false;
  bool _isMuscleLoading = false;
  List<String> _selectedMuscleNames = [];

  List<ExerciseModelResponse> get exercises => _exercises;
  List<ExerciseModelResponse> get bookmarks => _bookmarks;
  List<ExerciseModelResponse> get muscleExercises => _muscleExercises;

  bool get lastPage => _lastPage;
  bool get isLoading => _isLoading;
  bool get muscleLastPage => _muscleLastPage;
  bool get isMuscleLoading => _isMuscleLoading;

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

  // 근육별 검색 메서드들
  Future<void> getExercisesByMuscle(List<String> muscleNames, int page) async {
    // 첫 페이지(0)가 아니고 이미 로딩 중이거나 마지막 페이지인 경우만 리턴
    if (page > 0 && (_muscleLastPage || _isMuscleLoading)) return;
    
    // 근육명이 변경되었거나 첫 페이지인 경우 상태 초기화
    if (page == 0 || _selectedMuscleNames.join(',') != muscleNames.join(',')) {
      _muscleNowPage = 0;
      _muscleLastPage = false;
      _muscleExercises.clear();
    }
    
    _isMuscleLoading = true;
    _selectedMuscleNames = muscleNames;
    notifyListeners();
    
    try {
      final exercises = await _exerciseService.getExercisesByMuscle(muscleNames, page, 10);
      print('근육별 검색 페이지 $page 로드됨, 데이터 개수: ${exercises.length}');
      
      if (page == 0) {
        _muscleExercises = exercises;
        _muscleNowPage = 1;
      } else {
        _muscleExercises.addAll(exercises);
        _muscleNowPage++;
      }
      
      if (exercises.length < 10) {
        _muscleLastPage = true;
      }
      
      notifyListeners();
    } catch (e) {
      print('근육별 검색 실패: $e');
    } finally {
      _isMuscleLoading = false;
      notifyListeners();
    }
  }

  Future<void> getMoreExercisesByMuscle() async {
    if (_muscleNowPage > 0) {
      await getExercisesByMuscle(_selectedMuscleNames, _muscleNowPage);
    }
  }

  void resetMuscleExercises() {
    _muscleNowPage = 0;
    _muscleLastPage = false;
    _isMuscleLoading = false;
    _muscleExercises = [];
    _selectedMuscleNames = [];
    notifyListeners();
  }
}
