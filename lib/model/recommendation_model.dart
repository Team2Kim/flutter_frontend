import 'package:gukminexdiary/model/exercise_model.dart';

class RecommendationResponse {
  final List<ExerciseModelResponse> recommendations;

  RecommendationResponse({required this.recommendations});

  factory RecommendationResponse.fromJson(dynamic json) {
    if (json == null) {
      return RecommendationResponse(recommendations: []);
    }

    if (json is List) {
      return RecommendationResponse(
        recommendations: json
            .whereType<Map<String, dynamic>>()
            .map((item) => ExerciseModelResponse.fromJson(item))
            .toList(),
      );
    }

    throw ArgumentError('추천 API 응답 형식이 올바르지 않습니다.');
  }

  List<Map<String, dynamic>> toJson() {
    return recommendations.map((exercise) => exercise.toJson()).toList();
  }
}

