import 'package:flutter/material.dart';
import 'package:gukminexdiary/services/exercise_service.dart';
import 'package:gukminexdiary/model/exercise_model.dart';

class ExerciseProvider extends ChangeNotifier {
  final ExerciseService _exerciseService = ExerciseService();
  List<ExerciseModelResponse> _exercises = [];
  List<ExerciseModelResponse> _bookmarks = [];

  List<ExerciseModelResponse> get exercises => _exercises;
  List<ExerciseModelResponse> get bookmarks => _bookmarks;

  void setExercises(List<ExerciseModelResponse> exercises) {
    _exercises = exercises;
    notifyListeners();
  }

  Future<void> getExercisesData(int page, int size) async {
    final exercises = await _exerciseService.getExercisesData(page, size);
    print(exercises);
    setExercises(exercises);  
    notifyListeners();
  }
}
