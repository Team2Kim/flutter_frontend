import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gukminexdiary/model/workout_analysis_model.dart';
import 'package:gukminexdiary/model/exercise_model.dart';
import 'package:gukminexdiary/widget/custom_appbar.dart';
import 'package:gukminexdiary/provider/exercise_provider.dart';
import 'package:gukminexdiary/widget/video_card.dart';
import 'package:gukminexdiary/services/dailylog_service.dart';
import 'package:gukminexdiary/services/exercise_service.dart';
import 'package:gukminexdiary/services/user_service.dart';
import 'package:gukminexdiary/model/user_profile_model.dart';
import 'package:gukminexdiary/widget/pulsing_loading_message.dart';
import 'package:provider/provider.dart';

class WorkoutAnalysisScreen extends StatefulWidget {
  final WorkoutAnalysisResponse? analysis;
  final AIFeedback? feedback;
  final String date;
  final int? logId; // 다시 생성하기 위해 필요

  const WorkoutAnalysisScreen({
    super.key,
    this.analysis,
    this.feedback,
    required this.date,
    this.logId,
  });

  @override
  State<WorkoutAnalysisScreen> createState() => _WorkoutAnalysisScreenState();
}

class _WorkoutAnalysisScreenState extends State<WorkoutAnalysisScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final DailyLogService _dailyLogService = DailyLogService();
  final UserService _userService = UserService();
  UserProfile? _userProfile;
  WorkoutAnalysisResponse? _currentAnalysis;
  bool _isRegenerating = false;
  
  // 다음 타겟 근육 운동 목록 관련 상태
  Map<String, bool> _isVideoListExpanded = {}; // 각 근육 목록의 펼침 상태
  Map<String, bool> _isVideoLoading = {}; // 각 근육 목록의 로딩 상태
  Map<String, int> _currentPageMap = {}; // 각 근육 목록의 현재 페이지
  Map<String, bool> _hasMoreData = {}; // 각 근육 목록의 추가 데이터 존재 여부
  Map<String, ScrollController> _scrollControllers = {}; // 각 근육 목록의 스크롤 컨트롤러
  List<String> _selectedMuscles = []; // 근육 목록
  static const int _pageSize = 10; // 한 번에 가져올 데이터 개수
  
  // 추천 운동 (ID 기반) 데이터
  Map<String, List<int>>? _nextExerciseMap;
  String? _selectedExerciseMuscle;
  Map<int, ExerciseModelResponse>? _nextExercisesCache;
  bool _isNextExercisesLoading = false;
  String? _nextExercisesError;
  
  // 섹션 접기/펼치기 상태 (기본적으로 모두 펼쳐져 있음)
  Map<String, bool> _isSectionExpanded = {
    '운동 평가': true,
    '타겟 근육 분석': true,
    '추천 사항': true,
    '추천 운동 영상': true,
    '격려 메시지': true,
  };
  
  // 애니메이션 관련 상태
  double _workoutEvaluationOpacity = 0.0;
  double _targetMusclesOpacity = 0.0;
  double _recommendationsOpacity = 0.0;
  double _nextTargetMusclesOpacity = 0.0;
  double _nextTargetExercisesOpacity = 0.0;
  double _encouragementOpacity = 0.0;
  
  @override
  void initState() {
    super.initState();
    // analysis 또는 feedback에서 WorkoutAnalysisResponse 생성
    _currentAnalysis = _getAnalysis();
    _loadNextTargetExercises(_currentAnalysis?.aiAnalysis);
    // 화면이 나타난 후 애니메이션 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimations();
    });
  }
  
  // analysis 또는 feedback에서 WorkoutAnalysisResponse 생성
  WorkoutAnalysisResponse? _getAnalysis() {
    if (widget.analysis != null) {
      return widget.analysis;
    } else if (widget.feedback != null) {
      // AIFeedback을 WorkoutAnalysisResponse로 변환
      final aiAnalysis = AIAnalysis(
        workoutEvaluation: widget.feedback!.workoutEvaluation,
        targetMuscles: widget.feedback!.targetMuscles,
        recommendations: widget.feedback!.recommendations,
        nextTargetMuscles: widget.feedback!.nextTargetMuscles,
        encouragement: widget.feedback!.encouragement,
      );
      return WorkoutAnalysisResponse(
        success: true,
        aiAnalysis: aiAnalysis,
      );
    }
    return null;
  }
  
  @override
  void dispose() {
    // 모든 ScrollController 정리
    for (var controller in _scrollControllers.values) {
      controller.dispose();
    }
    _scrollControllers.clear();
    _pageController.dispose();
    super.dispose();
  }
  
  void _startAnimations() {
    final analysis = _currentAnalysis;
    if (analysis == null) return;
    
    // 각 섹션을 순차적으로 나타나게 함
    // 운동 평가 -> 타겟 근육 분석 -> 추천 사항 -> 다음 타겟 근육 -> 추천 운동 영상 -> 격려 메시지
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && analysis.aiAnalysis?.workoutEvaluation != null) {
        setState(() => _workoutEvaluationOpacity = 1.0);
      }
    });
    
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && analysis.aiAnalysis?.targetMuscles != null) {
        setState(() => _targetMusclesOpacity = 1.0);
      }
    });
    
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && analysis.aiAnalysis?.recommendations != null) {
        setState(() => _recommendationsOpacity = 1.0);
      }
    });
    
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted && analysis.aiAnalysis?.nextTargetMuscles != null && 
          analysis.aiAnalysis!.nextTargetMuscles!.isNotEmpty) {
        setState(() => _nextTargetMusclesOpacity = 1.0);
      }
    });
    
    Future.delayed(const Duration(milliseconds: 850), () {
      if (mounted && analysis.aiAnalysis?.nextTargetExercises != null &&
          analysis.aiAnalysis!.nextTargetExercises!.isNotEmpty) {
        setState(() => _nextTargetExercisesOpacity = 1.0);
      }
    });
    
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted && analysis.aiAnalysis?.encouragement != null) {
        setState(() => _encouragementOpacity = 1.0);
      }
    });
  }
  
  // 분석지 다시 생성하기
  Future<void> _regenerateAnalysis() async {
    if (widget.logId == null) return;
    
    setState(() {
      _isRegenerating = true;
    });
    
    try {
      // 로딩 다이얼로그 표시
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, const Color.fromRGBO(241, 248, 255, 1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.3, 0.7],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(color: Color.fromARGB(255, 143, 199, 255),),
                SizedBox(height: 16),
                PulsingLoadingMessage(message: 'AI 분석 중...'),
              ],
            ),
          ),
        ),
      );
      
      // 일지 가져오기
      final log = await _dailyLogService.getDailyLogByDate(widget.date);
      if (log == null) {
        if (mounted) Navigator.pop(context);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('일지를 찾을 수 없습니다')),
          );
        }
        return;
      }
      
      final profile = await _ensureUserProfile();

      // AI 분석 요청
      final analysis = await _dailyLogService.analyzeWorkoutLog(
        log,
        targetGroup: profile?.targetGroup,
        fitnessLevelName: profile?.fitnessLevelName,
        fitnessFactorName: profile?.fitnessFactorName,
      );
      
      // 로딩 다이얼로그 닫기
      if (mounted) Navigator.pop(context);
      
      // 분석 성공 시 피드백 저장
      if (analysis.success && analysis.aiAnalysis != null) {
        try {
          final feedback = AIFeedback.fromAIAnalysis(analysis.aiAnalysis!);
          await _dailyLogService.saveAIFeedback(log.logId, feedback);
        } catch (e) {
          print('피드백 저장 실패: $e');
        }
      }
      
      // 분석 결과로 업데이트
      setState(() {
        _currentAnalysis = analysis;
        _isRegenerating = false;
        // 애니메이션 재시작
        _workoutEvaluationOpacity = 0.0;
        _targetMusclesOpacity = 0.0;
        _recommendationsOpacity = 0.0;
        _nextTargetMusclesOpacity = 0.0;
        _nextTargetExercisesOpacity = 0.0;
        _encouragementOpacity = 0.0;
      });
      
      _loadNextTargetExercises(analysis.aiAnalysis);
      _startAnimations();
      
      if (!analysis.success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('AI 분석 실패: ${analysis.message ?? "알 수 없는 오류"}'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      setState(() {
        _isRegenerating = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('분석 중 오류가 발생했습니다'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _loadNextTargetExercises(AIAnalysis? analysis) {
    final exerciseMap = analysis?.nextTargetExercises;
    if (exerciseMap == null || exerciseMap.isEmpty) {
      setState(() {
        _nextExerciseMap = null;
        _selectedExerciseMuscle = null;
        _nextExercisesCache = null;
        _isNextExercisesLoading = false;
        _nextExercisesError = null;
      });
      return;
    }

    final firstMuscle = exerciseMap.keys.first;
    setState(() {
      _nextExerciseMap = Map.from(exerciseMap);
      _selectedExerciseMuscle = firstMuscle;
      _nextExercisesCache = null;
      _isNextExercisesLoading = true;
      _nextExercisesError = null;
    });

    _fetchNextExercisesForMuscle(firstMuscle);
  }

  void _fetchNextExercisesForMuscle(String muscle) {
    final ids = _nextExerciseMap?[muscle];
    if (ids == null || ids.isEmpty) {
      setState(() {
        _nextExercisesCache = {};
        _nextExercisesError = null;
        _isNextExercisesLoading = false;
      });
      return;
    }

    setState(() {
      _selectedExerciseMuscle = muscle;
      _isNextExercisesLoading = true;
      _nextExercisesError = null;
    });

    ExerciseService().getExercisesByIds(ids).then((exercises) {
      if (!mounted) return;
      if (_selectedExerciseMuscle != muscle) return;
      setState(() {
        _nextExercisesCache = {
          for (final exercise in exercises) exercise.exerciseId: exercise
        };
        _isNextExercisesLoading = false;
      });
    }).catchError((error) {
      if (!mounted) return;
      if (_selectedExerciseMuscle != muscle) return;
      setState(() {
        _nextExercisesCache = {};
        _isNextExercisesLoading = false;
        _nextExercisesError = error.toString();
      });
      debugPrint('추천 운동 정보 로드 실패: $error');
    });
  }

  Future<UserProfile?> _ensureUserProfile() async {
    if (_userProfile != null) return _userProfile;
    try {
      final profile = await _userService.fetchProfile();
      _userProfile = profile;
      return profile;
    } catch (e) {
      debugPrint('사용자 프로필 로드 실패: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'AI 일지 분석 결과',
        automaticallyImplyLeading: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.white, const Color.fromRGBO(241, 248, 255, 1)],
            radius: 0.7,
            stops: const [0.3, 0.7],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 날짜 정보
            _buildDateInfo(),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: 
                Container(
                  decoration: BoxDecoration(
                    border: _currentPage == 0 ? Border(
                      left: BorderSide(color: Colors.blue.shade100),
                        top: BorderSide(color: Colors.blue.shade100),
                        bottom: BorderSide(color: Colors.blue.shade100),
                      ) : Border.all(color: Colors.blue.shade50),
                    gradient: LinearGradient(
                      colors: _currentPage == 0 ? [Colors.blue.shade50, Colors.white] : [Colors.white, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.33, 0.66],
                    ),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                  ),
                  child: TextButton(
                    onPressed: () {
                      _pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                    }, child: Text('AI 분석 결과', style: TextStyle(color: Colors.black),))),
                ),
                Expanded(child: Container(
                  decoration: BoxDecoration(
                    border: _currentPage == 1 ? Border(
                      right: BorderSide(color: Colors.blue.shade100),
                      top: BorderSide(color: Colors.blue.shade100),
                      bottom: BorderSide(color: Colors.blue.shade100),
                    ) : Border.all(color: Colors.blue.shade50),
                    gradient: LinearGradient(
                      colors: _currentPage == 1 ? [Colors.white, Colors.blue.shade50] : [Colors.white, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: const [0.33, 0.66],
                    ),  
                    borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                  ),
                  child: TextButton(
                    onPressed: () {
                      _pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                    }, child: Text('기본 통계', style: TextStyle(color: Colors.black),))),
                ),
              ],),
            const SizedBox(height: 10),
            // AI 분석 결과
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                if (_currentAnalysis != null && _currentAnalysis!.success && _currentAnalysis!.aiAnalysis != null) ...[
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: SingleChildScrollView(child: _buildAIAnalysis()),
                  ),
                ],
                if (_currentAnalysis != null && _currentAnalysis!.basicAnalysis != null) ...[
                  SingleChildScrollView(child: _buildBasicAnalysis(context)),
                ],
              ],),
            ),
          //SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDateInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: Colors.blue.shade700, size: 20),
          const SizedBox(width: 10),
          Text(
            widget.date,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade700,
            ),
          ),
          // if (_currentAnalysis?.model != null) ...[
          //   const Spacer(),
          //   Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          //     decoration: BoxDecoration(
          //       color: Colors.blue.shade100,
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //     child: Text(
          //       '모델: ${_currentAnalysis!.model}',
          //       style: TextStyle(
          //         fontSize: 12,
          //         color: Colors.blue.shade700,
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //   ),
          // ],
          // 저장된 피드백인 경우 다시 생성하기 버튼 표시
          if (widget.feedback != null && widget.logId != null) ...[
            const Spacer(),
            InkWell(
              onTap: _isRegenerating ? null : _regenerateAnalysis,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color.fromARGB(255, 249, 227, 253), Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: Colors.purple.shade100),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.refresh, size: 18, color: Colors.purple.shade700),
                    const SizedBox(width: 8),
                    Text('다시 생성하기', style: TextStyle(fontSize: 13, color: Colors.purple.shade700),), 
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAIAnalysis() {
    final analysis = _currentAnalysis;
    if (analysis == null || analysis.aiAnalysis == null) {
      return const Center(child: Text('분석 데이터가 없습니다'));
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 운동 평가
        if (analysis.aiAnalysis!.workoutEvaluation != null)
          AnimatedOpacity(
            opacity: _workoutEvaluationOpacity,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            child: _buildAISection(
              '운동 평가',
              analysis.aiAnalysis!.workoutEvaluation!,
              Icons.assessment,
              Colors.purple,
            ),
          ),

        const SizedBox(height: 5),

        // 타겟 근육
        if (analysis.aiAnalysis!.targetMuscles != null)
          AnimatedOpacity(
            opacity: _targetMusclesOpacity,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            child: _buildAISection(
              '타겟 근육 분석',
              analysis.aiAnalysis!.targetMuscles!,
              Icons.fitness_center,
              Colors.blue,
            ),
          ),

        const SizedBox(height: 5),

        // 추천 사항
        if (analysis.aiAnalysis!.recommendations != null)
          AnimatedOpacity(
            opacity: _recommendationsOpacity,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            child: _buildAISection(
              '추천 사항',
              _formatRecommendations(analysis.aiAnalysis!.recommendations!),
              Icons.lightbulb_outline,
              Colors.orange,
            ),
          ),

        const SizedBox(height: 5),

        // 추천 운동 (AI가 제안한 exercise_id 목록)
        if (analysis.aiAnalysis!.nextTargetExercises != null &&
            analysis.aiAnalysis!.nextTargetExercises!.isNotEmpty)
          AnimatedOpacity(
            opacity: _nextTargetExercisesOpacity,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            child: _buildNextTargetExercisesSection(),
          ),

        const SizedBox(height: 5),

        // 격려 메시지
        if (analysis.aiAnalysis!.encouragement != null)
          AnimatedOpacity(
            opacity: _encouragementOpacity,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            child: _buildAISection(
              '격려 메시지',
              analysis.aiAnalysis!.encouragement!,
              Icons.favorite,
              Colors.pink,
            ),
          ),
        ],
    );
  }

  String _formatRecommendations(AIRecommendations recommendations) {
    final StringBuffer buffer = StringBuffer();
    if (recommendations.nextWorkout != null) {
      buffer.writeln('${recommendations.nextWorkout}');
    }
    if (recommendations.improvements != null) {
      buffer.writeln('\n${recommendations.improvements}');
    }
    if (recommendations.precautions != null) {
      buffer.writeln('\n주의사항:\n${recommendations.precautions}');
    }
    return buffer.toString();
  }

  Widget _buildAISection(String title, String content, IconData icon, Color color) {
    final isExpanded = _isSectionExpanded[title] ?? true;
    final ScrollController scrollController = ScrollController();
    return 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isSectionExpanded[title] = !isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.transparent),
              ),
              child: Row(
                children: [
                  Icon(icon, color: color, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: color,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Column(
                    children: [
                      const SizedBox(height: 6),
                      Scrollbar(
                        thickness: 10,
                        thumbVisibility: true,
                        trackVisibility: true,
                        controller: scrollController,
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Container(
                            height: 100,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white60,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: color.withOpacity(0.2)),
                            ),
                            child: SelectableText(
                              content,
                              style: const TextStyle(
                                fontSize: 14, 
                                height: 1.6, 
                                color: Colors.black54, 
                                fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      )
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      );
  }

  Widget _buildBasicAnalysis(BuildContext context) {
    final analysis = _currentAnalysis;
    if (analysis == null || analysis.basicAnalysis == null) {
      return const Center(child: Text('기본 통계 데이터가 없습니다'));
    }
    
    final stats = analysis.basicAnalysis!.statistics;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white60,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: Colors.blue.shade700, size: 22),
              const SizedBox(width: 8),
              Text(
                '기본 통계',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 요약
          if (analysis.basicAnalysis!.summary.isNotEmpty)
            _buildSection('요약', [Text(analysis.basicAnalysis!.summary)], null),

          const SizedBox(height: 16),

          // 통계 카드들
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildStatCard('총 운동 수', '${stats.totalExercises}개', Icons.fitness_center),
              _buildStatCard('총 시간', '${stats.totalTime}분', Icons.timer),
              _buildStatCard('평균 시간', '${stats.avgTimePerExercise.toStringAsFixed(1)}분', Icons.access_time),
            ],
          ),

          const SizedBox(height: 16),

          // 강도 분포
          if (stats.intensityPercentage.isNotEmpty)
            _buildSection('강도 분포', [
              ...stats.intensityPercentage.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('${entry.key}강도: ${entry.value.toStringAsFixed(1)}%'),
                      ),
                      Container(
                        width: 100,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: entry.value / 100,
                            child: Container(
                              decoration: BoxDecoration(
                                color: _getIntensityColor(entry.key),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ], Icons.bar_chart),

          const SizedBox(height: 16),

          // 타겟 근육
          if (stats.musclesTargeted.isNotEmpty)
            _buildSection('타겟 근육', [
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: stats.musclesTargeted.map((muscle) {
                  return Chip(
                    label: Text(muscle),
                    labelStyle: const TextStyle(fontSize: 12),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    backgroundColor: Colors.blue.shade50,
                  );
                }).toList(),
              ),
            ], Icons.fitness_center),

          const SizedBox(height: 16),

          // 추천 사항
          if (analysis.basicAnalysis!.recommendations.isNotEmpty)
            _buildRecommendations(
              '추천',
              analysis.basicAnalysis!.recommendations,
              Icons.lightbulb_outline,
              Colors.blue,
            ),

          const SizedBox(height: 12),

          // 경고 사항
          if (analysis.basicAnalysis!.warnings.isNotEmpty)
            _buildRecommendations(
              '주의사항',
              analysis.basicAnalysis!.warnings,
              Icons.warning_amber_outlined,
              Colors.orange,
            ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> content, IconData? icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 6),
                ],
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
        ...content,
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return  Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: Colors.blue.shade700),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      );
  }

  Widget _buildRecommendations(
    String title,
    List<String> items,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('•', style: TextStyle(color: color, fontSize: 16)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // Widget _buildNextTargetMuscles(List<String> muscles) {
  //   // 초기화: 첫 렌더링 시 모든 근육을 선택된 상태로 설정
  //   if (_selectedMuscles.isEmpty) {
  //     _selectedMuscles = List.from(muscles);
  //   }
    
  //   final selectedMusclesKey = _selectedMuscles.join(',');
    
  //   return Container(
  //     padding: const EdgeInsets.all(8),
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [Colors.blue.shade100.withOpacity(0.3), Colors.white],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //       ),
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(color: Colors.blue.withOpacity(0.3)),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Row(
  //           children: [
  //             Icon(Icons.fitness_center, color: Colors.blue, size: 20),
  //             SizedBox(width: 8),
  //             Text(
  //               '다음 훈련 타겟 근육',
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.blue,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 10),
  //         Wrap(
  //           spacing: 2,
  //           runSpacing: 1,
  //           children: muscles.map((muscle) {
  //             return 
  //             TextButton(
  //               style: TextButton.styleFrom(
  //                 padding: EdgeInsets.zero,
  //               ),
  //               onPressed: () {
  //               setState(() {
  //                 // 기존 선택된 근육 키 저장
  //                 final oldSelectedKey = _selectedMuscles.join(',');
                  
  //                 if (_selectedMuscles.contains(muscle)) {
  //                   _selectedMuscles.remove(muscle);
  //                 } else {
  //                   _selectedMuscles.add(muscle);
  //                 }
                  
  //                 // 선택된 근육이 변경되면 기존 상태 초기화
  //                 final newSelectedKey = _selectedMuscles.join(',');
  //                 if (oldSelectedKey != newSelectedKey) {
  //                   _scrollControllers[oldSelectedKey]?.dispose();
  //                   _scrollControllers.remove(oldSelectedKey);
  //                   _currentPageMap.remove(oldSelectedKey);
  //                   _hasMoreData.remove(oldSelectedKey);
  //                   _isVideoListExpanded.remove(oldSelectedKey);
  //                 }
                  
  //                 // 선택된 근육이 있으면 검색 실행
  //                 if (_selectedMuscles.isNotEmpty) {
  //                   _loadExercisesForMuscles(_selectedMuscles, isInitial: true);
  //                 } else {
  //                   // 선택된 근육이 없으면 데이터 초기화
  //                   final exerciseProvider = context.read<ExerciseProvider>();
  //                   exerciseProvider.resetMuscleExercises();
  //                 }
  //               });
  //             }, child: Container(
  //               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //               decoration: BoxDecoration(
  //                 color: _selectedMuscles.contains(muscle) ? Colors.blue.withOpacity(0.1) : Colors.white,
  //                 borderRadius: BorderRadius.circular(20),
  //                 border: Border.all(color: _selectedMuscles.contains(muscle) ? Colors.blue.withOpacity(0.3) : Colors.grey.withOpacity(0.3)),
  //               ),
  //               child: Text(
  //                 muscle,
  //                 style: TextStyle(
  //                   fontSize: 13,
  //                   fontWeight: FontWeight.w600,
  //                   color: _selectedMuscles.contains(muscle) ? Colors.blue.shade800 : Colors.grey.shade800,
  //                 ),
  //               ),
  //             ));
  //           }).toList(),
  //         ),
  //         const SizedBox(height: 12),
  //         // 영상 목록 보기 버튼
  //         ElevatedButton.icon(
  //           onPressed: () async {
  //             if (_selectedMuscles.isEmpty) {
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 const SnackBar(
  //                   content: Text('최소 1개 이상의 근육을 선택해주세요.'),
  //                   backgroundColor: Colors.orange,
  //                 ),
  //               );
  //               return;
  //             }
              
  //             final wasExpanded = _isVideoListExpanded[selectedMusclesKey] ?? false;
  //             setState(() {
  //               _isVideoListExpanded[selectedMusclesKey] = !wasExpanded;
  //             });
              
  //             // 영상 목록을 펼칠 때만 검색 실행 (초기 검색)
  //             if (!wasExpanded) {
  //               // ScrollController 초기화
  //               _scrollControllers[selectedMusclesKey]?.dispose();
  //               _scrollControllers[selectedMusclesKey] = ScrollController();
  //               _scrollControllers[selectedMusclesKey]!.addListener(() {
  //                 _onScroll(selectedMusclesKey, _selectedMuscles);
  //               });
  //               // 페이지 및 상태 초기화
  //               _currentPageMap[selectedMusclesKey] = 0;
  //               _hasMoreData[selectedMusclesKey] = true;
  //               await _loadExercisesForMuscles(_selectedMuscles, isInitial: true);
  //             } else {
  //               // 접을 때 ScrollController 정리
  //               _scrollControllers[selectedMusclesKey]?.dispose();
  //               _scrollControllers.remove(selectedMusclesKey);
  //             }
  //           },
  //           icon: Icon(
  //             (_isVideoListExpanded[selectedMusclesKey] ?? false) == true 
  //               ? Icons.expand_less 
  //               : Icons.expand_more,
  //           ),
  //           label: Text(
  //             (_isVideoListExpanded[selectedMusclesKey] ?? false) == true 
  //               ? '영상 목록 숨기기' 
  //               : '추천 영상 보기',
  //           ),
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Colors.blue.shade50,
  //             foregroundColor: Colors.blue.shade800,
  //             elevation: 0,
  //           ),
  //         ),
  //         // 영상 목록
  //         if ((_isVideoListExpanded[selectedMusclesKey] ?? false) == true && _selectedMuscles.isNotEmpty) ...[
  //           const SizedBox(height: 12),
  //           _buildExerciseList(_selectedMuscles),
  //         ],
  //       ],
  //     ),
  //   );
  // }

  Widget _buildNextTargetExercisesSection() {
    final title = '다음 훈련 추천 근육 및 운동';
    final isExpanded = _isSectionExpanded[title] ?? true;
    final exerciseMap = _nextExerciseMap ?? {};
    final muscles = exerciseMap.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isSectionExpanded[title] = !isExpanded;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.transparent),
            ),
            child: Row(
              children: [
                Icon(Icons.movie_outlined, color: Colors.green.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
                Icon(
                  isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Colors.green.shade700,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: isExpanded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (muscles.isNotEmpty)
                      Wrap(
                        spacing: 2,
                        runSpacing: 0,
                        children: muscles.map((muscle) {
                          final isSelected = muscle == _selectedExerciseMuscle;
                          return TextButton(
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedExerciseMuscle = muscle;
                              });
                              _fetchNextExercisesForMuscle(muscle);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.grey.withOpacity(0.3)),
                              ),
                              child: Text(muscle, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? Colors.blue.shade800 : Colors.grey.shade800),),
                            ),
                          );
                        }).toList(),
                      ),
                    _buildNextTargetExercisesContent(),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildNextTargetExercisesContent() {
    if (_nextExerciseMap == null || _nextExerciseMap!.isEmpty) {
      return _buildEmptyExerciseMessage('추천 운동이 없습니다.');
    }

    if (_nextExercisesError != null) {
      return _buildErrorExerciseMessage(
        '추천 운동을 불러오는 중 오류가 발생했습니다: $_nextExercisesError',
      );
    }

    if (_isNextExercisesLoading || _nextExercisesCache == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final selectedMuscle = _selectedExerciseMuscle;
    if (selectedMuscle == null) {
      return _buildEmptyExerciseMessage('추천 운동이 없습니다.');
    }

    final ids = _nextExerciseMap?[selectedMuscle] ?? [];
    final exercises = ids
        .map((id) => _nextExercisesCache?[id])
        .whereType<ExerciseModelResponse>()
        .toList();

    if (exercises.isEmpty) {
      return _buildEmptyExerciseMessage('추천 운동이 없습니다.');
    }

    return Column(
      children: exercises.map((exercise) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: VideoCard(exercise: exercise),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyExerciseMessage(String message) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildErrorExerciseMessage(String message) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.red,
        ),
      ),
    );
  }

  void _onScroll(String musclesKey, List<String> muscles) {
    final scrollController = _scrollControllers[musclesKey];
    if (scrollController == null) return;
    
    // 최하단에 도달했는지 확인 (스크롤 위치가 최대 스크롤 위치의 80% 이상일 때)
    if (scrollController.position.pixels >= 
        scrollController.position.maxScrollExtent * 0.8) {
      // 더 불러올 데이터가 있고 로딩 중이 아닐 때만 추가 검색
      if ((_hasMoreData[musclesKey] ?? true) && 
          (_isVideoLoading[musclesKey] != true)) {
        _loadExercisesForMuscles(muscles, isInitial: false);
      }
    }
  }

  Future<void> _loadExercisesForMuscles(List<String> muscles, {required bool isInitial}) async {
    // 선택된 근육이 없으면 검색하지 않음
    if (muscles.isEmpty) return;
    
    final musclesKey = muscles.join(',');
    
    // 이미 로딩 중이면 중복 실행 방지
    if (_isVideoLoading[musclesKey] == true) return;
    
    // 추가 검색 시 더 이상 데이터가 없으면 리턴
    if (!isInitial && (_hasMoreData[musclesKey] != true)) return;
    
    setState(() {
      _isVideoLoading[musclesKey] = true;
    });
    
    try {
      final exerciseProvider = context.read<ExerciseProvider>();
      final currentPage = _currentPageMap[musclesKey] ?? 0;
      
      if (isInitial) {
        // 초기 검색: 기존 데이터 초기화
        exerciseProvider.resetMuscleExercises();
        _currentPageMap[musclesKey] = 0;
        _hasMoreData[musclesKey] = true;
      }
      
      // 다음 페이지 검색
      final nextPage = isInitial ? 0 : currentPage + 1;
      final previousCount = exerciseProvider.muscleExercises.length;
      await exerciseProvider.getExercisesByMuscle(muscles, nextPage);
      
      // 반환된 결과 확인
      final exercises = exerciseProvider.muscleExercises;
      final newCount = exercises.length - previousCount;
      
      // ExerciseProvider의 muscleLastPage 상태 확인
      if (exerciseProvider.muscleLastPage) {
        _hasMoreData[musclesKey] = false;
      } else {
        // 반환된 결과가 pageSize보다 적으면 더 이상 데이터가 없음
        if (newCount < _pageSize) {
          _hasMoreData[musclesKey] = false;
        }
      }
      
      // 페이지 업데이트
      _currentPageMap[musclesKey] = nextPage;
      
    } catch (e) {
      print('근육별 운동 검색 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('운동 영상을 불러오는데 실패했습니다'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isVideoLoading[musclesKey] = false;
        });
      }
    }
  }

  Widget _buildExerciseList(List<String> muscles) {
    final musclesKey = muscles.join(',');
    
    return Consumer<ExerciseProvider>(
      builder: (context, exerciseProvider, child) {
        final exercises = exerciseProvider.muscleExercises;
        final isLoading = _isVideoLoading[musclesKey] == true;
        
        // 초기 로딩 중이고 데이터가 없을 때만 전체 로딩 인디케이터 표시
        if (isLoading && exercises.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        // 데이터가 없을 때
        if (exercises.isEmpty) {
          return Container(
            height: 100,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                '해당 근육에 대한 운동 영상을 찾을 수 없습니다.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }
        
        final scrollController = _scrollControllers[musclesKey];
        final hasMore = _hasMoreData[musclesKey] ?? true;
        
        return Container(
          constraints: const BoxConstraints(maxHeight: 400),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            controller: scrollController,
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: exercises.length + (isLoading || hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              // 마지막 아이템이고 로딩 중이거나 더 불러올 데이터가 있으면 로딩 인디케이터 표시
              if (index == exercises.length) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              }
              
              if (index < exercises.length) {
                final exercise = exercises[index];
                return VideoCard(exercise: exercise);
              }
              
              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }


  Color _getIntensityColor(String intensity) {
    switch (intensity) {
      case '상':
        return Colors.red.shade400;
      case '중':
        return Colors.orange.shade400;
      case '하':
        return Colors.green.shade400;
      default:
        return Colors.grey.shade400;
    }
  }
}

