import 'package:flutter/material.dart';
import 'package:gukminexdiary/provider/facility_provider.dart';
import 'package:gukminexdiary/widget/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:gukminexdiary/widget/facility_card.dart';

class FacilitySearchScreen extends StatefulWidget {
  const FacilitySearchScreen({super.key});

  @override
  State<FacilitySearchScreen> createState() => _FacilitySearchScreenState();
}

class _FacilitySearchScreenState extends State<FacilitySearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _keywordController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<String> _keywords = [];
  int _type = 0; // 이름 검색 / 조건 검색색

  void _performSearch() async {
    // 여기에 검색 로직을 구현할 수 있습니다
    print('검색어: ${_searchController.text}');
    // print('선택된 필터들:');
    final facilityProvider = Provider.of<FacilityProvider>(context, listen: false);
    facilityProvider.searchFacilities(_searchController.text);
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final facilityProvider = Provider.of<FacilityProvider>(context, listen: false);
      await facilityProvider.searchNearbyFacilities();
      _searchController.text = facilityProvider.keyword ?? '';
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final facilityProvider = Provider.of<FacilityProvider>(context, listen: false);
      if (facilityProvider.hasMoreData && !facilityProvider.isLoadingMore) {
        facilityProvider.loadMoreFacilities();
      }
    }
  }
  


  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      appBar: CustomAppbar(
        title: '시설 검색',
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
                      child: _type == 0 ? TextFormField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: '검색어를 입력해주세요.',
                          border: InputBorder.none,
                        ),
                      ) : TextFormField(
                        controller: _keywordController,
                        onChanged: (value) {
                          if (value.endsWith(' ')) {
                            setState(() {
                              _keywords.add(value.trim());
                            });
                            _keywordController.clear();
                          }  
                        },
                        decoration: const InputDecoration(
                          hintText: '입력 후 띄어쓰기를 하면 조건이 추가됩니다.',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _type == 0 ? Colors.grey[800] : Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _type += 1;
                          _type %= 2;
                        });
                      },
                      child: _type == 0 ? const Text('이름', style: TextStyle(color: Colors.white)) : const Text('조건', style: TextStyle(color: Colors.white)),
                    ),
                    IconButton(
                      onPressed: _performSearch,
                      icon: const Icon(Icons.search),
                    ),
                  ],
                ),
              ),
              _type == 1 ?Container(
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(children: [
                  for (var keyword in _keywords)
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                      ),  
                      onPressed: () {
                      setState(() {
                        _keywords.remove(keyword);
                      });
                    }, child: Text('${keyword} X')),
                ],),
              ) : const SizedBox(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(onPressed: () {
                    Navigator.pushNamed(context, '/map/search');
                  }, icon: const Icon(Icons.map, size: 24,)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.search_outlined, size: 24,)),
                ],
              ),
              const SizedBox(height: 8),
              // 시설 목록
              Expanded(
                child: Consumer<FacilityProvider>(
                  builder: (context, facilityProvider, child) {
                    if (facilityProvider.isSearching && facilityProvider.locations.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (facilityProvider.locations.isEmpty) {
                      return const Center(
                        child: Text('근처에 시설이 없습니다.'),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: facilityProvider.locations.length + (facilityProvider.isLoadingMore ? 1 : 0),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        if (index == facilityProvider.locations.length) {
                          // 로딩 인디케이터
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final location = facilityProvider.locations[index];
                        return FacilityCard(
                          location: location, 
                          onTap: () {
                            facilityProvider.setFocusLocation(location.latitude!, location.longitude!);
                            facilityProvider.setFocusLocationIndex(index);
                            Navigator.pushNamed(context, '/map/search');
                          }, 
                          width: double.infinity
                        );
                      },
                    );
                  },
                ),  
              ),
          ],
        ),
      )
    );
  }
}