import 'package:flutter/material.dart';
import 'package:gukminexdiary/model/facility_model.dart';
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
  final ScrollController _scrollController = ScrollController();
  NaverMapController? _mapController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final facilityProvider = Provider.of<FacilityProvider>(context, listen: false);
      facilityProvider.getLocations();
    });
  }
  
  void _performSearch() {
    // 여기에 검색 로직을 구현할 수 있습니다
    print('검색어: ${_searchController.text}');
    print('선택된 필터들:');
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
                  for (int i = 0; i < facilityProvider.locations.length; i++) {
                    final location = facilityProvider.locations[i];
                    final marker = NMarker(
                      icon: NOverlayImage.fromAssetImage('assets/images/sub_logo.png'),
                      id: location.name,
                      position: NLatLng(location.latitude!, location.longitude!),
                      caption: NOverlayCaption(text: location.name),
                    );
                    
                    // 마커 클릭 이벤트 추가
                    marker.setOnTapListener((overlay) async {
                      facilityProvider.setFocusLocation(location.latitude!, location.longitude!);
                      facilityProvider.setFocusLocationIndex(i);
                      
                      // ListView를 선택된 시설로 스크롤
                      _scrollController.animateTo(
                        MediaQuery.of(context).size.width * 0.8 * i,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      
                      // 지도 카메라 업데이트
                      await controller.updateCamera(
                        NCameraUpdate.withParams(
                          target: NLatLng(location.latitude!, location.longitude!),
                          zoom: 16,
                        ),
                      );
                    });
                    
                    controller.addOverlay(marker);
                  }
                  
                  print("naver map is ready!");
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
                              child: FacilityCard(width: MediaQuery.of(context).size.width * 0.8, location: location, onTap: () async {
                              facilityProvider.setFocusLocation(location.latitude!, location.longitude!);
                              facilityProvider.setFocusLocationIndex(index);
                              
                              // ListView를 선택된 시설로 스크롤
                              _scrollController.animateTo(
                                MediaQuery.of(context).size.width * 0.8 * index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                              
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
                              try {
                                facilityProvider.setGeoCoding(location);
                                final geocoding = facilityProvider.geoCoding;
                                print('지오코딩 정보: $geocoding');
                                print('지오코딩 정보: ${geocoding.addresses.first.roadAddress}');
                                print('지오코딩 정보: ${geocoding.addresses.first.jibunAddress}');
                                print('지오코딩 정보: ${geocoding.addresses.first.englishAddress}');
                                print('지오코딩 정보: ${geocoding.addresses.first.addressElements}');
                                for (var addressElement in geocoding.addresses.first.addressElements) {
                                  print('지오코딩 정보: ${addressElement.types}');
                                  print('지오코딩 정보: ${addressElement.longName}');
                                  print('지오코딩 정보: ${addressElement.shortName}');
                                  print('지오코딩 정보: ${addressElement.code}');
                                }
                                print('지오코딩 정보: ${geocoding.addresses.first.x}');
                                print('지오코딩 정보: ${geocoding.addresses.first.y}');
                                print('지오코딩 정보: ${geocoding.addresses.first.distance}');
                              } catch (e) {
                                print('지오코딩 오류: $e');
                                // 지오코딩 실패해도 맵 이동은 정상 동작
                              }
                            }));
                          },
                        );
                        },
                      ),
                    ),
                ],
              ),
              )
            ],
          ),
    );
  }
}