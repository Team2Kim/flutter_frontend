import 'package:gukminexdiary/model/exercise_model.dart';

class BookmarkApiItem {
  final int bookmarkId;
  final ExerciseModelResponse exercise;
  final DateTime createdAt;

  BookmarkApiItem({
    required this.bookmarkId,
    required this.exercise,
    required this.createdAt,
  });

  factory BookmarkApiItem.fromJson(Map<String, dynamic> json) {
    return BookmarkApiItem(
      bookmarkId: json['bookmarkId'],
      exercise: ExerciseModelResponse.fromJson(json['exercise']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class BookmarkApiResponse {
  final List<BookmarkApiItem> content;
  final int totalPages;
  final int totalElements;
  final bool last;
  final bool first;

  BookmarkApiResponse({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.last,
    required this.first,
  });

  factory BookmarkApiResponse.fromJson(Map<String, dynamic> json) {
    
    return BookmarkApiResponse(
      content: (json['content'] as List)
          .map((item) => BookmarkApiItem.fromJson(item))
          .toList(),
      totalPages: json['totalPages'],
      totalElements: json['totalElements'],
      last: json['last'],
      first: json['first'],
    );
  }
} 
