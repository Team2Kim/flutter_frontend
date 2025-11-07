import 'package:flutter/material.dart';
import 'package:gukminexdiary/model/workout_analysis_model.dart';
import 'package:gukminexdiary/widget/custom_appbar.dart';

class WeeklyPatternAnalysisScreen extends StatefulWidget {
  final WeeklyPatternResponse weeklyPatternResponse;
  final String weekRange; // 예: "2024-01-01 ~ 2024-01-07"

  const WeeklyPatternAnalysisScreen({
    super.key,
    required this.weeklyPatternResponse,
    required this.weekRange,
  });

  @override
  State<WeeklyPatternAnalysisScreen> createState() => _WeeklyPatternAnalysisScreenState();
}

class _WeeklyPatternAnalysisScreenState extends State<WeeklyPatternAnalysisScreen> with TickerProviderStateMixin {
  // 섹션 접기/펼치기 상태 (기본적으로 모두 펼쳐져 있음)
  Map<String, bool> _isSectionExpanded = {};
  
  // 애니메이션 관련 상태
  double _patternAnalysisOpacity = 0.0;
  double _recommendedRoutineOpacity = 0.0;
  double _recoveryGuidanceOpacity = 0.0;
  double _encouragementOpacity = 0.0;
  
  @override
  void initState() {
    super.initState();
    // 화면이 나타난 후 애니메이션 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimations();
    });
  }
  
  void _startAnimations() {
    final pattern = widget.weeklyPatternResponse.aiPattern;
    if (pattern == null) return;
    
    // 각 섹션을 순차적으로 나타나게 함
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && pattern.patternAnalysis != null) {
        setState(() => _patternAnalysisOpacity = 1.0);
      }
    });
    
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && pattern.recommendedRoutine != null) {
        setState(() => _recommendedRoutineOpacity = 1.0);
      }
    });
    
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && pattern.recoveryGuidance != null) {
        setState(() => _recoveryGuidanceOpacity = 1.0);
      }
    });
    
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted && pattern.encouragement != null) {
        setState(() => _encouragementOpacity = 1.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pattern = widget.weeklyPatternResponse.aiPattern;
    
    return Scaffold(
      appBar: const CustomAppbar(
        title: '주간 패턴 분석',
        automaticallyImplyLeading: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.white, const Color.fromARGB(255, 245, 255, 246)],
            radius: 0.7,
            stops: const [0.3, 0.7],
          ),
        ),
        child: pattern == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      widget.weeklyPatternResponse.message ?? '분석 결과를 불러올 수 없습니다',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 주간 정보 카드
                  _buildWeekInfoCard(),
                  const SizedBox(height: 20),
                  // 분석 내용
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: _buildDetailedWeeklyAnalysis(pattern),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
      ),
    );
  }

  Widget _buildWeekInfoCard() {
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.weekRange,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                  ),
                ),
                if (widget.weeklyPatternResponse.recordsAnalyzed != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${widget.weeklyPatternResponse.recordsAnalyzed}일의 운동 기록 분석',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 주간 분석 상세 내용 구성
  Widget _buildDetailedWeeklyAnalysis(WeeklyPattern pattern) {
    final metrics = widget.weeklyPatternResponse.metricsSummary;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 주간 통계 요약 (기본 분석 형태)
        if (metrics != null) ...[
          _buildMetricsSummary(metrics),
          const SizedBox(height: 20),
        ],
        
        // 패턴 분석 - 일관성
        if (pattern.patternAnalysis?.consistency != null)
          AnimatedOpacity(
            opacity: _patternAnalysisOpacity,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            child: _buildAISection(
              '일관성',
              pattern.patternAnalysis!.consistency!,
              Icons.trending_up,
              Colors.purple,
            ),
          ),

        const SizedBox(height: 5),

        // 패턴 분석 - 강도 추세
        if (pattern.patternAnalysis?.intensityTrend != null)
          AnimatedOpacity(
            opacity: _patternAnalysisOpacity,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            child: _buildAISection(
              '강도 추세',
              pattern.patternAnalysis!.intensityTrend!,
              Icons.show_chart,
              Colors.blue,
            ),
          ),

        const SizedBox(height: 5),

        // 과로근/미활용근
        if (pattern.patternAnalysis?.muscleBalance != null &&
            ((pattern.patternAnalysis!.muscleBalance!.overworked != null &&
                pattern.patternAnalysis!.muscleBalance!.overworked!.isNotEmpty) ||
             (pattern.patternAnalysis!.muscleBalance!.underworked != null &&
                pattern.patternAnalysis!.muscleBalance!.underworked!.isNotEmpty)))
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white60,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '과로근',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (pattern.patternAnalysis!.muscleBalance!.overworked != null &&
                          pattern.patternAnalysis!.muscleBalance!.overworked!.isNotEmpty)
                        Wrap(
                          children: [
                            for (var muscle in pattern.patternAnalysis!.muscleBalance!.overworked!) ...[
                              Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.only(right: 5, bottom: 5),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(muscle),
                              ),
                            ]
                          ],
                        )
                      else
                        Text(
                          '없음',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white60,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '미활용근',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (pattern.patternAnalysis!.muscleBalance!.underworked != null &&
                          pattern.patternAnalysis!.muscleBalance!.underworked!.isNotEmpty)
                        Wrap(
                          children: [
                            for (var muscle in pattern.patternAnalysis!.muscleBalance!.underworked!) ...[
                              Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.only(right: 5, bottom: 5),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(muscle),
                              )
                            ]
                          ],
                        )
                      else
                        Text(
                          '없음',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),

        const SizedBox(height: 5),

        // 패턴 분석 - 근육 균형 코멘트
        if (pattern.patternAnalysis?.muscleBalance?.comments != null)
          AnimatedOpacity(
            opacity: _patternAnalysisOpacity,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            child: _buildAISection(
              '근육 균형',
              pattern.patternAnalysis!.muscleBalance!.comments!,
              Icons.balance,
              Colors.orange,
            ),
          ),

        const SizedBox(height: 5),

        // 패턴 분석 - 습관 관찰
        if (pattern.patternAnalysis?.habitObservation != null)
          AnimatedOpacity(
            opacity: _patternAnalysisOpacity,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            child: _buildAISection(
              '습관 관찰',
              pattern.patternAnalysis!.habitObservation!,
              Icons.visibility_outlined,
              Colors.teal,
            ),
          ),

        const SizedBox(height: 5),

        // 추천 루틴 - 주간 개요
        if (pattern.recommendedRoutine?.weeklyOverview != null &&
            pattern.recommendedRoutine!.weeklyOverview!.isNotEmpty)
          AnimatedOpacity(
            opacity: _recommendedRoutineOpacity,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            child: _buildListSection(
              '주간 개요',
              pattern.recommendedRoutine!.weeklyOverview!,
              Icons.calendar_view_week,
              Colors.orange,
            ),
          ),

        const SizedBox(height: 5),

        // 추천 루틴 - 일별 상세
        if (pattern.recommendedRoutine?.dailyDetails != null &&
            pattern.recommendedRoutine!.dailyDetails!.isNotEmpty)
          ...pattern.recommendedRoutine!.dailyDetails!.map((detail) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: AnimatedOpacity(
                opacity: _recommendedRoutineOpacity,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                child: _buildDailyDetailSection(detail),
              ),
            );
          }),

        const SizedBox(height: 5),

        // 추천 루틴 - 진행 전략
        if (pattern.recommendedRoutine?.progressionStrategy != null)
          AnimatedOpacity(
            opacity: _recommendedRoutineOpacity,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            child: _buildAISection(
              '진행 전략',
              pattern.recommendedRoutine!.progressionStrategy!,
              Icons.timeline,
              Colors.orange,
            ),
          ),

        const SizedBox(height: 5),

        // 회복 가이드
        if (pattern.recoveryGuidance != null)
          AnimatedOpacity(
            opacity: _recoveryGuidanceOpacity,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            child: _buildAISection(
              '회복 가이드',
              pattern.recoveryGuidance!,
              Icons.healing,
              Colors.teal,
            ),
          ),

        const SizedBox(height: 5),

        // 격려 메시지
        if (pattern.encouragement != null)
          AnimatedOpacity(
            opacity: _encouragementOpacity,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            child: _buildAISection(
              '격려 메시지',
              pattern.encouragement!,
              Icons.favorite,
              Colors.pink,
            ),
          ),

        const SizedBox(height: 5),

        // 다음 타겟 근육
        if (pattern.nextTargetMuscles != null && pattern.nextTargetMuscles!.isNotEmpty)
          _buildNextTargetMusclesSection(pattern.nextTargetMuscles!),
      ],
    );
  }

  Widget _buildAISection(String title, String content, IconData icon, Color color) {
    final isExpanded = _isSectionExpanded[title] ?? true;
    final ScrollController scrollController = ScrollController();
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
                          constraints: const BoxConstraints(minHeight: 100, maxHeight: 300),
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
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildListSection(String title, List<String> items, IconData icon, Color color) {
    final isExpanded = _isSectionExpanded[title] ?? true;
    final ScrollController scrollController = ScrollController();
    final content = items.map((item) => '• $item').join('\n');
    
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
                          constraints: const BoxConstraints(minHeight: 100, maxHeight: 300),
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
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildDailyDetailSection(DailyDetail detail) {
    final title = 'Day ${detail.day ?? ""}${detail.focus != null ? " - ${detail.focus!}" : ""}';
    final isExpanded = _isSectionExpanded[title] ?? true;
    final ScrollController scrollController = ScrollController();
    
    // 일별 상세 내용 구성
    String content = '';
    if (detail.exercises != null && detail.exercises!.isNotEmpty) {
      for (var exercise in detail.exercises!) {
        content += '• ${exercise.name ?? ""}';
        if (exercise.sets != null) content += ' (${exercise.sets}세트)';
        if (exercise.reps != null) content += ' ${exercise.reps}회';
        if (exercise.rest != null) content += ' 휴식: ${exercise.rest}';
        content += '\n';
        if (exercise.notes != null && exercise.notes!.isNotEmpty) {
          content += '  ${exercise.notes!}\n';
        }
      }
    }
    if (detail.estimatedDuration != null) {
      content += '\n예상 소요 시간: ${detail.estimatedDuration}';
    }
    
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
                Icon(Icons.fitness_center, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
                Icon(
                  isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Colors.orange,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: isExpanded && content.isNotEmpty
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
                          constraints: const BoxConstraints(minHeight: 100, maxHeight: 300),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange.withOpacity(0.2)),
                          ),
                          child: SelectableText(
                            content.trim(),
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.6,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }


  Widget _buildNextTargetMusclesSection(List<String> nextTargetMuscles) {
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
          const Row(
            children: [
              Icon(Icons.fitness_center, color: Colors.blue, size: 20),
              SizedBox(width: 8),
              Text(
                '다음 타겟 근육',
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
            children: nextTargetMuscles.map((muscle) {
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
        ],
      ),
    );
  }

  // 주간 통계 요약 (기본 분석 형태)
  Widget _buildMetricsSummary(WeeklyMetricsSummary metrics) {
    // 강도 분포 계산 (백분율)
    final totalIntensity = metrics.intensityCounts.values.fold<int>(0, (sum, count) => sum + count);
    final intensityPercentage = <String, double>{};
    if (totalIntensity > 0) {
      metrics.intensityCounts.forEach((key, value) {
        intensityPercentage[key] = (value / totalIntensity * 100);
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 통계 카드들
        Row(
          children: [
            Expanded(child:
            _buildStatCard('주간 운동 횟수', '${metrics.weeklyWorkoutCount}회', Icons.fitness_center),
            ),
            SizedBox(width: 10),
            Expanded(child:
            _buildStatCard('휴식일', '${7-metrics.restDays}일', Icons.restaurant),
            ),
            SizedBox(width: 10),
            Expanded(child:
            _buildStatCard('총 운동 시간', '${metrics.totalMinutes}분', Icons.timer),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 강도 분포
        if (intensityPercentage.isNotEmpty)
          _buildSection('강도 분포', [
            ...intensityPercentage.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('${entry.key}강도: ${entry.value.toStringAsFixed(1)}% (${metrics.intensityCounts[entry.key] ?? 0}회)'),
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

        // 부위별 분포
        if (metrics.bodyPartCounts.isNotEmpty)
          _buildSection('부위별 운동 분포', [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: metrics.bodyPartCounts.entries.map((entry) {
                return Chip(
                  label: Text('${entry.key}: ${entry.value}회'),
                  labelStyle: const TextStyle(fontSize: 12),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  backgroundColor: Colors.green.shade50,
                );
              }).toList(),
            ),
          ], Icons.category),

        const SizedBox(height: 16),

        // 상위 근육
        if (metrics.topMuscles.isNotEmpty)
          _buildSection('자주 운동한 근육', [
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: metrics.topMuscles.map((muscle) {
                return Chip(
                  label: Text('${muscle.name} (${muscle.count}회)'),
                  labelStyle: const TextStyle(fontSize: 12),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  backgroundColor: Colors.blue.shade50,
                );
              }).toList(),
            ),
          ], Icons.fitness_center),
      ],
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
    return Container(
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

