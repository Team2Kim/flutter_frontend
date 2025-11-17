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
    print(json['basic_analysis']);
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

// 주간 패턴 분석 응답 모델
class WeeklyPatternResponse {
  final bool success;
  final WeeklyPattern? aiPattern;
  final WeeklyMetricsSummary? metricsSummary;
  final String? model;
  final int? recordsAnalyzed;
  final String? message;

  WeeklyPatternResponse({
    required this.success,
    this.aiPattern,
    this.metricsSummary,
    this.model,
    this.recordsAnalyzed,
    this.message,
  });

  factory WeeklyPatternResponse.fromJson(Map<String, dynamic> json) {
    return WeeklyPatternResponse(
      success: json['success'] ?? false,
      aiPattern: json['ai_pattern'] != null
          ? WeeklyPattern.fromJson(json['ai_pattern'])
          : null,
      metricsSummary: json['metrics_summary'] != null
          ? WeeklyMetricsSummary.fromJson(json['metrics_summary'])
          : null,
      model: json['model'],
      recordsAnalyzed: _parseInt(json['records_analyzed']),
      message: json['message'],
    );
  }

  // String 또는 int를 int로 안전하게 변환하는 헬퍼 함수
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value);
    }
    if (value is num) {
      return value.toInt();
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'ai_pattern': aiPattern?.toJson(),
      'metrics_summary': metricsSummary?.toJson(),
      'model': model,
      'records_analyzed': recordsAnalyzed,
      'message': message,
    };
  }
}

// 주간 메트릭스 요약 모델
class WeeklyMetricsSummary {
  final int weeklyWorkoutCount;
  final int restDays;
  final int totalMinutes;
  final Map<String, int> intensityCounts;
  final Map<String, int> bodyPartCounts;
  final List<MuscleCount> topMuscles;

  WeeklyMetricsSummary({
    required this.weeklyWorkoutCount,
    required this.restDays,
    required this.totalMinutes,
    required this.intensityCounts,
    required this.bodyPartCounts,
    required this.topMuscles,
  });

  factory WeeklyMetricsSummary.fromJson(Map<String, dynamic> json) {
    return WeeklyMetricsSummary(
      weeklyWorkoutCount: _parseInt(json['weekly_workout_count']) ?? 0,
      restDays: _parseInt(json['rest_days']) ?? 0,
      totalMinutes: _parseInt(json['total_minutes']) ?? 0,
      intensityCounts: _parseStringIntMap(json['intensity_counts'] ?? {}),
      bodyPartCounts: _parseStringIntMap(json['body_part_counts'] ?? {}),
      topMuscles: (json['top_muscles'] as List<dynamic>?)
              ?.map((e) => MuscleCount.fromJson(e))
              .toList() ??
          [],
    );
  }

  // String 또는 int를 int로 안전하게 변환하는 헬퍼 함수
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value);
    }
    if (value is num) {
      return value.toInt();
    }
    return null;
  }

  // Map<String, dynamic>을 Map<String, int>로 안전하게 변환
  static Map<String, int> _parseStringIntMap(dynamic value) {
    if (value == null || value is! Map) return {};
    final result = <String, int>{};
    value.forEach((key, val) {
      final intValue = _parseInt(val);
      if (intValue != null) {
        result[key.toString()] = intValue;
      }
    });
    return result;
  }

  Map<String, dynamic> toJson() {
    return {
      'weekly_workout_count': weeklyWorkoutCount,
      'rest_days': restDays,
      'total_minutes': totalMinutes,
      'intensity_counts': intensityCounts,
      'body_part_counts': bodyPartCounts,
      'top_muscles': topMuscles.map((e) => e.toJson()).toList(),
    };
  }
}

// 근육 카운트 모델
class MuscleCount {
  final String name;
  final int count;

  MuscleCount({
    required this.name,
    required this.count,
  });

