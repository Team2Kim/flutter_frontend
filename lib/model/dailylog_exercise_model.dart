import 'dart:ffi';
import 'package:gukminexdiary/model/dailylog_model.dart';
import 'package:gukminexdiary/model/exercise_model.dart';

class DailyLogExerciseModelResponse {
  final Long dailyLogExerciseId;
  final DailyLogModelResponse dailyLog;
  final ExerciseModelResponse exercise;
  final String intensity;
  final int exerciseTime;

  DailyLogExerciseModelResponse(
    {
      required this.dailyLogExerciseId, 
      required this.dailyLog, 
      required this.exercise, 
      required this.intensity, 
      required this.exerciseTime, 
    });


  factory DailyLogExerciseModelResponse.fromJson(Map<String, dynamic> json) {
    return DailyLogExerciseModelResponse(
      dailyLogExerciseId: json['dailyLogExerciseId'],
      dailyLog: json['dailyLog'],
      exercise: json['exercise'],
      intensity: json['intensity'],
      exerciseTime: json['exerciseTime'],
    );
  }
}