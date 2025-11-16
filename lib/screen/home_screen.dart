import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gukminexdiary/data/muscle_data.dart';
import 'package:gukminexdiary/model/exercise_model.dart';
import 'package:gukminexdiary/screen/video_detail_screen.dart';
import 'package:gukminexdiary/services/exercise_service.dart';
import 'package:gukminexdiary/services/recommendation_service.dart';
import 'package:gukminexdiary/widget/custom_appbar.dart';
import 'package:gukminexdiary/widget/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _randomMuscleName;
  List<ExerciseModelResponse> _randomExercises = [];
  bool _isLoadingRandom = false;

  List<ExerciseModelResponse> _recommendedExercises = [];
  bool _isLoadingRecommended = false;
  String? _recommendationError;

  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadRandomMuscleExercises();
    _loadRecommendations();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadRandomMuscleExercises() async {
    setState(() {
      _isLoadingRandom = true;
    });

    try {
      // 모든 근육 중 랜덤으로 하나 선택
      final allMuscles = MuscleData.allMuscles;
      if (allMuscles.isEmpty) {
        setState(() {
          _isLoadingRandom = false;
        });
        return;
      }

      final random = Random();
      final randomMuscle = allMuscles[random.nextInt(allMuscles.length)];
      _randomMuscleName = randomMuscle.name;

      // 해당 근육으로 운동 20개 불러오기 후 무작위 5개 선택
      final exerciseService = ExerciseService();
      final exercises = await exerciseService.getExercisesByMuscle(
        [_randomMuscleName!],
        0,
        20,
      );

      final selectedExercises = List<ExerciseModelResponse>.from(exercises);
      selectedExercises.shuffle(random);
      final topFive = selectedExercises.take(5).toList();
      
      if (!mounted) return;
      setState(() {
        _randomExercises = topFive;
        _isLoadingRandom = false;
      });
    } catch (e) {
      print('랜덤 근육 운동 로드 실패: $e');
      if (!mounted) return;
      setState(() {
        _isLoadingRandom = false;
      });
    }
  }

  Future<void> _loadRecommendations() async {
    setState(() {
      _isLoadingRecommended = true;
      _recommendationError = null;
    });

    try {
      final recommendationService = RecommendationService();
      final exercises = await recommendationService.fetchRecommendationList(count: 5);
      if (!mounted) return;
      setState(() {
        _recommendedExercises = exercises;
        _isLoadingRecommended = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingRecommended = false;
        _recommendationError = e.toString();
      });
    }
  }

  String _currentPageTitle() {
    if (_currentPage == 0) {
      if (_randomMuscleName != null) {
        return '오늘 ${_randomMuscleName} 운동 5가지는 어떤가요?';
      }
      return '오늘의 근육별 추천 운동';
    }
    return '나를 위한 AI 맞춤 운동 5가지';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const CustomAppbar(
      //   title: '홈',
      //   automaticallyImplyLeading: true,
      // ),
      drawer: const CustomDrawer(),
      body: Container(  
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 5),
        decoration: BoxDecoration(
          gradient: const RadialGradient(
            colors: [Colors.white, const Color.fromRGBO(241, 248, 255, 1)],
            radius: 0.5,
            stops: [0.3, 0.7],
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
             Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ const Color.fromARGB(255, 184, 224, 255), const Color.fromARGB(0, 255, 255, 255)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('오늘 ${_randomMuscleName} 운동 5가지는 어떤가요?', 
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),)
            ),
            Expanded(child:
            _buildExerciseListPage(
              isLoading: _isLoadingRandom,
                exercises: _randomExercises,
                emptyMessage: '운동을 불러올 수 없습니다',
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ const Color.fromARGB(255, 184, 224, 255), const Color.fromARGB(0, 255, 255, 255)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('나를 위한 AI 맞춤 운동 5가지', 
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),)
            ),
            Expanded(
              child: 
              _buildExerciseListPage(
                isLoading: _isLoadingRecommended,
                exercises: _recommendedExercises,
                emptyMessage: _recommendationError ?? '추천 결과가 없습니다',
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1)
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseListPage({
    required bool isLoading,
    required List<ExerciseModelResponse> exercises,
    required String emptyMessage,
  }) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (exercises.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            emptyMessage,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return PageView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        return _buildExerciseCard(exercise);
      },
    );
  }

  void _animateToPage(int targetPage) {
    final nextPage = targetPage < 0
        ? 0
        : targetPage > 1
            ? 1
            : targetPage;

    if (!_pageController.hasClients || nextPage == _currentPage) return;

    setState(() {
      _currentPage = nextPage;
    });

    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildNavButton({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.black.withOpacity(0.3),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            icon,
            size: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(ExerciseModelResponse exercise) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color.fromARGB(255, 255, 255, 255), const Color.fromARGB(0, 255, 255, 255)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.9, 1.0],
        ),
        borderRadius: BorderRadius.circular(12),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.2),
        //     spreadRadius: 1,
        //     blurRadius: 4,
        //     offset: const Offset(0, 2),
        //   ),
        // ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoDetailScreen(exercise: exercise),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: "${exercise.imageUrl}/${exercise.imageFileName}",
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: double.infinity,
                  height: 100,
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: double.infinity,
                  height: 100,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            // 제목 및 정보
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      exercise.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      exercise.standardTitle ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 87, 87, 87),
                      ),
                    ),
                  ),
                  if (exercise.muscleName != null) ...[
                    const SizedBox(height: 4),
                    Container(
                      height: 20,
                      width: double.infinity,
                      child:
                      ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: exercise.muscleName!.split(',').length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              exercise.muscleName!.split(',')[index],
                              style: TextStyle(
                                fontSize: 12,
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          );
                        },
                    )),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}