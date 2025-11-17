import 'package:flutter/material.dart';
import 'package:gukminexdiary/provider/facility_provider.dart';
import 'package:provider/provider.dart';
import 'package:gukminexdiary/widget/facility_card.dart';
import 'package:gukminexdiary/widget/facility_search_bar.dart';

class FacilitySearchScreen extends StatefulWidget {
  const FacilitySearchScreen({super.key});

  @override
  State<FacilitySearchScreen> createState() => _FacilitySearchScreenState();
}

class _FacilitySearchScreenState extends State<FacilitySearchScreen> with AutomaticKeepAliveClientMixin {
  // final TextEditingController _searchController = TextEditingController();
  // final TextEditingController _keywordController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  // List<String> _keywords = [];
  // int _type = 0; // 이름 검색 / 조건 검색

  void _performSearch() async {
    // 여기에 검색 로직을 구현할 수 있습니다
    // print('검색어: ${facilityProvider.searchController.text}');
    // print('선택된 필터들:');
    final facilityProvider = Provider.of<FacilityProvider>(context, listen: false);
    facilityProvider.searchFacilities(facilityProvider.searchController.text);
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final facilityProvider = Provider.of<FacilityProvider>(context, listen: false);
      await facilityProvider.searchNearbyFacilities();
      facilityProvider.resetKeyword();
      facilityProvider.searchController.text = facilityProvider.keyword ?? '';
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
    super.build(context);
    return Scaffold(
      // appBar: CustomAppbar(
      //   title: '시설 검색',
      //   automaticallyImplyLeading: true,
      // ),
      body: Container(
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
              FacilitySearchBar(
                onSearch: _performSearch,
              ),
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
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                          child:FacilityCard(
                          location: location, 
                          onTap: () {
                            facilityProvider.setFocusLocation(location.latitude!, location.longitude!);
                            facilityProvider.setFocusLocationIndex(index);
                            Navigator.pushNamed(context, '/map/search');
                          }, 
                          width: double.infinity
                        ));
                      },
                    );
                  },
                ),  
              ),
              const Text("한 번에 20개씩 3km 이내 시설만 검색됩니다.", style: TextStyle(fontSize: 12, color: Colors.grey),),
          ],
        ),
      )
    );
  }

  @override
  bool get wantKeepAlive => true;
}