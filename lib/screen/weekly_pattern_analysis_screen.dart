import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gukminexdiary/model/exercise_model.dart';
import 'package:gukminexdiary/model/workout_analysis_model.dart';
import 'package:gukminexdiary/services/exercise_service.dart';
import 'package:gukminexdiary/widget/custom_appbar.dart';
import 'package:gukminexdiary/widget/video_card.dart';

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
  late final PageController _pageController;
  int _currentPage = 0;

  // 애니메이션 관련 상태
  double _patternAnalysisOpacity = 0.0;
  double _recommendedRoutineOpacity = 0.0;
  double _recoveryGuidanceOpacity = 0.0;
  double _encouragementOpacity = 0.0;
  
  // 운동 정보 캐시 (exerciseId -> ExerciseModelResponse)
  Map<int, ExerciseModelResponse>? _exercisesCache;
  Future<List<ExerciseModelResponse>>? _exercisesFuture;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    // 모든 운동 ID를 모아서 한 번에 로드
    _loadAllExercises();
    
    // 화면이 나타난 후 애니메이션 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimations();
    });
  }
  
  void _loadAllExercises() {
    final pattern = widget.weeklyPatternResponse.aiPattern;
    if (pattern?.recommendedRoutine?.dailyDetails == null) {
      return;
    }
    
    // 모든 DailyDetail의 exercises ID를 모음
    final allExerciseIds = <int>{};
    for (final detail in pattern!.recommendedRoutine!.dailyDetails!) {
      if (detail.exercises != null) {
        allExerciseIds.addAll(detail.exercises!);
      }
    }
    
    if (allExerciseIds.isEmpty) {
      return;
    }
    
    // 한 번에 모든 운동 정보를 로드
    _exercisesFuture = ExerciseService().getExercisesByIds(allExerciseIds.toList());
    _exercisesFuture!.then((exercises) {
      if (mounted) {
        setState(() {
          _exercisesCache = {
            for (final exercise in exercises) exercise.exerciseId: exercise
          };
        });
      }
    }).catchError((error) {
      print('운동 정보 로드 오류: $error');
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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pattern = widget.weeklyPatternResponse.aiPattern;
    
    return Scaffold(
      appBar: CustomAppbar(
        title: '주간 패턴 분석',
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.code, color: Colors.white),
            tooltip: 'API 응답 확인',
            onPressed: _showFullResponseDialog,
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.white, const Color.fromRGBO(241, 248, 255, 1)],
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
            : Builder(
                builder: (context) {
                  final analysisPages = _buildAnalysisPages(pattern);
                  final pageCount = analysisPages.length;

                  if (_currentPage >= pageCount) {
                    final targetPage = pageCount - 1;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted) return;
                      if (_pageController.hasClients) {
                        _pageController.jumpToPage(targetPage);
                      }
                      if (_currentPage != targetPage) {
                        setState(() {
                          _currentPage = targetPage;
                        });
                      }
                    });
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWeekInfoCard(),
                       const SizedBox(height: 10),
                      _buildPageIndicator(pageCount),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                child: PageView(
                                  controller: _pageController,
                                  onPageChanged: (index) {
                                    if (_currentPage != index) {
                                      setState(() {
                                        _currentPage = index;
                                      });
                                    }
                                  },
                                  children: analysisPages,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(height: 28),
                    ],
                  );
                },
              ),
      ),
    );
  }

  void _showFullResponseDialog() {
    final encoder = const JsonEncoder.withIndent('  ');
    final prettyJson = encoder.convert(widget.weeklyPatternResponse.toJson());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('주간 패턴 분석 API 응답'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: SelectableText(
                prettyJson,
                style: const TextStyle(
                  fontFamily: 'SourceCodePro',
                  fontSize: 12,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: prettyJson));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('응답이 클립보드에 복사되었습니다.')),
                );
              },
              child: const Text('복사'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('닫기'),
            ),
          ],
        );
      },
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
          // IconButton(
          //   icon: const Icon(Icons.code, color: Color.fromARGB(255, 0, 45, 89)),
          //   tooltip: 'API 응답 확인',
          //   onPressed: _showFullResponseDialog,
          // ),
        ],
      ),
    );
  }

  // 주간 분석 상세 내용 구성
  List<Widget> _buildAnalysisPages(WeeklyPattern pattern) {
    final metrics = widget.weeklyPatternResponse.metricsSummary;

    final firstPageChildren = <Widget>[];
    final secondPageChildren = <Widget>[];

    if (metrics != null) {
      firstPageChildren.add(_buildMetricsSummary(metrics));
      firstPageChildren.add(const SizedBox(height: 20));
    }

    if (pattern.patternAnalysis?.exerciseDiversity != null) {
      firstPageChildren.add(
        AnimatedOpacity(
          opacity: _patternAnalysisOpacity,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          child: _buildExerciseDiversitySection(pattern.patternAnalysis!.exerciseDiversity!),
        ),
      );
      firstPageChildren.add(const SizedBox(height: 5));
    }

    if (pattern.patternAnalysis?.recoveryStatus != null) {
      firstPageChildren.add(
        AnimatedOpacity(
          opacity: _patternAnalysisOpacity,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          child: _buildRecoveryStatusSection(pattern.patternAnalysis!.recoveryStatus!),
        ),
      );
      firstPageChildren.add(const SizedBox(height: 5));
    }

    if (pattern.patternAnalysis?.consistency != null) {
      firstPageChildren.add(
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
      );
      firstPageChildren.add(const SizedBox(height: 5));
    }

    if (pattern.patternAnalysis?.intensityTrend != null) {
      firstPageChildren.add(
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
      );
      firstPageChildren.add(const SizedBox(height: 5));
    }

    if (pattern.patternAnalysis?.muscleBalance != null &&
        ((pattern.patternAnalysis!.muscleBalance!.overworked != null &&
                pattern.patternAnalysis!.muscleBalance!.overworked!.isNotEmpty) ||
            (pattern.patternAnalysis!.muscleBalance!.underworked != null &&
                pattern.patternAnalysis!.muscleBalance!.underworked!.isNotEmpty))) {
      firstPageChildren.add(
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
      );
      firstPageChildren.add(const SizedBox(height: 5));
    }

    if (pattern.patternAnalysis?.muscleBalance?.comments != null) {
      firstPageChildren.add(
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
      );
      firstPageChildren.add(const SizedBox(height: 5));
    }

    if (pattern.patternAnalysis?.habitObservation != null) {
      firstPageChildren.add(
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
      );
      firstPageChildren.add(const SizedBox(height: 5));
    }

    
    if (pattern.nextTargetMuscles != null && pattern.nextTargetMuscles!.isNotEmpty) {
      secondPageChildren.add(
        _buildNextTargetMusclesSection(pattern.nextTargetMuscles!),
      );
      secondPageChildren.add(const SizedBox(height: 5));
    } 
    if (pattern.recommendedRoutine?.weeklyOverview != null &&
        pattern.recommendedRoutine!.weeklyOverview!.isNotEmpty) {
      secondPageChildren.add(
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
      );
      secondPageChildren.add(const SizedBox(height: 5));
    }

    if (pattern.recommendedRoutine?.dailyDetails != null &&
        pattern.recommendedRoutine!.dailyDetails!.isNotEmpty) {
      secondPageChildren.addAll(
        pattern.recommendedRoutine!.dailyDetails!.map(
          (detail) => Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: AnimatedOpacity(
              opacity: _recommendedRoutineOpacity,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              child: _buildDailyDetailSection(detail),
            ),
          ),
        ),
      );
    }

    if (pattern.recommendedRoutine?.progressionStrategy != null) {
      secondPageChildren.add(const SizedBox(height: 5));
      secondPageChildren.add(
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
      );
    }

    if (pattern.recoveryGuidance != null) {
      secondPageChildren.add(const SizedBox(height: 5));
      secondPageChildren.add(
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
      );
    }

    if (pattern.encouragement != null) {
      secondPageChildren.add(const SizedBox(height: 5));
      secondPageChildren.add(
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
      );
    }

    final pages = <Widget>[
      _buildScrollablePage(firstPageChildren),
    ];

    if (secondPageChildren.isNotEmpty) {
      pages.add(_buildScrollablePage(secondPageChildren));
    }

    return pages;
  }

  Widget _buildScrollablePage(List<Widget> children) {
    final effectiveChildren = children.isNotEmpty
        ? children
        : [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  '표시할 내용이 없습니다.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...effectiveChildren,
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int pageCount) {
    if (pageCount <= 1) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      Text(_currentPage == 0 ? "운동 패턴 분석" : "추천 루틴", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(pageCount, (index) {
            final isActive = index == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: isActive ? 20 : 8,
              decoration: BoxDecoration(
                color: isActive ? Colors.blueAccent : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
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
    final exerciseIds = detail.exercises ?? [];
    final hasExercises = exerciseIds.isNotEmpty;

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
          child: isExpanded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    if (detail.targetMuscles != null && detail.targetMuscles!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 8),
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: detail.targetMuscles!.map((muscle) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.orange.withOpacity(0.3)),
                              ),
                              child: Text(
                                muscle,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    if (detail.estimatedDuration != null && detail.estimatedDuration!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 12),
                        child: _buildRoutineMetaChip(
                          icon: Icons.timer_outlined,
                          label: '예상 소요 시간',
                          value: detail.estimatedDuration!,
                        ),
                      ),
                    if (detail.ragQuery != null && detail.ragQuery!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 12),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.search, size: 16, color: Colors.grey.shade600),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${detail.ragQuery}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (hasExercises)
                      FutureBuilder<List<ExerciseModelResponse>>(
                        future: _exercisesFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          
                          if (snapshot.hasError) {
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
                                '운동 정보를 불러오는 중 오류가 발생했습니다: ${snapshot.error}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              ),
                            );
                          }
                          
                          // 캐시에서 해당 ID의 운동 정보만 필터링
                          final exercises = exerciseIds
                              .map((id) => _exercisesCache?[id])
                              .whereType<ExerciseModelResponse>()
                              .toList();
                          
                          if (exercises.isEmpty) {
                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(vertical: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.orange.withOpacity(0.2)),
                              ),
                              child: const Text(
                                '추천 운동이 없습니다.',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            );
                          }
                          
                          return Column(
                            children: exercises.map((exercise) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: VideoCard(exercise: exercise),
                              );
                            }).toList(),
                          );
                        },
                      )
                    else
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange.withOpacity(0.2)),
                        ),
                        child: const Text(
                          '추천 운동이 없습니다.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
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

  Widget _buildRoutineMetaChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.withOpacity(0.12), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.orange.shade700),
          const SizedBox(width: 8),
          Text(
            '$label · $value',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.orange.shade700,
            ),
          ),
        ],
      ),
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
            _buildStatCard('휴식일', '${metrics.restDays}일', Icons.restaurant),
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

        // 상위 장비
        if (metrics.topEquipment.isNotEmpty)
          _buildSection('자주 사용한 장비', [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: metrics.topEquipment.map((equipment) {
                return Chip(
                  label: Text('${equipment.name}: ${equipment.count}회'),
                  labelStyle: const TextStyle(fontSize: 12),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  backgroundColor: Colors.purple.shade50,
                );
              }).toList(),
            ),
          ], Icons.sports_gymnastics),
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

  Widget _buildExerciseDiversitySection(ExerciseDiversity diversity) {
    final title = '운동 다양성';
    final isExpanded = _isSectionExpanded[title] ?? true;

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
                colors: [Colors.indigo.shade50, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.transparent),
            ),
            child: Row(
              children: [
                Icon(Icons.diversity_3, color: Colors.indigo, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ),
                Icon(
                  isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Colors.indigo,
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
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.indigo.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (diversity.exerciseVarietyScore != null) ...[
                            Row(
                              children: [
                                Icon(Icons.star, size: 16, color: Colors.indigo.shade700),
                                const SizedBox(width: 6),
                                Text(
                                  '운동 다양성 점수: ${diversity.exerciseVarietyScore}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.indigo.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                          if (diversity.recentExercises != null && diversity.recentExercises!.isNotEmpty) ...[
                            Text(
                              '최근 운동:',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: diversity.recentExercises!.map((exercise) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.indigo.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.indigo.withOpacity(0.2)),
                                  ),
                                  child: Text(
                                    exercise,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.indigo.shade700,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 10),
                          ],
                          if (diversity.repetitionPattern != null && diversity.repetitionPattern!.isNotEmpty) ...[
                            _buildInfoRow('반복 패턴', diversity.repetitionPattern!),
                            const SizedBox(height: 8),
                          ],
                          if (diversity.recommendedVariation != null && diversity.recommendedVariation!.isNotEmpty) ...[
                            _buildInfoRow('추천 변화', diversity.recommendedVariation!),
                            const SizedBox(height: 8),
                          ],
                          if (diversity.preferredEquipment != null && diversity.preferredEquipment!.isNotEmpty) ...[
                            Text(
                              '선호 장비:',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: diversity.preferredEquipment!.map((equipment) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.purple.withOpacity(0.2)),
                                  ),
                                  child: Text(
                                    equipment,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.purple.shade700,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (diversity.equipmentUsagePattern != null && diversity.equipmentUsagePattern!.isNotEmpty) ...[
                            _buildInfoRow('장비 사용 패턴', diversity.equipmentUsagePattern!),
                            const SizedBox(height: 8),
                          ],
                          if (diversity.performanceAnalysis != null) ...[
                            const Divider(),
                            const SizedBox(height: 8),
                            if (diversity.performanceAnalysis!.currentLevel != null && diversity.performanceAnalysis!.currentLevel!.isNotEmpty)
                              _buildInfoRow('현재 수준', diversity.performanceAnalysis!.currentLevel!),
                            if (diversity.performanceAnalysis!.progressionTrend != null && diversity.performanceAnalysis!.progressionTrend!.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              _buildInfoRow('진행 추세', diversity.performanceAnalysis!.progressionTrend!),
                            ],
                            if (diversity.performanceAnalysis!.recommendedProgression != null && diversity.performanceAnalysis!.recommendedProgression!.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              _buildInfoRow('추천 진행', diversity.performanceAnalysis!.recommendedProgression!),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildRecoveryStatusSection(RecoveryStatus recovery) {
    final title = '회복 상태';
    final isExpanded = _isSectionExpanded[title] ?? true;

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
                colors: [Colors.green.shade50, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.transparent),
            ),
            child: Row(
              children: [
                Icon(Icons.healing, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                Icon(
                  isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Colors.green,
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
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (recovery.fatigueLevel != null && recovery.fatigueLevel!.isNotEmpty) ...[
                            Row(
                              children: [
                                Icon(Icons.battery_charging_full, size: 16, color: Colors.green.shade700),
                                const SizedBox(width: 6),
                                Text(
                                  '피로 수준: ${recovery.fatigueLevel}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                          if (recovery.recoveryNeeds != null && recovery.recoveryNeeds!.isNotEmpty) ...[
                            Text(
                              '회복 필요 부위:',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: recovery.recoveryNeeds!.map((muscle) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.green.withOpacity(0.2)),
                                  ),
                                  child: Text(
                                    muscle,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 10),
                          ],
                          if (recovery.suggestedIntensity != null && recovery.suggestedIntensity!.isNotEmpty) ...[
                            Row(
                              children: [
                                Icon(Icons.trending_up, size: 16, color: Colors.green.shade700),
                                const SizedBox(width: 6),
                                Text(
                                  '제안 강도: ${recovery.suggestedIntensity}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade800,
            ),
          ),
        ),
      ],
    );
  }
}

