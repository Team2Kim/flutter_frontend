class ExerciseModelResponse {
  final int exerciseId;
  final String title;
  final String category;
  final String exerciseTool;
  final String bodyPart;
  final String targetGroup;
  final String videoUrl;
  final bool isGookmin100;
  final int? videoLength;
  final DateTime? createdAt;
  final String? imageUrl;
  final String? videoDescription;

  ExerciseModelResponse(
    {
      required this.exerciseId, 
      required this.title, 
      required this.category, 
      required this.exerciseTool, 
      required this.bodyPart, 
      required this.targetGroup, 
      required this.videoUrl, 
      required this.isGookmin100,
      this.videoLength,
      this.createdAt,
      this.imageUrl,
      this.videoDescription,
    });


  factory ExerciseModelResponse.fromJson(Map<String, dynamic> json) {
    return ExerciseModelResponse(
      exerciseId: json['exerciseId'] ?? '',
      title: json['title'] ?? '',
      category: json['category'],
      exerciseTool: json['exerciseTool'] ?? '',
      bodyPart: json['bodyPart'] ?? '',
      targetGroup: json['targetGroup'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      isGookmin100: json['isgookmin100'],
      videoLength: json['videoLength'] ?? '',
      createdAt: json['createdAt'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  factory ExerciseModelResponse.fromJson_temp(Map<String,dynamic> json) {
    // print(json);
    return ExerciseModelResponse(
      exerciseId: json['exerciseId'] ?? 0,
      title: json["vdo_ttl_nm"] ?? '',
      category: json['oper_nm'] ?? '',
      exerciseTool: json['exerciseTool'] ?? '',
      bodyPart: json['bodyPart'] ?? '',
      targetGroup: json['aggrp_nm'] ?? '',
      videoUrl: json["file_url"] + json["file_nm"],
      isGookmin100: json['isgookmin100'] ?? true,
      videoLength: int.parse(json['vdo_len'] ?? '0'),
      createdAt: DateTime.parse(json['job_ymd'] ?? ''),
      imageUrl: json['img_file_url'] + json['img_file_nm'],
      videoDescription: json['vdo_desc'] ?? '',
    );
  }
}