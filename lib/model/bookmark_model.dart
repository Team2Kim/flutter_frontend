import 'dart:ffi';
import 'package:gukminexdiary/model/exercise_model.dart';
import 'package:gukminexdiary/model/user_model.dart';

class BookmarkModelResponse {
  final Long bookmarkId;
  final UserModelResponse user;
  final ExerciseModelResponse exercise;
  final DateTime createdAt;

  BookmarkModelResponse(
    {
      required this.bookmarkId, 
      required this.user, 
      required this.exercise, 
      required this.createdAt,
    }
  );

  factory BookmarkModelResponse.fromJson(Map<String, dynamic> json) {
    return BookmarkModelResponse(
      bookmarkId: json['bookmarkId'],
      user: json['user'],
      exercise: json['exercise'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}