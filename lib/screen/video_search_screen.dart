import 'package:flutter/material.dart';
import 'package:gukminexdiary/widget/custom_appbar.dart';
import 'package:gukminexdiary/provider/exercise_provider.dart';
import 'package:gukminexdiary/provider/bookmark_provider.dart';
import 'package:provider/provider.dart';
import 'package:gukminexdiary/widget/video_card.dart';
import 'package:gukminexdiary/widget/body_part_selector_widget.dart';
import 'package:gukminexdiary/model/muscle_model.dart';
import 'package:gukminexdiary/model/exercise_model.dart';

class VideoSearchScreen extends StatefulWidget {
  final bool lastPage;
  const VideoSearchScreen({super.key, required this.lastPage});
  
  @override
  State<VideoSearchScreen> createState() => _VideoSearchScreenState();
}

class _VideoSearchScreenState extends State<VideoSearchScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _muscleScrollController = ScrollController();
  late TabController _tabController;
  
  // 1페이지 (기존 검색) 상태
  bool _isLoadingMore = false; // 추가 로딩 상태
  bool _lastPage = false;
  
  // 2페이지 (근육별 검색) 상태
  List<MuscleModel> _selectedMuscles = [];
  List<ExerciseModelResponse> _muscleSearchResults = [];
  bool _isMuscleLoading = false;
  bool _isMuscleLoadingMore = false;
  bool _muscleLastPage = false;
  bool _isMuscleExpanded = false;
  BodyPartSelectorWidget? _bodyPartSelectorWidget;
  late AnimationController _muscleAnimationController;
  late Animation<double> _muscleSizeAnimation;

  // 필터 상태 관리 (단일 선택만 가능)
  String? _selectedTargetGroup; // 대상 (targetGroup)
  String? _selectedFitnessFactorName; // 체력항목 (fitnessFactorName)
  String? _selectedFitnessLevelName; // 운동 난이도 (fitnessLevelName)
  String? _selectedBodyPart; // 운동부위 (bodyPart)
  String? _selectedExerciseTool; // 운동도구 (exerciseTool)
  String? _selectedDisease; // 질환 (disease)
  
  // 필터 옵션 리스트
  final List<String> _targetOptions = ['유아기', '유소년', '청소년', '성인', '어르신'];
  final List<String> _fitnessOptions = ['근력/근지구력', '심폐지구력', '민첩성/순발력', '유연성', '평형성', '협응력'];
  final List<String> _fitnessLevelOptions = ['초급', '중급', '고급'];
  final List<String> _bodyPartOptions = ['몸통', '상체', '전신', '하체', '기타'];
  final List<String> _equipmentOptions = ['맨몸', '머신', '의자', '짐볼', '폼롤러', '탄력밴드', '기타'];
  final List<String> _conditionOptions = ['고혈압', '요통', '골다공증', '관절염', '우울증', '치매'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _muscleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _muscleSizeAnimation = CurvedAnimation(
      parent: _muscleAnimationController,
      curve: Curves.decelerate,
    );
    _scrollController.addListener(_onScroll);
    _muscleScrollController.addListener(_onMuscleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.lastPage) {
        _lastPage = true;
        _tabController.index = 1;
        _pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      } else {
        _lastPage = false;
        _tabController.index = 0;
        _pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
      final exerciseProvider = context.read<ExerciseProvider>();
      final bookmarkProvider = context.read<BookmarkProvider>();
      await exerciseProvider.getExercisesData('');
      await bookmarkProvider.getBookmarks();
      _bodyPartSelectorWidget = BodyPartSelectorWidget(
        onMusclesSelected: _onMusclesSelected,
      );
    });
  }

  // 스크롤 감지 로직 (1페이지)
  void _onScroll() {
    if (_lastPage || _isLoadingMore) return;
    
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      _loadMoreData();
    }
  }

  // 스크롤 감지 로직 (2페이지 - 근육별 검색)
  void _onMuscleScroll() {
    if (_muscleLastPage || _isMuscleLoadingMore) return;
    
    final position = _muscleScrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      _loadMoreMuscleData();
    }
  }

  // 추가 데이터 로드
  Future<void> _loadMoreData() async {
    if (_isLoadingMore) return;
    
    final exerciseProvider = context.read<ExerciseProvider>();
    if (exerciseProvider.isLoading || exerciseProvider.lastPage) return;
    
    setState(() {
      _isLoadingMore = true;
    });

    try {
      await exerciseProvider.getMoreExercisesData();
      _lastPage = exerciseProvider.lastPage;
    } catch (e) {
      print('추가 데이터 로드 실패: $e');
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  // 필터 섹션 빌드 메서드 (라디오 버튼 방식) - 다이얼로그 내에서 사용
  Widget _buildFilterSection(String title, List<String> options, String? selectedValue, Function(String?) onChanged, {bool autoSearch = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                // 단일 선택: 같은 그룹에서 하나만 선택 가능
                onChanged(selected ? option : null);
                if (autoSearch) {
                  _performSearch();
                }
              },
              selectedColor: Colors.blue[100],
              checkmarkColor: Colors.blue[800],
            );
          }).toList(),
        ),
      ],
    );
  }
  
  // 필터 초기화
  void _clearAllFilters() {
    setState(() {
      _selectedTargetGroup = null;
      _selectedFitnessFactorName = null;
      _selectedFitnessLevelName = null;
      _selectedBodyPart = null;
      _selectedExerciseTool = null;
      _selectedDisease = null;
    });
    _performSearch();
  }
  
  // 필터 팝업 다이얼로그 표시
  void _showFilterDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _FilterDialog(
          selectedTargetGroup: _selectedTargetGroup,
          selectedFitnessFactorName: _selectedFitnessFactorName,
          selectedFitnessLevelName: _selectedFitnessLevelName,
          selectedBodyPart: _selectedBodyPart,
          selectedExerciseTool: _selectedExerciseTool,
          selectedDisease: _selectedDisease,
          targetOptions: _targetOptions,
          fitnessOptions: _fitnessOptions,
          fitnessLevelOptions: _fitnessLevelOptions,
          bodyPartOptions: _bodyPartOptions,
          equipmentOptions: _equipmentOptions,
          conditionOptions: _conditionOptions,
          onTargetGroupChanged: (value) {
            setState(() {
              _selectedTargetGroup = value;
            });
          },
          onFitnessFactorNameChanged: (value) {
            setState(() {
              _selectedFitnessFactorName = value;
            });
          },
          onFitnessLevelNameChanged: (value) {
            setState(() {
              _selectedFitnessLevelName = value;
            });
          },
          onBodyPartChanged: (value) {
            setState(() {
              _selectedBodyPart = value;
            });
          },
          onExerciseToolChanged: (value) {
            setState(() {
              _selectedExerciseTool = value;
            });
          },
          onDiseaseChanged: (value) {
            setState(() {
              _selectedDisease = value;
            });
          },
          onClearAll: _clearAllFilters,
          onApply: () {
            Navigator.of(context).pop();
            _performSearch();
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.3),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }

  // 검색 실행 (1페이지)
  void _performSearch() {
    _lastPage = false;
    final exerciseProvider = context.read<ExerciseProvider>();
    exerciseProvider.resetExercises();
    
    // 필터 파라미터를 포함한 검색 실행
    exerciseProvider.getExercisesDataWithFilters(
      _searchController.text,
      targetGroup: _selectedTargetGroup,
      fitnessFactorName: _selectedFitnessFactorName,
      fitnessLevelName: _selectedFitnessLevelName,
      bodyPart: _selectedBodyPart,
      exerciseTool: _selectedExerciseTool,
      disease: _selectedDisease,
    );
    
    print('검색어: ${_searchController.text}');
    print('필터 조건:');
    print('  - 대상: $_selectedTargetGroup');
    print('  - 체력항목: $_selectedFitnessFactorName');
    print('  - 운동 난이도: $_selectedFitnessLevelName');
    print('  - 운동부위: $_selectedBodyPart');
    print('  - 운동도구: $_selectedExerciseTool');
    print('  - 질환: $_selectedDisease');
  }

  // 근육별 검색 실행 (2페이지)
  Future<void> _performMuscleSearch() async {
    
    if (_selectedMuscles.isEmpty) {
      setState(() {
        _muscleLastPage = false;
        _muscleSearchResults.clear();
      });
    
      return;
    }
    
    setState(() {
      _isMuscleLoading = true;
      _muscleLastPage = false;
      _muscleSearchResults.clear();
    });

    try {
      // 근육별 검색 API 호출
      final exerciseProvider = context.read<ExerciseProvider>();
      final muscleNames = _selectedMuscles.map((muscle) => muscle.name).toList();
      print('선택된 근육들로 검색 시작: $muscleNames');
      
      // 기존 근육별 검색 결과 초기화
      exerciseProvider.resetMuscleExercises();
      
      await exerciseProvider.getExercisesByMuscle(muscleNames, 0);
      _muscleSearchResults = exerciseProvider.muscleExercises;
      print('검색 결과 개수: ${_muscleSearchResults.length}');
    } catch (e) {
      print('근육별 검색 실패: $e');
    } finally {
      setState(() {
        _isMuscleLoading = false;
      });
    }
  }

  // 근육별 검색 추가 데이터 로드
  Future<void> _loadMoreMuscleData() async {
    if (_isMuscleLoadingMore || _muscleLastPage) return;
    
    setState(() {
      _isMuscleLoadingMore = true;
    });

    try {
      // 근육별 검색 추가 데이터 로드 API 호출
      final exerciseProvider = context.read<ExerciseProvider>();
      await exerciseProvider.getMoreExercisesByMuscle();
      _muscleSearchResults = exerciseProvider.muscleExercises;
      _muscleLastPage = exerciseProvider.muscleLastPage;
    } catch (e) {
      print('근육별 검색 추가 데이터 로드 실패: $e');
    } finally {
      setState(() {
        _isMuscleLoadingMore = false;
      });
    }
  }

  // 선택된 근육 변경 시 호출
  void _onMusclesSelected(List<MuscleModel> selectedMuscles) {
    print('근육 선택 변경: ${selectedMuscles.map((m) => m.name).toList()}');
    setState(() {
      _selectedMuscles = selectedMuscles;
    });
    _performMuscleSearch();
  }


  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    _muscleScrollController.dispose();
    _muscleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = Provider.of<ExerciseProvider>(context);
    return Scaffold(
      // appBar: CustomAppbar(
      //   title: '영상 검색',
      //   automaticallyImplyLeading: true,
      // ),
      body: Column(
        children: [
          // 탭 바
          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 241, 249, 255),
              border: Border(
                bottom: BorderSide(color: const Color.fromARGB(0, 224, 224, 224)!),
              ),
            ),
            child: Row(
              children: [
                SizedBox(width: 5),
                Expanded(child: 
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: _tabController.index == 0 ? const Color.fromARGB(255, 241, 249, 255) : const Color.fromARGB(22, 0, 0, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    setState(() {
                      _tabController.index = 0;
                      _pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                    });
                  }, child: Text('전체 검색', 
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: _tabController.index == 0 ? FontWeight.bold : FontWeight.normal, 
                      color: _tabController.index == 0 ? 
                        const Color.fromARGB(255, 94, 137, 255) :
                        const Color.fromARGB(255, 110, 110, 110),), 
                       textAlign: TextAlign.center,)
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: TextButton(style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    backgroundColor: _tabController.index == 1 ? const Color.fromARGB(255, 241, 249, 255) : const Color.fromARGB(22, 0, 0, 0),
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ), onPressed: () {
                    setState(() {
                      _tabController.index = 1;
                      _pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                    });
                  }, child: Text('근육별 검색', 
                    style: TextStyle(fontSize: 16, 
                    fontWeight: _tabController.index == 1 ? FontWeight.bold : FontWeight.normal, 
                    color: _tabController.index == 1 ? 
                    const Color.fromARGB(255, 94, 137, 255) :
                     const Color.fromARGB(255, 110, 110, 110),), 
                     textAlign: TextAlign.center,)
                  )
                ),
                SizedBox(width: 5),
              ],
            )
            // child: TabBar(
            //   controller: _tabController,
            //   onTap: (index) {
            //     _pageController.animateToPage(
            //       index,
            //       duration: const Duration(milliseconds: 300),
            //       curve: Curves.easeInOut,
            //     );
            //   },
            //   tabs: const [
            //     Tab(text: '전체 검색',),
            //     Tab(text: '근육별 검색'),
            //   ],
            //   labelColor: Colors.black,
            //   unselectedLabelColor: Colors.grey,
            //   indicatorColor: const Color.fromARGB(255, 167, 216, 255),
            // ),
          ),
          // 페이지뷰
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _tabController.index = index;
                });
              },
              children: [
                _buildGeneralSearchPage(exerciseProvider),
                _buildMuscleSearchPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 1페이지: 기존 전체 검색 페이지
  Widget _buildGeneralSearchPage(ExerciseProvider exerciseProvider) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [Colors.white, const Color.fromARGB(255, 241, 249, 255)],
          radius: 0.7,
          stops: [0.3, 0.7],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          // 검색창
          Container(
            margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, const Color.fromARGB(0, 245, 245, 245)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.7, 0.9],
              ),
              border: Border.all(color: const Color.fromARGB(255, 186, 225, 255), width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: '검색어를 입력해주세요.',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Row(children: [
                  IconButton(onPressed: () => _showFilterDialog(context), icon: const Icon(Icons.filter_list)),
                  IconButton(onPressed: _performSearch, icon: const Icon(Icons.search)),
                ],)
                
              ],
            ),
          ),
          // 필터 버튼
          // Container(
          //   width: double.infinity,
          //   child: ElevatedButton.icon(
          //     onPressed: () => _showFilterDialog(context),
          //     icon: const Icon(Icons.filter_list),
          //     label: const Text('조건 검색'),
          //     style: ElevatedButton.styleFrom(
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(0),
          //       ),
          //       backgroundColor: Colors.grey[200],
          //       foregroundColor: Colors.black87,
          //       elevation: 0,
          //     ),
          //   ),
          // ),
          Container(
            height: 10,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ const Color.fromARGB(255, 241, 249, 255), 
                const Color.fromARGB(92, 241, 249, 255), 
                const Color.fromARGB(0, 241, 249, 255)],
              ),
            ),
          ),
          // 영상 목록
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: exerciseProvider.exercises.length + (_isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                // 로딩 인디케이터 표시
                if (index == exerciseProvider.exercises.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                
                final exercise = exerciseProvider.exercises[index];
                return VideoCard(exercise: exercise);
              },
            ),
          ),
        ],
      ),
    );
  }

  // 2페이지: 근육별 검색 페이지
  Widget _buildMuscleSearchPage() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [Colors.white, const Color.fromARGB(255, 241, 249, 255)],
          radius: 0.7,
          stops: [0.3, 0.7],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          // 검색 결과
          Column(
            children: [
              Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black87,
                    elevation: 0,
                  ),
                  onPressed: () {
                    setState(() {
                      _isMuscleExpanded = !_isMuscleExpanded;
                      if (_isMuscleExpanded) {
                        _muscleAnimationController.forward();
                      } else {
                        _muscleAnimationController.reverse();
                      }
                    });
                  }, 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('근육 선택'),
                      Icon(_isMuscleExpanded ? Icons.expand_less : Icons.expand_more),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: _isMuscleLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _muscleSearchResults.isEmpty
                          ? const Center(
                              child: Text(
                                '근육을 선택하면 해당하는 운동 영상을 찾아드립니다.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          : ListView.builder(
                              controller: _muscleScrollController,
                              itemCount: _muscleSearchResults.length + (_isMuscleLoadingMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == _muscleSearchResults.length) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                                
                              // 실제 운동 데이터로 VideoCard 표시
                              final exercise = _muscleSearchResults[index];
                              return VideoCard(exercise: exercise, selectedMuscleNames: _selectedMuscles.map((muscle) => muscle.name).toList());
                          },
                        ),
                ),
              ),
          ],
          ),
          ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: 1.0,
              child: SizeTransition(
                sizeFactor: _muscleSizeAnimation,
                axisAlignment: -1.0,
                child: IgnorePointer(
                  ignoring: !_isMuscleExpanded,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 50, 16, 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: BodyPartSelectorWidget(
                      onMusclesSelected: _onMusclesSelected,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// 필터 다이얼로그 위젯
class _FilterDialog extends StatefulWidget {
  final String? selectedTargetGroup;
  final String? selectedFitnessFactorName;
  final String? selectedFitnessLevelName;
  final String? selectedBodyPart;
  final String? selectedExerciseTool;
  final String? selectedDisease;
  final List<String> targetOptions;
  final List<String> fitnessOptions;
  final List<String> fitnessLevelOptions;
  final List<String> bodyPartOptions;
  final List<String> equipmentOptions;
  final List<String> conditionOptions;
  final Function(String?) onTargetGroupChanged;
  final Function(String?) onFitnessFactorNameChanged;
  final Function(String?) onFitnessLevelNameChanged;
  final Function(String?) onBodyPartChanged;
  final Function(String?) onExerciseToolChanged;
  final Function(String?) onDiseaseChanged;
  final VoidCallback onClearAll;
  final VoidCallback onApply;

  const _FilterDialog({
    required this.selectedTargetGroup,
    required this.selectedFitnessFactorName,
    required this.selectedFitnessLevelName,
    required this.selectedBodyPart,
    required this.selectedExerciseTool,
    required this.selectedDisease,
    required this.targetOptions,
    required this.fitnessOptions,
    required this.fitnessLevelOptions,
    required this.bodyPartOptions,
    required this.equipmentOptions,
    required this.conditionOptions,
    required this.onTargetGroupChanged,
    required this.onFitnessFactorNameChanged,
    required this.onFitnessLevelNameChanged,
    required this.onBodyPartChanged,
    required this.onExerciseToolChanged,
    required this.onDiseaseChanged,
    required this.onClearAll,
    required this.onApply,
  });

  @override
  State<_FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<_FilterDialog> {
  late String? _currentTargetGroup;
  late String? _currentFitnessFactorName;
  late String? _currentFitnessLevelName;
  late String? _currentBodyPart;
  late String? _currentExerciseTool;
  late String? _currentDisease;

  @override
  void initState() {
    super.initState();
    _currentTargetGroup = widget.selectedTargetGroup;
    _currentFitnessFactorName = widget.selectedFitnessFactorName;
    _currentFitnessLevelName = widget.selectedFitnessLevelName;
    _currentBodyPart = widget.selectedBodyPart;
    _currentExerciseTool = widget.selectedExerciseTool;
    _currentDisease = widget.selectedDisease;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 255, 254, 242), const Color.fromARGB(255, 255, 255, 255)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.7, 0.9],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 254, 242),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '필터 조건',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    color: Colors.black87,
                  ),
                ],
              ),
            ),
            // 필터 내용
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(110, 255, 255, 255),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFilterSection(
                      '대상',
                      widget.targetOptions,
                      _currentTargetGroup,
                      (value) {
                        setState(() {
                          _currentTargetGroup = value;
                        });
                      },
                    ),
                    const Divider(height: 32),
                    _buildFilterSection(
                      '체력항목',
                      widget.fitnessOptions,
                      _currentFitnessFactorName,
                      (value) {
                        setState(() {
                          _currentFitnessFactorName = value;
                        });
                      },
                    ),
                    const Divider(height: 32),
                    _buildFilterSection(
                      '운동 난이도',
                      widget.fitnessLevelOptions,
                      _currentFitnessLevelName,
                      (value) {
                        setState(() {
                          _currentFitnessLevelName = value;
                        });
                      },
                    ),
                    const Divider(height: 32),
                    _buildFilterSection(
                      '운동부위',
                      widget.bodyPartOptions,
                      _currentBodyPart,
                      (value) {
                        setState(() {
                          _currentBodyPart = value;
                        });
                      },
                    ),
                    const Divider(height: 32),
                    _buildFilterSection(
                      '운동도구',
                      widget.equipmentOptions,
                      _currentExerciseTool,
                      (value) {
                        setState(() {
                          _currentExerciseTool = value;
                        });
                      },
                    ),
                    const Divider(height: 32),
                    _buildFilterSection(
                      '질환',
                      widget.conditionOptions,
                      _currentDisease,
                      (value) {
                        setState(() {
                          _currentDisease = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            ),
            // 하단 버튼
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade200, width: 2)),
                color: const Color.fromARGB(110, 255, 255, 255),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _currentTargetGroup = null;
                        _currentFitnessFactorName = null;
                        _currentFitnessLevelName = null;
                        _currentBodyPart = null;
                        _currentExerciseTool = null;
                        _currentDisease = null;
                      });
                    },
                    child: const Text(
                      '전체 초기화',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('취소', style: TextStyle(color: Color.fromARGB(255, 228, 137, 131))),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          // 부모 위젯의 상태 업데이트
                          widget.onTargetGroupChanged(_currentTargetGroup);
                          widget.onFitnessFactorNameChanged(_currentFitnessFactorName);
                          widget.onFitnessLevelNameChanged(_currentFitnessLevelName);
                          widget.onBodyPartChanged(_currentBodyPart);
                          widget.onExerciseToolChanged(_currentExerciseTool);
                          widget.onDiseaseChanged(_currentDisease);
                          // 적용 버튼 콜백 실행
                          widget.onApply();
                        },             
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: const Color.fromARGB(255, 236, 255, 188),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('적용', style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    List<String> options,
    String? selectedValue,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color.fromARGB(255, 245, 255, 177), const Color.fromARGB(0, 255, 255, 255)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return FilterChip(
              label: Text(option, style: const TextStyle(color: Colors.black)),
              side: BorderSide(color: const Color.fromARGB(255, 167, 167, 167), width: isSelected ? 2 : 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              selected: isSelected,
              onSelected: (selected) {
                onChanged(selected ? option : null);
              },
              backgroundColor: const Color.fromARGB(255, 247, 247, 247),
              selectedColor: const Color.fromARGB(255, 249, 255, 195),
              checkmarkColor: Colors.blue[800],
            );
          }).toList(),
        ),
      ],
    );
  }
}
