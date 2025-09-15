class ExerciseModelResponse {
  final int exerciseId;
  final String title;
  final String category;
  final String exerciseTool;
  final String bodyPart;
  final String targetGroup;
  final String videoUrl;
  final bool isGookmin100;

  ExerciseModelResponse(
    {
      required this.exerciseId, 
      required this.title, 
      required this.category, 
      required this.exerciseTool, 
      required this.bodyPart, 
      required this.targetGroup, 
      required this.videoUrl, 
      required this.isGookmin100
    });


  factory ExerciseModelResponse.fromJson(Map<String, dynamic> json) {
    return ExerciseModelResponse(
      exerciseId: json['exerciseId'],
      title: json['title'],
      category: json['category'],
      exerciseTool: json['exerciseTool'],
      bodyPart: json['bodyPart'],
      targetGroup: json['targetGroup'],
      videoUrl: json['videoUrl'],
      isGookmin100: json['isgookmin100'],
    );
  }
}