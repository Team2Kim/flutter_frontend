class MuscleModel {
  final String name;
  final String upperLowerBody; // 상체/하체
  final String bodyPart; // 가슴, 어깨, 등, 엉덩이, 복부, 팔, 허벅지, 종아리, 목, 손/발
  final String description; // 설명/대표 위치

  MuscleModel({
    required this.name,
    required this.upperLowerBody,
    required this.bodyPart,
    required this.description,
  });

  factory MuscleModel.fromJson(Map<String, dynamic> json) {
    return MuscleModel(
      name: json['name'],
      upperLowerBody: json['upperLowerBody'],
      bodyPart: json['bodyPart'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'upperLowerBody': upperLowerBody,
      'bodyPart': bodyPart,
      'description': description,
    };
  }
}

class BodyPartModel {
  final String name;
  final String upperLowerBody;
  final List<MuscleModel> muscles;

  BodyPartModel({
    required this.name,
    required this.upperLowerBody,
    required this.muscles,
  });
}
