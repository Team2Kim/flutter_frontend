import 'package:flutter/material.dart';
import 'package:gukminexdiary/model/exercise_model.dart';
import 'package:gukminexdiary/services/dailylog_service.dart';
import 'package:gukminexdiary/model/dailylog_model.dart';
import 'package:intl/intl.dart';
import 'package:gukminexdiary/widget/exercise_record_dialog.dart';

class AddExerciseDialog {
  static Future<void> show(
    BuildContext context,
    ExerciseModelResponse exercise, {
    DateTime? date,
  }) async {
    final selectedDate = date ?? DateTime.now();
    final result = await ExerciseRecordDialog.show(
      context,
      mode: ExerciseRecordDialogMode.add,
      exerciseTitle: exercise.title,
      initialIntensity: '중',
      initialTime: 30,
      initialMemo: null,
      standardTitle: exercise.standardTitle ?? '',
    );

    if (result == null) return;

    await _addExerciseToLog(
      context,
      exercise.exerciseId,
      exercise.title,
      result.intensity,
      result.exerciseTime,
      result.exerciseMemo,
      selectedDate,
    );
  }

  static Future<void> _addExerciseToLog(
    BuildContext context,
    int exerciseId,
    String exerciseTitle,
    String intensity,
    int exerciseTime,
    String? exerciseMemo,
    DateTime date,
  ) async {
    final dailyLogService = DailyLogService();
    final dateStr = DateFormat('yyyy-MM-dd').format(date);

    // 로딩 표시
    try {
      if (!context.mounted) return;
      final messenger = ScaffoldMessenger.maybeOf(context);
      messenger?.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              const Text('운동을 추가하고 있습니다...'),
            ],
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.blue.shade700,
        ),
      );
    } catch (_) {}

    try {
      // 먼저 해당 날짜의 일지가 있는지 확인
      DailyLogModelResponse? currentLog = await dailyLogService.getDailyLogByDate(dateStr);

      // 일지가 없으면 생성
      if (currentLog == null) {
        final createRequest = CreateDailyLogRequest(
          date: dateStr,
          memo: null,
        );
        currentLog = await dailyLogService.createDailyLog(createRequest);
      }

      // 운동 기록 추가
      final request = AddExerciseToLogRequest(
        exerciseId: exerciseId,
        intensity: intensity,
        exerciseTime: exerciseTime,
        exerciseMemo: exerciseMemo,
      );

      await dailyLogService.addExerciseToLog(currentLog.logId, request);

      // 성공 메시지
      try {
        if (!context.mounted) return;
        final messenger = ScaffoldMessenger.maybeOf(context);
        messenger?.clearSnackBars();
        messenger?.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '운동이 추가되었습니다!',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$exerciseTitle • $intensity • ${exerciseTime}분',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } catch (_) {}
    } catch (e) {
      // 에러 메시지
      try {
        if (!context.mounted) return;
        final messenger = ScaffoldMessenger.maybeOf(context);
        messenger?.clearSnackBars();
        messenger?.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: const Text('운동 추가 중 오류가 발생했습니다'),
                ),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } catch (_) {}
    }
  }
}
