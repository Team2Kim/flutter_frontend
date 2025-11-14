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
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      surfaceTintColor: const Color.fromARGB(255, 172, 172, 172),
      backgroundColor: const Color.fromARGB(255, 107, 125, 223),
      title: Row(
        children: [
          Icon(
            isAddMode ? Icons.fitness_center : Icons.edit,
            color: const Color.fromARGB(255, 168, 212, 255),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              Text(
                widget.exerciseTitle,
                style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.standardTitle ?? '',
                style: const TextStyle(fontSize: 14, color: Colors.white),
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [const Color.fromARGB(255, 194, 224, 255), const Color.fromARGB(0, 107, 125, 223)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Text(
                  '강도',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                )
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [const Color.fromARGB(255, 194, 224, 255), const Color.fromARGB(0, 107, 125, 223)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Text(
                  '운동 시간',  
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(155, 255, 255, 255),
                ),
                child:
                  TextField(
                    controller: _timeController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: '시간을 입력하세요',
                      suffixText: '분',
                      suffixStyle: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  )
              ),
              const SizedBox(height: 4),
              Text(
                '권장: 5분 ~ 120분',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [const Color.fromARGB(255, 194, 224, 255), const Color.fromARGB(0, 107, 125, 223)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Text(
                  '운동 메모 (무게, 반복, 세트 등)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(155, 255, 255, 255),
                ),
                child: TextField(
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  controller: _memoController,
                  maxLines: 4,
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
          child: const Text('취소', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 210, 210))),
        ),
        _isProcessing ? const SizedBox(width: 10) : ElevatedButton(
          onPressed: _onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 168, 212, 255),
            foregroundColor: Colors.white,
          ),
          child: Text(isAddMode ? '추가' : '저장', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ],
    );
  }
}

