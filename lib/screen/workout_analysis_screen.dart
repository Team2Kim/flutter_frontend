import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gukminexdiary/model/workout_analysis_model.dart';
import 'package:gukminexdiary/widget/custom_appbar.dart';
import 'package:gukminexdiary/provider/exercise_provider.dart';
import 'package:gukminexdiary/widget/video_card_mini.dart';
import 'package:provider/provider.dart';

class WorkoutAnalysisScreen extends StatefulWidget {
  final WorkoutAnalysisResponse analysis;
  final String date;

  const WorkoutAnalysisScreen({
    super.key,
    required this.analysis,
    required this.date,
  });


  @override
  State<WorkoutAnalysisScreen> createState() => _WorkoutAnalysisScreenState();
}

class _WorkoutAnalysisScreenState extends State<WorkoutAnalysisScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // 다음 타겟 근육 운동 목록 관련 상태
  Map<String, bool> _isVideoListExpanded = {}; // 각 근육 목록의 펼침 상태
  Map<String, bool> _isVideoLoading = {}; // 각 근육 목록의 로딩 상태

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
          gradient: LinearGradient(
            colors: [Colors.white, Colors.green.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
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
                    border: Border(
                      left: BorderSide(color: Colors.blue.shade100),
                    ),
                    gradient: LinearGradient(
                      colors: _currentPage == 0 ? [Colors.blue.shade50, Colors.white] : [Colors.white, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.0, 0.5],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton(
                    onPressed: () {
                      _pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                    }, child: Text('AI 분석 결과', style: TextStyle(color: Colors.black),))),
                ),
                Expanded(child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: Colors.blue.shade100),
                    ),
                    gradient: LinearGradient(
                      colors: _currentPage == 1 ? [Colors.white, Colors.blue.shade50] : [Colors.white, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.5, 1.0],
                    ),  
                    borderRadius: BorderRadius.circular(12),
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
                if (widget.analysis.success && widget.analysis.aiAnalysis != null) ...[
                  SingleChildScrollView(child: _buildAIAnalysis()),
                ],
                if (widget.analysis.basicAnalysis != null) ...[
                  SingleChildScrollView(child: _buildBasicAnalysis(context)),
                ],
              ],),
            ),
            
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
          if (widget.analysis.model != null) ...[
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '모델: ${widget.analysis.model}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAIAnalysis() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white60,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 운동 평가
        if (widget.analysis.aiAnalysis!.workoutEvaluation != null)
          _buildAISection(
            '운동 평가',
            widget.analysis.aiAnalysis!.workoutEvaluation!,
            Icons.assessment,
            Colors.purple,
          ),

        const SizedBox(height: 5),

        // 타겟 근육
        if (widget.analysis.aiAnalysis!.targetMuscles != null)
          _buildAISection(
            '타겟 근육 분석',
            widget.analysis.aiAnalysis!.targetMuscles!,
            Icons.fitness_center,
            Colors.blue,
          ),

        const SizedBox(height: 5),

        // 추천 사항
        if (widget.analysis.aiAnalysis!.recommendations != null)
          _buildAISection(
            '추천 사항',
            _formatRecommendations(widget.analysis.aiAnalysis!.recommendations!),
            Icons.lightbulb_outline,
            Colors.orange,
          ),

        const SizedBox(height: 5),

        // 다음 타겟 근육
        if (widget.analysis.aiAnalysis!.nextTargetMuscles != null && widget.analysis.aiAnalysis!.nextTargetMuscles!.isNotEmpty)
          _buildNextTargetMuscles(widget.analysis.aiAnalysis!.nextTargetMuscles!),

        const SizedBox(height: 5),

        // 격려 메시지  
        if (widget.analysis.aiAnalysis!.encouragement != null)
          _buildAISection(
            '격려 메시지',
            widget.analysis.aiAnalysis!.encouragement!,
            Icons.favorite,
              Colors.pink,
            ),
        ],
      ),
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
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            child: Container(
              height: 100,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: SelectableText(
                content,
                style: const TextStyle(fontSize: 14, height: 1.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicAnalysis(BuildContext context) {
    final stats = widget.analysis.basicAnalysis!.statistics;

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
          if (widget.analysis.basicAnalysis!.summary.isNotEmpty)
            _buildSection('요약', [Text(widget.analysis.basicAnalysis!.summary)], null),

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
          if (widget.analysis.basicAnalysis!.recommendations.isNotEmpty)
            _buildRecommendations(
              '추천',
              widget.analysis.basicAnalysis!.recommendations,
              Icons.lightbulb_outline,
              Colors.blue,
            ),

          const SizedBox(height: 12),

          // 경고 사항
          if (widget.analysis.basicAnalysis!.warnings.isNotEmpty)
            _buildRecommendations(
              '주의사항',
              widget.analysis.basicAnalysis!.warnings,
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

  Widget _buildNextTargetMuscles(List<String> muscles) {
    final musclesKey = muscles.join(',');
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade100.withOpacity(0.3), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.fitness_center, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Text(
                '다음 훈련 타겟 근육',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: muscles.map((muscle) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Text(
                  muscle,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade800,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          // 영상 목록 보기 버튼
          ElevatedButton.icon(
            onPressed: () async {
              setState(() {
                _isVideoListExpanded[musclesKey] = !(_isVideoListExpanded[musclesKey] ?? false);
              });
              
              // 영상 목록을 펼칠 때만 검색 실행
              if (_isVideoListExpanded[musclesKey] == true) {
                await _loadExercisesForMuscles(muscles);
              }
            },
            icon: Icon(
              _isVideoListExpanded[musclesKey] == true 
                ? Icons.expand_less 
                : Icons.expand_more,
            ),
            label: Text(
              _isVideoListExpanded[musclesKey] == true 
                ? '영상 목록 숨기기' 
                : '추천 영상 보기',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade50,
              foregroundColor: Colors.blue.shade800,
              elevation: 0,
            ),
          ),
          // 영상 목록
          if (_isVideoListExpanded[musclesKey] == true) ...[
            const SizedBox(height: 12),
            _buildExerciseList(muscles),
          ],
        ],
      ),
    );
  }

  Future<void> _loadExercisesForMuscles(List<String> muscles) async {
    final musclesKey = muscles.join(',');
    
    // 이미 로딩 중이면 중복 실행 방지
    if (_isVideoLoading[musclesKey] == true) return;
    
    setState(() {
      _isVideoLoading[musclesKey] = true;
    });
    
    try {
      final exerciseProvider = context.read<ExerciseProvider>();
      // 근육별 검색을 위해 기존 muscleExercises 초기화하지 않고 별도로 관리
      // 새로운 검색을 위해 reset하고 검색 실행
      exerciseProvider.resetMuscleExercises();
      await exerciseProvider.getExercisesByMuscle(muscles, 0);
    } catch (e) {
      print('근육별 운동 검색 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('운동 영상을 불러오는데 실패했습니다: $e'),
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
        if (_isVideoLoading[musclesKey] == true) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        final exercises = exerciseProvider.muscleExercises;
        
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
        
        return Container(
          constraints: const BoxConstraints(maxHeight: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.withOpacity(0.2)),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final exercise = exercises[index];
              return VideoCardMini(exercise: exercise);
            },
          ),
        );
      },
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '오류: ${widget.analysis.message}',
              style: TextStyle(color: Colors.red.shade700),
            ),
          ),
        ],
      ),
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

