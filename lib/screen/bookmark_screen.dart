import 'package:flutter/material.dart';
import 'package:gukminexdiary/widget/custom_appbar.dart';
import 'package:gukminexdiary/widget/video_card.dart';
import 'package:gukminexdiary/provider/exercise_provider.dart';
import 'package:provider/provider.dart';
import 'package:gukminexdiary/provider/bookmark_provider.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
final TextEditingController _searchController = TextEditingController();
  bool _isFilterExpanded = false; // 필터 섹션 접기/펼치기 상태
  
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final bookmarkProvider = context.read<BookmarkProvider>();
      await bookmarkProvider.getBookmarks();
    });
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

  // 검색 실행
  void _performSearch() {
    // 여기에 검색 로직을 구현할 수 있습니다
    print('검색어: ${_searchController.text}');
    print('선택된 필터들:');
    _printSelectedFilters('대상', _targetFilters);
    _printSelectedFilters('체력항목', _fitnessFilters);
    _printSelectedFilters('운동부위', _bodyPartFilters);
    _printSelectedFilters('운동도구', _equipmentFilters);
    _printSelectedFilters('질환', _conditionFilters);
  }

  void _printSelectedFilters(String category, Map<String, bool> filters) {
    List<String> selected = filters.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    if (selected.isNotEmpty) {
      print('$category: ${selected.join(', ')}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);
    return Scaffold(
      appBar: CustomAppbar(
        title: '즐겨찾기',
        automaticallyImplyLeading: true,
      ),
      body: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
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
                  itemCount: bookmarkProvider.bookmarks.length,
                  itemBuilder: (context, index) {
                    final exercise = bookmarkProvider.bookmarks[index];
                    return VideoCard(exercise: exercise);
                  },
                ),
              ),
          ],
        ),
      )
    );
  }
}