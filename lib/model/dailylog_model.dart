import 'dart:ffi';
import 'package:gukminexdiary/model/user_model.dart';

class DailyLogModelResponse {
  final Long logId;
  final DateTime date;
  final UserModelResponse user;
  final String memo;

  DailyLogModelResponse(
    {
      required this.logId, 
      required this.user,
      required this.date, 
      required this.memo, 
    }
  );

  factory DailyLogModelResponse.fromJson(Map<String, dynamic> json) {
    return DailyLogModelResponse(
      logId: json['logId'],
      date: DateTime.parse(json['date']),
      user: json['user'],
      memo: json['memo'],
    );
  }
}

