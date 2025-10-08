class ExerciseModelResponse {
  final int exerciseId;
  final String title;
  final String? description;
  final String? trainingName;
  final String? targetGroup;
  final String? fitnessFactorName;
  final String? fitnessLevelName;
  final String? bodyPart;
  final String? muscleName;
  final String? exerciseTool;
  final int? videoLengthSeconds;
  final String? resolution;
  final double? fpsCount;
  final String? imageFileName;
  final String? imageUrl;
  final int? fileSize;
  final String? trainingAimName;
  final String? trainingPlaceName;
  final String? trainingSectionName;
  final String? trainingStepName;
  final String? trainingSequenceName;
  final String? trainingWeekName;
  final String? repetitionCountName;
  final String? setCountName;
  final String? operationName;
  final bool? gookmin100;
  final String? videoUrl;

  ExerciseModelResponse({
    required this.exerciseId,
    required this.title,
    this.description,
    this.trainingName,
    this.targetGroup,
    this.fitnessFactorName,
    this.fitnessLevelName,
    this.bodyPart,
    this.muscleName,
    this.exerciseTool,
    this.videoLengthSeconds,
    this.resolution,
    this.fpsCount,
    this.imageFileName,
    this.imageUrl,
    this.fileSize,
    this.trainingAimName,
    this.trainingPlaceName,
    this.trainingSectionName,
    this.trainingStepName,
    this.trainingSequenceName,
    this.trainingWeekName,
    this.repetitionCountName,
    this.setCountName,
    this.operationName,
    this.gookmin100,
    this.videoUrl,
  });

  factory ExerciseModelResponse.fromJson(Map<String, dynamic> json) {
    // muscles 필드를 안전하게 처리
    String? parsedMuscleName;
    print(json);
    if (json['muscles'] != null && json['muscles'] is List) {
      final musclesList = json['muscles'] as List;
      if (musclesList.isNotEmpty) {
        // 첫 번째 요소가 문자열인지 객체인지 확인
        if (musclesList.first is String) {
          // 문자열 배열: ["위팔두갈래근", "상완근"]
          parsedMuscleName = musclesList
              .map((muscle) => muscle.toString())
              .where((name) => name.isNotEmpty)
              .join(', ');
        } else if (musclesList.first is Map) {
          // 객체 배열: [{name: "위팔두갈래근"}, {name: "상완근"}]
          parsedMuscleName = musclesList
              .map((muscle) => muscle['name']?.toString() ?? '')
              .where((name) => name.isNotEmpty)
              .join(', ');
        }
      }
    }

    return ExerciseModelResponse(
      exerciseId: json['exerciseId'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      trainingName: json['trainingName'],
      targetGroup: json['targetGroup'],
      fitnessFactorName: json['fitnessFactorName'],
      fitnessLevelName: json['fitnessLevelName'],
      bodyPart: json['bodyPart'],
      muscleName: parsedMuscleName,
      exerciseTool: json['exerciseTool'],
      videoLengthSeconds: json['videoLengthSeconds'],
      resolution: json['resolution'],
      fpsCount: json['fpsCount']?.toDouble(),
      imageFileName: json['imageFileName'],
      imageUrl: json['imageUrl'],
      fileSize: json['fileSize'],
      trainingAimName: json['trainingAimName'],
      trainingPlaceName: json['trainingPlaceName'],
      trainingSectionName: json['trainingSectionName'],
      trainingStepName: json['trainingStepName'],
      trainingSequenceName: json['trainingSequenceName'],
      trainingWeekName: json['trainingWeekName'],
      repetitionCountName: json['repetitionCountName'],
      setCountName: json['setCountName'],
      operationName: json['operationName'],
      gookmin100: json['gookmin100'],
      videoUrl: json['videoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'title': title,
      'description': description,
      'trainingName': trainingName,
      'targetGroup': targetGroup,
      'fitnessFactorName': fitnessFactorName,
      'fitnessLevelName': fitnessLevelName,
      'bodyPart': bodyPart,
      'muscleName': muscleName,
      'exerciseTool': exerciseTool,
      'videoLengthSeconds': videoLengthSeconds,
      'resolution': resolution,
      'fpsCount': fpsCount,
      'imageFileName': imageFileName,
      'imageUrl': imageUrl,
      'fileSize': fileSize,
      'trainingAimName': trainingAimName,
      'trainingPlaceName': trainingPlaceName,
      'trainingSectionName': trainingSectionName,
      'trainingStepName': trainingStepName,
      'trainingSequenceName': trainingSequenceName,
      'trainingWeekName': trainingWeekName,
      'repetitionCountName': repetitionCountName,
      'setCountName': setCountName,
      'operationName': operationName,
      'gookmin100': gookmin100,
      'videoUrl': videoUrl,
    };
  }

  // 기존 fromJson_temp 메서드는 제거하고 fromJson으로 통일
  factory ExerciseModelResponse.fromJson_temp(Map<String, dynamic> json) {
    return ExerciseModelResponse.fromJson(json);
  }
}