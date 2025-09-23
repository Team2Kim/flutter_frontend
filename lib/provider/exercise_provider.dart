import 'package:flutter/material.dart';
import 'package:gukminexdiary/services/exercise_service.dart';
import 'package:gukminexdiary/model/exercise_model.dart';

class ExerciseProvider extends ChangeNotifier {
  final ExerciseService _exerciseService = ExerciseService();
  List<ExerciseModelResponse> _exercises = [];
  List<ExerciseModelResponse> _bookmarks = [];

  List<ExerciseModelResponse> get exercises => _exercises;
  List<ExerciseModelResponse> get bookmarks => _bookmarks;

  int _nowPage = 0;
  bool _lastPage = false;
  

  void setExercises(List<ExerciseModelResponse> exercises) {
    _exercises.addAll(exercises);
    notifyListeners();
  }

  Future<void> getExercisesData() async {
    if (_lastPage) return;
    _nowPage++;
    final exercises = await _exerciseService.getExercisesData(_nowPage, 10);
    print(exercises);
    if (exercises.length < 10) {
      _lastPage = true;
    }
    setExercises(exercises);  
    notifyListeners();
  }
}
