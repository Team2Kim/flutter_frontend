import 'package:gukminexdiary/model/exercise_model.dart';
import 'package:gukminexdiary/model/workout_analysis_model.dart';

class DailyLogModelResponse {
  final int logId;
  final String date;
  final String? memo;
  final List<LogExercise> exercises;
  final AIFeedback? feedback;

  DailyLogModelResponse({
    required this.logId,
    required this.date,
    this.memo,
    required this.exercises,
    this.feedback,
  });

  factory DailyLogModelResponse.fromJson(Map<String, dynamic> json) {
    return DailyLogModelResponse(
      logId: json['logId'] is String ? int.parse(json['logId']) : json['logId'],
      date: json['date'],
      memo: json['memo'],
      exercises: (json['exercises'] as List?)
          ?.map((e) => LogExercise.fromJson(e))
          .toList() ?? [],
      feedback: json['feedback'] != null
          ? AIFeedback.fromJson(json['feedback'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logId': logId,
      'date': date,
      'memo': memo,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'feedback': feedback?.toJson(),
    };
  }
}

class LogExercise {
  final int logExerciseId;
  final String intensity;
  final int exerciseTime;
  final String? exerciseMemo;
  final ExerciseModelResponse exercise;

  LogExercise({
    required this.logExerciseId,
    required this.intensity,
    required this.exerciseTime,
    this.exerciseMemo,
    required this.exercise,
  });

  factory LogExercise.fromJson(Map<String, dynamic> json) {
    return LogExercise(
      logExerciseId: json['logExerciseId'] is String 
          ? int.parse(json['logExerciseId']) 
          : json['logExerciseId'],
      intensity: json['intensity'],
      exerciseTime: json['exerciseTime'] is String 
          ? int.parse(json['exerciseTime']) 
          : json['exerciseTime'],
      exerciseMemo: json['exerciseMemo'],
      exercise: ExerciseModelResponse.fromJson(json['exercise']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logExerciseId': logExerciseId,
      'intensity': intensity,
      'exerciseTime': exerciseTime,
      'exerciseMemo': exerciseMemo,
      'exercise': exercise.toJson(),
    };
  }
}

// Request DTOs
class CreateDailyLogRequest {
  final String date;
  final String? memo;

  CreateDailyLogRequest({
    required this.date,
    this.memo,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'memo': memo,
    };
  }
}

class UpdateDailyLogRequest {
  final String? memo;

  UpdateDailyLogRequest({
    this.memo,
  });

  Map<String, dynamic> toJson() {
    return {
      'memo': memo,
    };
  }
}

class AddExerciseToLogRequest {
  final int exerciseId;
  final String intensity;
  final int exerciseTime;
  final String? exerciseMemo;

  AddExerciseToLogRequest({
    required this.exerciseId,
    required this.intensity,
    required this.exerciseTime,
    this.exerciseMemo,
  });

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'intensity': intensity,
      'exerciseTime': exerciseTime,
      'exerciseMemo': exerciseMemo,
    };
  }
}

class UpdateLogExerciseRequest {
  final String? intensity;
  final int? exerciseTime;
  final String? exerciseMemo;

  UpdateLogExerciseRequest({
    this.intensity,
    this.exerciseTime,
    this.exerciseMemo,
  });

  Map<String, dynamic> toJson() {
    return {
      'intensity': intensity,
      'exerciseTime': exerciseTime,
      'exerciseMemo': exerciseMemo,
    };
  }
}

