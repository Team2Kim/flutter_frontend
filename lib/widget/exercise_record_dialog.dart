import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ExerciseRecordDialogMode { add, edit }

class ExerciseRecordFormResult {
  final String intensity;
  final int exerciseTime;
  final String? exerciseMemo;

  ExerciseRecordFormResult({
    required this.intensity,
    required this.exerciseTime,
    this.exerciseMemo,
  });
}

class ExerciseRecordDialog extends StatefulWidget {
  const ExerciseRecordDialog({
    super.key,
    required this.mode,
    required this.exerciseTitle,
    required this.initialIntensity,
    required this.initialTime,
    this.initialMemo,
    this.standardTitle,
  });

  final ExerciseRecordDialogMode mode;
  final String exerciseTitle;
  final String initialIntensity;
  final int initialTime;
  final String? initialMemo;
  final String? standardTitle;
  static Future<ExerciseRecordFormResult?> show(
    BuildContext context, {
    required ExerciseRecordDialogMode mode,
    required String exerciseTitle,
    required String initialIntensity,
    required int initialTime,
    String? initialMemo,
    String? standardTitle,
  }) {
    return showDialog<ExerciseRecordFormResult>(
      context: context,
      builder: (ctx) => ExerciseRecordDialog(
        mode: mode,
        exerciseTitle: exerciseTitle,
        initialIntensity: initialIntensity,
        initialTime: initialTime,
        initialMemo: initialMemo,
        standardTitle: standardTitle,
      ),
    );
  }

  @override
  State<ExerciseRecordDialog> createState() => _ExerciseRecordDialogState();
}

class _ExerciseRecordDialogState extends State<ExerciseRecordDialog> {
  late String _intensity;
  late TextEditingController _timeController;
  late TextEditingController _memoController;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _intensity = widget.initialIntensity;
    _timeController =
        TextEditingController(text: widget.initialTime.toString());
    _memoController =
        TextEditingController(text: widget.initialMemo ?? '');
  }

  @override
  void dispose() {
    _timeController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final timeText = _timeController.text.trim();
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

    setState(() {
      _isProcessing = true;
    });

    Navigator.of(context).pop(
      ExerciseRecordFormResult(
        intensity: _intensity,
        exerciseTime: exerciseTime,
        exerciseMemo:
            _memoController.text.trim().isEmpty ? null : _memoController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAddMode = widget.mode == ExerciseRecordDialogMode.add;

    return AlertDialog(
      backgroundColor: const Color.fromARGB(240, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Row(
        children: [
          Icon(
            isAddMode ? Icons.fitness_center : Icons.edit,
            color: Colors.blue.shade700,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              Text(
                widget.exerciseTitle,
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                widget.standardTitle ?? '',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          )
        ],
      ),
      content: Container(
        decoration: BoxDecoration(
          
          borderRadius: BorderRadius.circular(10),
        ),
        height: 360,
        width: 300,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    selected: _intensity == level,
                    backgroundColor: Colors.white,
                    selectedColor: Colors.blue.shade100,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _intensity = level;
                        });
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                '운동 시간',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _timeController,
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
              ),
              const SizedBox(height: 4),
              Text(
                '권장: 5분 ~ 120분',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '운동 메모 (무게, 반복, 세트 등)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 200, 
                child: TextField(
                  controller: _memoController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: '예: 30kg, 10회 5세트',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
            ),
              
            ],
          ),
        ),
      ),
      actions: [
        _isProcessing
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 25, 118, 210),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        _isProcessing ? const SizedBox(width: 10) : TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        _isProcessing ? const SizedBox(width: 10) : ElevatedButton(
          onPressed: _onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: Text(isAddMode ? '추가' : '저장'),
        ),
      ],
    );
  }
}

