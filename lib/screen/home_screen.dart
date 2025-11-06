import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gukminexdiary/widget/custom_appbar.dart';
import 'package:gukminexdiary/widget/custom_drawer.dart';
import 'package:gukminexdiary/data/muscle_data.dart';
import 'package:gukminexdiary/services/exercise_service.dart';
import 'package:gukminexdiary/model/exercise_model.dart';
import 'package:gukminexdiary/screen/video_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _randomMuscleName;
  List<ExerciseModelResponse> _randomExercises = [];
  bool _isLoadingRandom = false;

  @override
  void initState() {
    super.initState();
    _loadRandomMuscleExercises();
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

      // 해당 근육으로 운동 5개 불러오기 (page: 0, size: 5)
      final exerciseService = ExerciseService();
      final exercises = await exerciseService.getExercisesByMuscle([_randomMuscleName!], 0, 5);
      
      setState(() {
        _randomExercises = exercises;
        _isLoadingRandom = false;
      });
    } catch (e) {
      print('랜덤 근육 운동 로드 실패: $e');
      setState(() {
        _isLoadingRandom = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        title: '홈',
        automaticallyImplyLeading: true,
      ),
      drawer: const CustomDrawer(),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.white, const Color.fromRGBO(241, 248, 255, 1)],
            radius: 0.5,
            stops: [0.3, 0.7],
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            // 랜덤 근육 운동 추천 섹션
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_randomMuscleName != null)
                    Text(
                      '오늘 ${_randomMuscleName} 운동 5가지는 어떤가요?',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    )
                  else
                    const Text(
                      '오늘의 추천 운동',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  const SizedBox(height: 12),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    height: 180,
                    child: _isLoadingRandom
                        ? const Center(child: CircularProgressIndicator())
                        : _randomExercises.isEmpty
                            ? const Center(
                                child: Text(
                                  '운동을 불러올 수 없습니다',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _randomExercises.length,
                                itemBuilder: (context, index) {
                                  final exercise = _randomExercises[index];
                                  return _buildExerciseCard(exercise);
                                },
                              ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: ListView(
              children: [
                Card(
                  child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/facility/search');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [const Color.fromARGB(255, 248, 250, 252), Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset('assets/icons/gym.png', width: 25, height: 25,),
                            const Text('시설 검색', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                          ],
                      ),
                    ),  
                  ),
                ),
                SizedBox(height: 10),
                const Row(children: [Text("운동 검색", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),],),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Card( 
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/video/search/name');
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [const Color.fromARGB(255, 255, 251, 227), Colors.white],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.yellow.shade100),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: 
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.video_library, size: 25,),
                                    Text('이름 검색', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                  ],
                              ),
                            ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                      child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/video/search/muscle');
                          },
                        child:
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [const Color.fromARGB(255, 255, 246, 247), Colors.white],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.red.shade100),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset('assets/icons/muscle.png', width: 25, height: 25,),
                                const Text('근육 검색', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
                ),
                Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/diary');
                    },
                    child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [const Color.fromARGB(255, 248, 255, 249), Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.green.shade100),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Image.asset('assets/icons/diary.png', width: 40, height: 40,),
                        const Text('AI 운동 일지', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                  )
                ),
                Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/bookmark');
                    },
                  child:
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [const Color.fromARGB(255, 253, 243, 255), Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.purple.shade100),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.bookmark, size: 40,),
                          Text('즐겨찾기', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                  ),
                ),
                // Card(
                //   child: InkWell(
                //     onTap: () {
                //       Navigator.pushNamed(context, '/api/test');
                //     },
                //   child:
                //     Container(
                //       padding: const EdgeInsets.all(20),
                //       child: const Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Icon(Icons.api, size: 50,),
                //           Text('API 테스트', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),),
            Image.asset('assets/images/main_logo.png', width: 100, height: 100),
          ],
        )
      ),
    );
  }

  Widget _buildExerciseCard(ExerciseModelResponse exercise) {
    return Container(
      width: 160,
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
                height: 100,
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
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
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