  factory MuscleCount.fromJson(Map<String, dynamic> json) {
    return MuscleCount(
      name: json['name'] ?? '',
      count: _parseInt(json['count']) ?? 0,
    );
  }

  // String 또는 int를 int로 안전하게 변환하는 헬퍼 함수
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value);
    }
    if (value is num) {
      return value.toInt();
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'count': count,
    };
  }
}

class WeeklyPattern {
  final PatternAnalysis? patternAnalysis;
  final RecommendedRoutine? recommendedRoutine;
  final String? recoveryGuidance;
  final List<String>? nextTargetMuscles;
  final String? encouragement;

  WeeklyPattern({
    this.patternAnalysis,
    this.recommendedRoutine,
    this.recoveryGuidance,
    this.nextTargetMuscles,
    this.encouragement,
  });

  factory WeeklyPattern.fromJson(Map<String, dynamic> json) {
    return WeeklyPattern(
      patternAnalysis: json['pattern_analysis'] != null
          ? PatternAnalysis.fromJson(json['pattern_analysis'])
          : null,
      recommendedRoutine: json['recommended_routine'] != null
          ? RecommendedRoutine.fromJson(json['recommended_routine'])
          : null,
      recoveryGuidance: json['recovery_guidance'],
      nextTargetMuscles: (json['next_target_muscles'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      encouragement: json['encouragement'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pattern_analysis': patternAnalysis?.toJson(),
      'recommended_routine': recommendedRoutine?.toJson(),
      'recovery_guidance': recoveryGuidance,
      'next_target_muscles': nextTargetMuscles,
      'encouragement': encouragement,
    };
  }
}

class PatternAnalysis {
  final String? consistency;
  final String? intensityTrend;
  final MuscleBalance? muscleBalance;
  final String? habitObservation;

  PatternAnalysis({
    this.consistency,
    this.intensityTrend,
    this.muscleBalance,
    this.habitObservation,
  });

  factory PatternAnalysis.fromJson(Map<String, dynamic> json) {
    return PatternAnalysis(
      consistency: json['consistency'],
      intensityTrend: json['intensity_trend'],
      muscleBalance: json['muscle_balance'] != null
          ? MuscleBalance.fromJson(json['muscle_balance'])
          : null,
      habitObservation: json['habit_observation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'consistency': consistency,
      'intensity_trend': intensityTrend,
      'muscle_balance': muscleBalance?.toJson(),
      'habit_observation': habitObservation,
    };
  }
}

class MuscleBalance {
  final List<String>? overworked;
  final List<String>? underworked;
  final String? comments;

  MuscleBalance({
    this.overworked,
    this.underworked,
    this.comments,
  });

  factory MuscleBalance.fromJson(Map<String, dynamic> json) {
    return MuscleBalance(
      overworked: (json['overworked'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      underworked: (json['underworked'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      comments: json['comments'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overworked': overworked,
      'underworked': underworked,
      'comments': comments,
    };
  }
}

class RecommendedRoutine {
  final List<String>? weeklyOverview;
  final List<DailyDetail>? dailyDetails;
  final String? progressionStrategy;

  RecommendedRoutine({
    this.weeklyOverview,
    this.dailyDetails,
    this.progressionStrategy,
  });

  factory RecommendedRoutine.fromJson(Map<String, dynamic> json) {
    return RecommendedRoutine(
      weeklyOverview: (json['weekly_overview'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      dailyDetails: (json['daily_details'] as List<dynamic>?)
          ?.map((e) => DailyDetail.fromJson(e))
          .toList(),
      progressionStrategy: json['progression_strategy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weekly_overview': weeklyOverview,
      'daily_details': dailyDetails?.map((e) => e.toJson()).toList(),
      'progression_strategy': progressionStrategy,
    };
  }
}

class DailyDetail {
  final int? day;
  final String? focus;
  final List<ExerciseDetail>? exercises;
  final String? estimatedDuration;

  DailyDetail({
    this.day,
    this.focus,
    this.exercises,
    this.estimatedDuration,
  });

  factory DailyDetail.fromJson(Map<String, dynamic> json) {
    return DailyDetail(
      day: json['day'],
      focus: json['focus'],
      exercises: (json['exercises'] as List<dynamic>?)
          ?.map((e) => ExerciseDetail.fromJson(e))
          .toList(),
      estimatedDuration: json['estimated_duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'focus': focus,
      'exercises': exercises?.map((e) => e.toJson()).toList(),
      'estimated_duration': estimatedDuration,
    };
  }
}

class ExerciseDetail {
  final int? exerciseId;
  final String? name;
  final String? title;
  final String? sets;
  final String? reps;
  final String? rest;
  final String? notes;
  final String? videoUrl;
  final String? bodyPart;
  final String? exerciseTool;
  final String? description;
  final String? targetGroup;
  final String? standardTitle;
  final String? fitnessLevelName;
  final String? fitnessFactorName;
  final String? imageUrl;
  final String? imageFileName;
  final int? videoLengthSeconds;
  final String? muscleName;

  ExerciseDetail({
    this.exerciseId,
    this.name,
    this.title,
    this.sets,
    this.reps,
    this.rest,
    this.notes,
    this.videoUrl,
    this.bodyPart,
    this.exerciseTool,
    this.description,
    this.targetGroup,
    this.standardTitle,
    this.fitnessLevelName,
    this.fitnessFactorName,
    this.imageUrl,
    this.imageFileName,
    this.videoLengthSeconds,
    this.muscleName,
  });

  factory ExerciseDetail.fromJson(Map<String, dynamic> json) {
    String? parsedMuscleName;
    final rawMuscleData = json['muscle_name'] ?? json['muscles'];
    if (rawMuscleData is List) {
      // 리스트 형식: [{name: "근육1"}, {name: "근육2"}] 또는 ["근육1", "근육2"]
      parsedMuscleName = rawMuscleData.map((muscle) {
        if (muscle is Map && muscle['name'] != null) {
          return muscle['name'].toString();
        }
        return muscle.toString();
      }).where((name) => name.isNotEmpty).join(',');
    } else if (rawMuscleData is String) {
      // 문자열 형식: "근육1,근육2,근육3" - 공백 제거 후 그대로 사용
      parsedMuscleName = rawMuscleData.trim();
    }

    return ExerciseDetail(
      exerciseId: _parseInt(json['exercise_id']),
      name: json['name'],
      title: json['title'],
      sets: json['sets'],
      reps: json['reps'],
      rest: json['rest'],
      notes: json['notes'],
      videoUrl: json['video_url'],
      bodyPart: json['body_part'],
      exerciseTool: json['exercise_tool'],
      description: json['description'],
      targetGroup: json['target_group'],
      standardTitle: json['standard_title'],
      fitnessLevelName: json['fitness_level_name'],
      fitnessFactorName: json['fitness_factor_name'],
      imageUrl: json['image_url'],
      imageFileName: json['image_file_name'],
      videoLengthSeconds: _parseInt(json['video_length_seconds']),
      muscleName: parsedMuscleName,
    );
  }

  // String 또는 int를 int로 안전하게 변환하는 헬퍼 함수
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value);
    }
    if (value is num) {
      return value.toInt();
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'exercise_id': exerciseId,
      'name': name,
      'title': title,
      'sets': sets,
      'reps': reps,
      'rest': rest,
      'notes': notes,
      'video_url': videoUrl,
      'body_part': bodyPart,
      'exercise_tool': exerciseTool,
      'description': description,
      'target_group': targetGroup,
      'standard_title': standardTitle,
      'fitness_level_name': fitnessLevelName,
      'fitness_factor_name': fitnessFactorName,
      'image_url': imageUrl,
      'image_file_name': imageFileName,
      'video_length_seconds': videoLengthSeconds,
      'muscle_name': muscleName,
    };
  }
}

