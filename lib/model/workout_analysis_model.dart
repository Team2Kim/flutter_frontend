class WorkoutAnalysisResponse {
  final bool success;
  final AIAnalysis? aiAnalysis;
  final String? message;
  final BasicAnalysis? basicAnalysis;
  final String? model;
  final String? date;

  WorkoutAnalysisResponse({
    required this.success,
    this.aiAnalysis,
    this.message,
    this.basicAnalysis,
    this.model,
    this.date,
  });

  factory WorkoutAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return WorkoutAnalysisResponse(
      success: json['success'] ?? false,
      aiAnalysis: json['ai_analysis'] != null
          ? AIAnalysis.fromJson(json['ai_analysis'])
          : null,
      message: json['message'],
      basicAnalysis: json['basic_analysis'] != null
          ? BasicAnalysis.fromJson(json['basic_analysis'])
          : null,
      model: json['model'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'ai_analysis': aiAnalysis?.toJson(),
      'message': message,
      'basic_analysis': basicAnalysis?.toJson(),
      'model': model,
      'date': date,
    };
  }
}

class AIAnalysis {
  final String? workoutEvaluation;
  final String? targetMuscles;
  final AIRecommendations? recommendations;
  final List<String>? nextTargetMuscles;
  final String? encouragement;

  AIAnalysis({
    this.workoutEvaluation,
    this.targetMuscles,
    this.recommendations,
    this.nextTargetMuscles,
    this.encouragement,
  });

  factory AIAnalysis.fromJson(Map<String, dynamic> json) {
    return AIAnalysis(
      workoutEvaluation: json['workout_evaluation'],
      targetMuscles: json['target_muscles'],
      recommendations: json['recommendations'] != null
          ? AIRecommendations.fromJson(json['recommendations'])
          : null,
      nextTargetMuscles: (json['next_target_muscles'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      encouragement: json['encouragement'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workout_evaluation': workoutEvaluation,
      'target_muscles': targetMuscles,
      'recommendations': recommendations?.toJson(),
      'next_target_muscles': nextTargetMuscles,
      'encouragement': encouragement,
    };
  }
}

class AIRecommendations {
  final String? nextWorkout;
  final String? improvements;
  final String? precautions;

  AIRecommendations({
    this.nextWorkout,
    this.improvements,
    this.precautions,
  });

  factory AIRecommendations.fromJson(Map<String, dynamic> json) {
    return AIRecommendations(
      nextWorkout: json['next_workout'],
      improvements: json['improvements'],
      precautions: json['precautions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'next_workout': nextWorkout,
      'improvements': improvements,
      'precautions': precautions,
    };
  }
}

class BasicAnalysis {
  final String summary;
  final AnalysisStatistics statistics;
  final List<String> insights;
  final List<String> recommendations;
  final List<String> warnings;

  BasicAnalysis({
    required this.summary,
    required this.statistics,
    required this.insights,
    required this.recommendations,
    required this.warnings,
  });

  factory BasicAnalysis.fromJson(Map<String, dynamic> json) {
    return BasicAnalysis(
      summary: json['summary'] ?? '',
      statistics: AnalysisStatistics.fromJson(json['statistics'] ?? {}),
      insights: (json['insights'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      recommendations: (json['recommendations'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      warnings: (json['warnings'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary,
      'statistics': statistics.toJson(),
      'insights': insights,
      'recommendations': recommendations,
      'warnings': warnings,
    };
  }
}

class AnalysisStatistics {
  final int totalExercises;
  final int totalTime;
  final double avgTimePerExercise;
  final Map<String, int> intensityDistribution;
  final Map<String, double> intensityPercentage;
  final Map<String, int> bodyPartsTrained;
  final Map<String, int> exerciseToolsUsed;
  final List<String> musclesTargeted;

  AnalysisStatistics({
    required this.totalExercises,
    required this.totalTime,
    required this.avgTimePerExercise,
    required this.intensityDistribution,
    required this.intensityPercentage,
    required this.bodyPartsTrained,
    required this.exerciseToolsUsed,
    required this.musclesTargeted,
  });

  factory AnalysisStatistics.fromJson(Map<String, dynamic> json) {
    return AnalysisStatistics(
      totalExercises: json['total_exercises'] ?? 0,
      totalTime: json['total_time'] ?? 0,
      avgTimePerExercise: (json['avg_time_per_exercise'] ?? 0.0).toDouble(),
      intensityDistribution: Map<String, int>.from(
          json['intensity_distribution'] ?? {}),
      intensityPercentage: (json['intensity_percentage'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, (value as num).toDouble()),
          ) ??
          {},
      bodyPartsTrained:
          Map<String, int>.from(json['body_parts_trained'] ?? {}),
      exerciseToolsUsed:
          Map<String, int>.from(json['exercise_tools_used'] ?? {}),
      musclesTargeted:
          (json['muscles_targeted'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_exercises': totalExercises,
      'total_time': totalTime,
      'avg_time_per_exercise': avgTimePerExercise,
      'intensity_distribution': intensityDistribution,
      'intensity_percentage': intensityPercentage,
      'body_parts_trained': bodyPartsTrained,
      'exercise_tools_used': exerciseToolsUsed,
      'muscles_targeted': musclesTargeted,
    };
  }
}

// AI 피드백 모델 (서버에 저장하기 위한 구조)
class AIFeedback {
  final String workoutEvaluation;
  final String targetMuscles;
  final AIRecommendations recommendations;
  final List<String> nextTargetMuscles;
  final String encouragement;

  AIFeedback({
    required this.workoutEvaluation,
    required this.targetMuscles,
    required this.recommendations,
    required this.nextTargetMuscles,
    required this.encouragement,
  });

  factory AIFeedback.fromJson(Map<String, dynamic> json) {
    return AIFeedback(
      workoutEvaluation: json['workout_evaluation'] ?? '',
      targetMuscles: json['target_muscles'] ?? '',
      recommendations: json['recommendations'] != null
          ? AIRecommendations.fromJson(json['recommendations'])
          : AIRecommendations(nextWorkout: '', improvements: '', precautions: ''),
      nextTargetMuscles: (json['next_target_muscles'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      encouragement: json['encouragement'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workout_evaluation': workoutEvaluation,
      'target_muscles': targetMuscles,
      'recommendations': recommendations.toJson(),
      'next_target_muscles': nextTargetMuscles,
      'encouragement': encouragement,
    };
  }

  // AIAnalysis에서 AIFeedback으로 변환
  factory AIFeedback.fromAIAnalysis(AIAnalysis analysis) {
    return AIFeedback(
      workoutEvaluation: analysis.workoutEvaluation ?? '',
      targetMuscles: analysis.targetMuscles ?? '',
      recommendations: analysis.recommendations ?? 
          AIRecommendations(nextWorkout: '', improvements: '', precautions: ''),
      nextTargetMuscles: analysis.nextTargetMuscles ?? [],
      encouragement: analysis.encouragement ?? '',
    );
  }
}

