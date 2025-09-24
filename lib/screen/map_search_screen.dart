import 'package:flutter/material.dart';
import 'package:gukminexdiary/provider/facility_provider.dart';
import 'package:gukminexdiary/provider/naver_map_provider.dart';
import 'package:gukminexdiary/widget/custom_appbar.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:provider/provider.dart';
import 'package:gukminexdiary/widget/facility_card.dart';

class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({super.key});

  @override
  State<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isDown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final facilityProvider = Provider.of<FacilityProvider>(context, listen: false);
      final naverMapProvider = Provider.of<NaverMapProvider>(context, listen: false);
      
      if (!naverMapProvider.isMapReady) {
        await naverMapProvider.initMap(NCameraPosition(target: facilityProvider.focusLocation, zoom: 14));
        print('지도 초기화 완료');
      }

      if (mounted) {  
        await naverMapProvider.updateFacilityMarkers(context, facilityProvider, _scrollController);
      }
    });
  }
  
  void _performSearch() {
    // 여기에 검색 로직을 구현할 수 있습니다
    print('검색어: ${_searchController.text}');
    print('선택된 필터들:');
  }

  void _searchByCurrentLocation() async {
    final facilityProvider = Provider.of<FacilityProvider>(context, listen: false);
    final naverMapProvider = Provider.of<NaverMapProvider>(context, listen: false);
    
    if (naverMapProvider.isMapReady) {
      await naverMapProvider.resetFacilityMarkers(facilityProvider);
      await facilityProvider.searchNearbyFacilities();
      if (mounted) {   // 현재 위치 기반 시설 검색
        await naverMapProvider.updateFacilityMarkers(context, facilityProvider, _scrollController);
      }
    }
  }

  void _searchByFocusLocation() async {
    final facilityProvider = Provider.of<FacilityProvider>(context, listen: false);
    final naverMapProvider = Provider.of<NaverMapProvider>(context, listen: false);
    final cameraPosition = naverMapProvider.focusedCameraPosition; 
    
    if (cameraPosition != null) {
      if (naverMapProvider.isMapReady) {
        await naverMapProvider.resetFacilityMarkers(facilityProvider);
        await facilityProvider.searchFacilitiesByMapCenter(cameraPosition.target.latitude, cameraPosition.target.longitude);
        if (mounted) {
          await naverMapProvider.updateFacilityMarkers(context, facilityProvider, _scrollController);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {  
    final facilityProvider = Provider.of<FacilityProvider>(context);
    final naverMapProvider = Provider.of<NaverMapProvider>(context);

    return Scaffold(
      appBar: CustomAppbar(
        title: '시설 검색',
        automaticallyImplyLeading: true,
      ),
      body: Stack(
        children: [
          // 지도
          if (naverMapProvider.isMapReady)
            naverMapProvider.map!
          else
            const Center(child: CircularProgressIndicator()),
          
          // UI 컨트롤들
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
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
                ],
              ),
            ),
          ),
          
          // 하단 시설 목록
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                        // 현재 위치 기반 재검색 버튼
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      _searchByCurrentLocation();
                                    },
                                    icon: const Icon(Icons.location_on),
                                    label: const Text('내 위치로 검색'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(255, 30, 229, 113),
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isDown = !_isDown;
                                    });
                                  },
                                  icon: Icon(_isDown ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                                ),
                                Expanded(
                                  child: ElevatedButton.icon(
                                  onPressed: () async {
                                    _searchByFocusLocation();
                                  },
                                  icon: const Icon(Icons.my_location),
                                  label: const Text('현 위치로 검색'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[600],
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!_isDown)
                          Container(
                            height: MediaQuery.of(context).size.height * 0.235,
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Consumer<FacilityProvider>(
                              builder: (context, facilityProvider, child) {
                                // focusLocationIndex가 변경되면 ListView 스크롤
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  if (facilityProvider.focusLocationIndex != -1 && _scrollController.hasClients) {
                                    _scrollController.animateTo(
                                      MediaQuery.of(context).size.width * 0.8 * facilityProvider.focusLocationIndex,
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                });
                                
                                return ListView.builder(
                                  itemCount: facilityProvider.locations.length,
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                  final location = facilityProvider.locations.elementAt(index);
                                  return Container(
                                    margin: const EdgeInsets.only(right: 16),
                                    child: FacilityCard(width: MediaQuery.of(context).size.width * 0.9, location: location, onTap: () async {
                                    facilityProvider.setFocusLocation(location.latitude!, location.longitude!);
                                    facilityProvider.setFocusLocationIndex(index);
                                    
                                    // ListView를 선택된 시설로 스크롤
                                    _scrollController.animateTo(
                                      MediaQuery.of(context).size.width * index,
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                            
                                    if (naverMapProvider.isMapReady) {
                                      naverMapProvider.setFocusLocation(NLatLng(location.latitude!, location.longitude!), facilityProvider);
                                    }
                                    // 지오코딩 정보 가져오기 (선택사항)
                                    // API 키가 설정되어 있을 때만 호출
                                    // try {
                                    //   facilityProvider.setGeoCoding(location);
                                    //   final geocoding = facilityProvider.geoCoding;
                                    //   print('지오코딩 정보: $geocoding');
                                    //   print('지오코딩 정보: ${geocoding.addresses.first.roadAddress}');
                                    //   print('지오코딩 정보: ${geocoding.addresses.first.jibunAddress}');
                                    //   print('지오코딩 정보: ${geocoding.addresses.first.englishAddress}');
                                    //   print('지오코딩 정보: ${geocoding.addresses.first.addressElements}');
                                    //   for (var addressElement in geocoding.addresses.first.addressElements) {
                                    //     print('지오코딩 정보: ${addressElement.types}');
                                    //     print('지오코딩 정보: ${addressElement.longName}');
                                    //     print('지오코딩 정보: ${addressElement.shortName}');
                                    //     print('지오코딩 정보: ${addressElement.code}');
                                    //   }
                                    //   print('지오코딩 정보: ${geocoding.addresses.first.x}');
                                    //   print('지오코딩 정보: ${geocoding.addresses.first.y}');
                                    //   print('지오코딩 정보: ${geocoding.addresses.first.distance}');
                                    // } catch (e) {
                                    //   print('지오코딩 오류: $e');
                                    //   // 지오코딩 실패해도 맵 이동은 정상 동작
                                    // }
                                  }));
                                },
                              );
                              },
                            ),
                          ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}