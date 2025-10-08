import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gukminexdiary/model/exercise_model.dart';
import 'package:gukminexdiary/services/dailylog_service.dart';
import 'package:gukminexdiary/model/dailylog_model.dart';
import 'package:intl/intl.dart';

class AddExerciseDialog {
  static Future<void> show(
    BuildContext context,
    ExerciseModelResponse exercise, {
    DateTime? date,
  }) async {
    final selectedDate = date ?? DateTime.now();
    String intensity = '중';
    final TextEditingController timeController = TextEditingController(text: '30');
    final parentContext = context; // 부모 context 저장

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.fitness_center, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  exercise.title,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          content: SizedBox(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 강도 선택
                const Text(
                  '강도',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ['하', '중', '상'].map((level) {
                    return ChoiceChip(
                      label: Text(level),
                      selected: intensity == level,
                      selectedColor: Colors.blue.shade100,
                      onSelected: (selected) {
                        if (selected) {
                          setDialogState(() {
                            intensity = level;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                // 운동 시간 입력
                const Text(
                  '운동 시간',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: timeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  decoration: InputDecoration(
                    hintText: '시간을 입력하세요',
                    suffixText: '분',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    setDialogState(() {});
                  },
                ),
                const SizedBox(height: 4),
                Text(
                  '권장: 5분 ~ 120분',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                timeController.dispose();
                Navigator.pop(context);
              },
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () async {
                final timeText = timeController.text.trim();
                if (timeText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('운동 시간을 입력해주세요'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }
                
                final exerciseTime = int.tryParse(timeText);
                if (exerciseTime == null || exerciseTime <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('올바른 시간을 입력해주세요'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                timeController.dispose();
                Navigator.pop(context);
                
                // 부모 context 사용 (다이얼로그 context가 아닌)
                await _addExerciseToLog(
                  parentContext,
                  exercise.exerciseId,
                  exercise.title,
                  intensity,
                  exerciseTime,
                  selectedDate,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('추가'),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _addExerciseToLog(
    BuildContext context,
    int exerciseId,
    String exerciseTitle,
    String intensity,
    int exerciseTime,
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
                  child: Text('운동 추가 중 오류가 발생했습니다\n$e'),
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
