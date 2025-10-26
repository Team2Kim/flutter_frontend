import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gukminexdiary/widget/custom_appbar.dart';
import 'package:gukminexdiary/services/dailylog_service.dart';
import 'package:gukminexdiary/model/dailylog_model.dart';
import 'package:gukminexdiary/screen/video_detail_screen.dart';
import 'package:gukminexdiary/screen/workout_analysis_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  ScrollController _scrollController = ScrollController();
  TextEditingController _memoController = TextEditingController();
  
  final DailyLogService _dailyLogService = DailyLogService();
  DailyLogModelResponse? _currentLog;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDailyLog();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  // 날짜를 yyyy-MM-dd 형식으로 포맷
  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // 일지 불러오기
  Future<void> _loadDailyLog() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final dateStr = _formatDate(_selectedDate);
      final log = await _dailyLogService.getDailyLogByDate(dateStr);
      
      setState(() {
        _currentLog = log;
        _memoController.text = log?.memo ?? '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('일지를 불러오는 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  // 일지 생성 또는 가져오기
  Future<void> _getOrCreateLog() async {
    if (_currentLog != null) return;

    try {
      setState(() {
        _isLoading = true;
      });

      final dateStr = _formatDate(_selectedDate);
      final request = CreateDailyLogRequest(
        date: dateStr,
        memo: _memoController.text.isEmpty ? null : _memoController.text,
      );
      
      final log = await _dailyLogService.createDailyLog(request);
      
      setState(() {
        _currentLog = log;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('새 일지가 생성되었습니다')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('일지 생성 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  // 메모 저장
  Future<void> _saveMemo() async {
    if (_currentLog == null) {
      await _getOrCreateLog();
      return;
    }

    try {
      final request = UpdateDailyLogRequest(memo: _memoController.text);
      await _dailyLogService.updateDailyLog(_currentLog!.logId, request);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('메모가 저장되었습니다')),
        );
      }
      await _loadDailyLog();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('메모 저장 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  // 운동 기록 삭제
  Future<void> _deleteExercise(int logExerciseId) async {
    try {
      await _dailyLogService.deleteLogExercise(logExerciseId);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('운동이 삭제되었습니다')),
        );
      }
      await _loadDailyLog();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('운동 삭제 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  // 운동 기록 수정 다이얼로그
  void _showEditExerciseDialog(LogExercise logExercise) {
    String intensity = logExercise.intensity;
    final TextEditingController timeController = 
        TextEditingController(text: logExercise.exerciseTime.toString());

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.edit, color: Colors.blue.shade700, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  logExercise.exercise.title,
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
                await _updateExercise(logExercise.logExerciseId, intensity, exerciseTime);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('저장'),
            ),
          ],
        ),
      ),
    );
  }

  // 운동 기록 수정
  Future<void> _updateExercise(int logExerciseId, String intensity, int exerciseTime) async {
    try {
      final request = UpdateLogExerciseRequest(
        intensity: intensity,
        exerciseTime: exerciseTime,
      );

      await _dailyLogService.updateLogExercise(logExerciseId, request);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('운동이 수정되었습니다')),
        );
      }
      await _loadDailyLog();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('운동 수정 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  // AI 분석 실행
  Future<void> _analyzeWorkout() async {
    if (_currentLog == null || _currentLog!.exercises.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('분석할 운동이 없습니다'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    try {
      // 로딩 다이얼로그 표시
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('AI 분석 중...'),
                ],
              ),
            ),
          ),
        ),
      );

      // AI 분석 요청
      final analysis = await _dailyLogService.analyzeWorkoutLog(_currentLog!);

      // 로딩 다이얼로그 닫기
      if (mounted) Navigator.pop(context);

      // 분석 결과 화면으로 이동
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutAnalysisScreen(
              analysis: analysis,
              date: _formatDate(_selectedDate),
            ),
          ),
        );
      }

      // 실패한 경우 에러 메시지
      if (!analysis.success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('AI 분석 실패: ${analysis.message ?? "알 수 없는 오류"}'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      // 로딩 다이얼로그 닫기
      if (mounted) Navigator.pop(context);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('분석 중 오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: '운동 일지',
        automaticallyImplyLeading: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                '운동일지',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              // 주간 달력
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TableCalendar(
                  firstDay: DateTime(2020),
                  lastDay: DateTime(2030),
                  focusedDay: _focusedDate,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDate, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDate = selectedDay;
                      _focusedDate = focusedDay;
                    });
                    _loadDailyLog();
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDate = focusedDay;
                  },
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    selectedDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.blue.shade200,
                      shape: BoxShape.circle,
                    ),
                    weekendTextStyle: TextStyle(
                      color: Colors.red.shade400,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: true,
                    titleCentered: true,
                    formatButtonShowsNext: false,
                    formatButtonDecoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    formatButtonTextStyle: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekendStyle: TextStyle(
                      color: Colors.red.shade400,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // 선택된 날짜 정보
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.blue.shade700),
                        const SizedBox(width: 10),
                        Text(
                          '${_selectedDate.year}년 ${_selectedDate.month}월 ${_selectedDate.day}일',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    if (_currentLog != null)
                      Text(
                        '총 ${_currentLog!.exercises.length}개 운동',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade700,
                        ),
                      ),
                  ],
                ),
              ),
              
              const SizedBox(height: 15),

              // 메모 섹션 - 컴팩트 버전
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.edit_note, size: 18, color: Colors.blue.shade700),
                            const SizedBox(width: 6),
                            Text(
                              '메모',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: _saveMemo,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text('저장', style: TextStyle(fontSize: 13)),
                        ),
                      ],
                    ),
                    TextField(
                      controller: _memoController,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: '오늘의 운동 메모...',
                        hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(top: 4),
                        isDense: true,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // 운동 목록 헤더
              if (_currentLog != null && _currentLog!.exercises.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Icon(Icons.fitness_center, size: 18, color: Colors.blue.shade700),
                            const SizedBox(width: 6),
                            Text(
                              '오늘의 운동',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],),
                          
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/video/search');
                            },
                            child: Text('운동 추가하기', style: TextStyle(fontSize: 13, color: Colors.white),),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // AI 분석 버튼
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _analyzeWorkout,
                          icon: Icon(Icons.psychology, size: 18, color: Colors.white),
                          label: Text('AI 분석하기', style: TextStyle(fontSize: 14, color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple.shade600,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // 운동 목록
              _isLoading
                  ? const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : _currentLog == null || _currentLog!.exercises.isEmpty
                      ? SizedBox(
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.fitness_center,
                                  size: 64,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '운동 기록이 없습니다',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '운동 검색 화면에서 운동을 추가해보세요!',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _currentLog!.exercises.length,
                          itemBuilder: (context, index) {
                            final logExercise = _currentLog!.exercises[index];
                            return _buildExerciseCard(logExercise);
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(LogExercise logExercise) {
    // 강도에 따른 색상
    Color intensityColor;
    switch (logExercise.intensity) {
      case '상':
        intensityColor = Colors.red.shade400;
        break;
      case '중':
        intensityColor = Colors.orange.shade400;
        break;
      case '하':
        intensityColor = Colors.green.shade400;
        break;
      default:
        intensityColor = Colors.grey.shade400;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.5),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // 왼쪽: 강도 표시
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: intensityColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            
            // 중앙: 운동 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoDetailScreen(exercise: logExercise.exercise),
                        ),
                      );
                    },
                    child: Text(
                      logExercise.exercise.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: intensityColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '강도 ${logExercise.intensity}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: intensityColor.withOpacity(0.9),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.timer_outlined, size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 3),
                      Text(
                        '${logExercise.exerciseTime}분',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (logExercise.exercise.muscleName != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      logExercise.exercise.muscleName!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 70),
            // 오른쪽: 액션 버튼
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () => _showEditExerciseDialog(logExercise),
                    icon: Icon(Icons.edit_outlined, size: 18, color: Colors.blue.shade700),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: const Text('운동 삭제'),
                          content: const Text('이 운동을 삭제하시겠습니까?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('취소'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('삭제'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        await _deleteExercise(logExercise.logExerciseId);
                      }
                    },
                    icon: Icon(Icons.delete_outline, size: 18, color: Colors.red.shade700),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
