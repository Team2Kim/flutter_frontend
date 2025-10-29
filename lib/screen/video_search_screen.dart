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
  const VideoSearchScreen({super.key});

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
  bool _isFilterExpanded = false; // 필터 섹션 접기/펼치기 상태
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

  // 필터 상태 관리
  Map<String, bool> _targetFilters = {
    '유아기': false,
    '유소년': false,
    '청소년': false,
    '성인': false,
    '어르신': false,
  };
  
  Map<String, bool> _fitnessFilters = {
    '근력/근지구력': false,
    '심폐지구력': false,
    '민첩성/순발력': false,
    '유연성': false,
    '평형성': false,
    '협응력': false,
  };
  
  Map<String, bool> _bodyPartFilters = {
    '몸통': false,
    '상체': false,
    '전신': false,
    '하체': false,
  };
  
  Map<String, bool> _equipmentFilters = {
    '맨몸': false,
    '머신': false,
    '의자': false,
    '짐볼': false,
    '폼롤러': false,
    '탄력밴드': false,
    '기타': false,
  };
  
  Map<String, bool> _conditionFilters = {
    '고혈압': false,
    '요통': false,
    '골다공증': false,
    '관절염': false,
    '우울증': false,
    '치매': false,
    '기타': false,
  };

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

  // 필터 섹션 빌드 메서드
  Widget _buildFilterSection(String title, Map<String, bool> filters, bool hasSelectAll) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (hasSelectAll)
              TextButton(
                onPressed: () => _toggleSelectAll(filters),
                child: const Text('전체선택'),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: filters.entries.map((entry) {
            return FilterChip(
              label: Text(entry.key),
              selected: entry.value,
              onSelected: (selected) {
                setState(() {
                  filters[entry.key] = selected;
                });
              },
              selectedColor: Colors.blue[100],
              checkmarkColor: Colors.blue[800],
            );
          }).toList(),
        ),
      ],
    );
  }

  // 전체선택 토글
  void _toggleSelectAll(Map<String, bool> filters) {
    bool allSelected = filters.values.every((value) => value);
    setState(() {
      for (String key in filters.keys) {
        filters[key] = !allSelected;
      }
    });
  }

  // 검색 실행 (1페이지)
  void _performSearch() {
    // 여기에 검색 로직을 구현할 수 있습니다
    _lastPage = false;
    final exerciseProvider = context.read<ExerciseProvider>();
    exerciseProvider.resetExercises();
    exerciseProvider.getExercisesData(_searchController.text);
    print('검색어: ${_searchController.text}');
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
      appBar: CustomAppbar(
        title: '영상 검색',
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          // 탭 바
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              onTap: (index) {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              tabs: const [
                Tab(text: '전체 검색'),
                Tab(text: '근육별 검색'),
              ],
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
            ),
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
        gradient: LinearGradient(
          colors: [Colors.white, Colors.yellow.shade100],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          // 검색창
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
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
                ElevatedButton.icon(
                  onPressed: _performSearch,
                  icon: const Icon(Icons.search),
                  label: const Text('검색'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // 필터 토글 버튼
          Container(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isFilterExpanded = !_isFilterExpanded;
                });
              },
              icon: Icon(_isFilterExpanded ? Icons.expand_less : Icons.expand_more),
              label: Text(_isFilterExpanded ? '조건 검색 접기' : '조건 검색 펼치기'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black87,
                elevation: 0,
              ),
            ),
          ),
          
          // 필터 섹션 (접기/펼치기 가능)
          if (_isFilterExpanded) ...[
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFilterSection('대상', _targetFilters, true),
                      const Divider(),
                      _buildFilterSection('체력항목', _fitnessFilters, false),
                      const Divider(),
                      _buildFilterSection('운동부위', _bodyPartFilters, false),
                      const Divider(),
                      _buildFilterSection('운동도구', _equipmentFilters, false),
                      const Divider(),
                      _buildFilterSection('질환', _conditionFilters, false),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          
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
        gradient: LinearGradient(
          colors: [Colors.white, Colors.red.shade100],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
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
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
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
                            return VideoCard(exercise: exercise);
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
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 50, 16, 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _isMuscleExpanded
                      ? BodyPartSelectorWidget(
                          onMusclesSelected: _onMusclesSelected,
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
