import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gukminexdiary/model/workout_analysis_model.dart';
import 'package:gukminexdiary/widget/custom_appbar.dart';

class WorkoutAnalysisScreen extends StatelessWidget {
  final WorkoutAnalysisResponse analysis;
  final String date;

  const WorkoutAnalysisScreen({
    super.key,
    required this.analysis,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: '운동 분석 결과',
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 날짜 정보
            _buildDateInfo(),
            const SizedBox(height: 20),

            // AI 분석 결과
            if (analysis.success && analysis.aiAnalysis != null) ...[
              _buildAIAnalysis(),
              const SizedBox(height: 20),
            ],

            // 기본 통계
            if (analysis.basicAnalysis != null) ...[
              _buildBasicAnalysis(context),
              const SizedBox(height: 20),
            ],

            // 오류 메시지
            if (!analysis.success && analysis.message != null)
              _buildErrorMessage(),
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
            date,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade700,
            ),
          ),
          if (analysis.model != null) ...[
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '모델: ${analysis.model}',
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
    final ScrollController _scrollController = ScrollController();
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade50, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology, color: Colors.purple.shade700, size: 22),
              const SizedBox(width: 8),
              Text(
                'AI 분석 결과',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              child: Container(
                height: 400,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purple.shade100),
                ),
                child: SelectableText(
                  analysis.aiAnalysis!,
                  style: const TextStyle(fontSize: 14, height: 1.6),
                ),
              ),
            )
          )
        ],
      ),
    );
  }

  Widget _buildBasicAnalysis(BuildContext context) {
    final stats = analysis.basicAnalysis!.statistics;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
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
    return Expanded(
      child: Container(
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
              '오류: ${analysis.message}',
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

