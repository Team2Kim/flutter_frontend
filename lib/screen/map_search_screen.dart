import 'package:flutter/material.dart';
import 'package:gukminexdiary/provider/facility_provider.dart';
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
  final PageController _pageController = PageController(viewportFraction: 0.95);
  NaverMapController? _mapController;
  NMarker? _myLocationMarker;
  NMarker? _focusedMarker;
  bool _isDown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final facilityProvider = Provider.of<FacilityProvider>(context, listen: false);
      _searchController.text = facilityProvider.keyword ?? '';
    });
  }
  
  void _performSearch() async {
    // 여기에 검색 로직을 구현할 수 있습니다
    print('검색어: ${_searchController.text}');
    print('선택된 필터들:');
    await _resetFacilityMarkers();
    final facilityProvider = Provider.of<FacilityProvider>(context, listen: false);
    await facilityProvider.searchFacilities(_searchController.text);
    await _updateFacilityMarkers();
    final cameraPosition = _mapController!.nowCameraPosition;
    facilityProvider.setFocusLocation(cameraPosition.target.latitude, cameraPosition.target.longitude);
    await _mapController!.updateCamera(
      NCameraUpdate.withParams(
        target: facilityProvider.focusLocation,
        zoom: 16,
      ),
    );
  }

  void _searchByCurrentLocation() async {
    final facilityProvider = Provider.of<FacilityProvider>(context, listen: false);
    await facilityProvider.searchNearbyFacilities();
    await _updateFacilityMarkers();
    final cameraPosition = _mapController!.nowCameraPosition;
    facilityProvider.setFocusLocation(cameraPosition.target.latitude, cameraPosition.target.longitude);

    
    // 지도 카메라를 현재 위치로 이동
    if (_mapController != null && facilityProvider.currentPosition != null) {
      await _mapController!.updateCamera(
        NCameraUpdate.withParams(
          target: NLatLng(
            facilityProvider.currentPosition!.latitude,
            facilityProvider.currentPosition!.longitude,
          ),
          zoom: 14,
        ),
      );
    }
  }

  void _searchByfocusLocation() async {
    final facilityProvider = Provider.of<FacilityProvider>(context, listen: false);
    final cameraPosition = _mapController!.nowCameraPosition;
    await facilityProvider.searchFacilitiesByMapCenter(cameraPosition.target.latitude, cameraPosition.target.longitude);
    await _updateFacilityMarkers();
  }

  Future<void> _updateFacilityMarkers() async {
    final facilityProvider = Provider.of<FacilityProvider>(context, listen: false);
    print('facilityProvider.locations.length: ${facilityProvider.locations.length}');
    for (int i = 0; i < facilityProvider.locations.length; i++) {
      final location = facilityProvider.locations[i];
      final marker = NMarker(
        size: NSize(20, 30),
        iconTintColor: const Color.fromARGB(255, 139, 139, 139),
        //icon: NOverlayImage.fromAssetImage('assets/images/sub_logo.png'),
        id: location.facilityId.toString(),
        position: NLatLng(location.latitude!, location.longitude!),
        caption: NOverlayCaption(text: location.name),
      );
      
      // 마커 클릭 이벤트 추가
      marker.setOnTapListener((overlay) async {
        facilityProvider.setFocusLocation(location.latitude!, location.longitude!);
        facilityProvider.setFocusLocationIndex(i);
        
        // ListView를 선택된 시설로 스크롤
        _pageController.jumpToPage(i);

        // 지도 카메라 업데이트
        await _mapController!.updateCamera(
          NCameraUpdate.withParams(
            target: NLatLng(location.latitude!, location.longitude!),
            zoom: 16,
          ),
        );
      });
      
      _mapController!.addOverlay(marker);
    }
  }

  Future<void> _resetFacilityMarkers() async {
    final facilityProvider = Provider.of<FacilityProvider>(context, listen: false);
    for (int i = 0; i < facilityProvider.locations.length; i++) {
      final location = facilityProvider.locations[i];
      _mapController!.deleteOverlay(NOverlayInfo(type: NOverlayType.marker, id: location.facilityId.toString()));
    }
  }

    Future<void> _updateFocusedMarker() async {
    final facilityProvider = Provider.of<FacilityProvider>(context, listen: false);
    _mapController!.deleteOverlay(NOverlayInfo(type: NOverlayType.marker, id: 'focusedMarker'));
    _focusedMarker = NMarker(
      iconTintColor: const Color.fromARGB(255, 17, 0, 255),
      size: NSize(30, 40),
      id: 'focusedMarker',
      position: NLatLng(facilityProvider.focusLocation.latitude, facilityProvider.focusLocation.longitude),
    );
    _mapController!.addOverlay(_focusedMarker!);
  }

  @override
  Widget build(BuildContext context) {  
    final facilityProvider = Provider.of<FacilityProvider>(context);
    final safeAreaPadding = EdgeInsets.zero;

    return Scaffold(
      appBar: CustomAppbar(
        title: '시설 검색',
        automaticallyImplyLeading: true,
      ),
      body: 
          Stack(
            children: [
              NaverMap(
                options: NaverMapViewOptions(
                  contentPadding: safeAreaPadding,
                  initialCameraPosition: NCameraPosition(target: facilityProvider.focusLocation, zoom: 14),
                ),
                onMapReady: (controller) {
                  _mapController = controller;
                  _myLocationMarker = NMarker(
                    iconTintColor: const Color.fromARGB(255, 0, 0, 0),
                    size: NSize(30, 40),
                    id: 'myLocationMarker',
                    position: NLatLng(facilityProvider.currentPosition!.latitude, facilityProvider.currentPosition!.longitude),
                    caption: NOverlayCaption(text: '내 위치'),
                  );
                  _mapController!.addOverlay(_myLocationMarker!);
                  _updateFocusedMarker();
                  print("naver map is ready!");
                  _updateFacilityMarkers();
                },
                onCameraIdle: () async {
                  final cameraPosition = _mapController!.nowCameraPosition;
                  // final target = cameraPosition?.target;
                  print('cameraPosition: ${cameraPosition}');
                  facilityProvider.setFocusLocation(cameraPosition.target.latitude, cameraPosition.target.longitude);
                  _updateFocusedMarker();
                },
              ),
             Container(
              padding: const EdgeInsets.all(20),
              child: 
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    // 시설 목록
                    Column(
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
                                      facilityProvider.setFocusLocation(facilityProvider.currentPosition!.latitude, facilityProvider.currentPosition!.longitude);
                                      facilityProvider.setFocusLocationIndex(0);            
                                      _updateFocusedMarker();
                                      await _resetFacilityMarkers();
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
                                    await _resetFacilityMarkers();
                                    _searchByfocusLocation();
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
                                  if (facilityProvider.focusLocationIndex != -1 && _pageController.hasClients) {
                                    _pageController.jumpToPage(facilityProvider.focusLocationIndex);
                                  }
                                });
                                
                                return PageView.builder(
                                  itemCount: facilityProvider.locations.length,
                                  controller: _pageController,
                                  scrollDirection: Axis.horizontal,
                                  onPageChanged: (index) async {
                                    facilityProvider.setFocusLocationIndex(index);
                                    facilityProvider.setFocusLocation(facilityProvider.locations[index].latitude!, facilityProvider.locations[index].longitude!);
                                    _updateFocusedMarker();
                                    _mapController!.updateCamera(
                                      NCameraUpdate.withParams(
                                        target: facilityProvider.focusLocation,
                                        zoom: 16,
                                      ),
                                    );
                                  },
                                  itemBuilder: (context, index) {
                                  final location = facilityProvider.locations.elementAt(index);
                                  return Container(
                                    margin: const EdgeInsets.only(right: 16),
                                    child: FacilityCard(width: MediaQuery.of(context).size.width * 0.9, location: location, onTap: () async {
                                    facilityProvider.setFocusLocation(location.latitude!, location.longitude!);
                                    facilityProvider.setFocusLocationIndex(index);
                                    
                                    // ListView를 선택된 시설로 스크롤
                                    _pageController.jumpToPage(index);
                    
                                    
                                    if (_mapController != null) {
                                      await _mapController!.updateCamera(
                                        NCameraUpdate.withParams(
                                          target: facilityProvider.focusLocation,
                                          zoom: 16,
                                        ),
                                      );
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
                    
                ],
              ),
              )
            ],
          ),
    );
  }
}