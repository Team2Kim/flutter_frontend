import 'package:flutter/material.dart';
import 'package:gukminexdiary/model/facility_model.dart';
import 'package:gukminexdiary/services/facility_service.dart';
import 'package:gukminexdiary/widget/custom_appbar.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({super.key});

  @override
  State<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  var focusLocation = NLatLng(37.6304351, 127.0378089);
  List<FacilityModelResponse> locations = [];
  final FacilityService _facilityService = FacilityService();
  NaverMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _getLocations();
  }

  void _getLocations() async {
    var fetchedLocations = await _facilityService.getFacilities_example();
    setState(() {
      locations = fetchedLocations;
      // 첫 번째 시설을 초기 위치로 설정
      if (locations.isNotEmpty) {
        focusLocation = NLatLng(locations.first.latitude!, locations.first.longitude!);
      }
    });
  }

  
  void _performSearch() {
    // 여기에 검색 로직을 구현할 수 있습니다
    print('검색어: ${_searchController.text}');
    print('선택된 필터들:');
  }

  @override
  Widget build(BuildContext context) {  
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
                  initialCameraPosition: NCameraPosition(target: focusLocation, zoom: 14),
                ),
                onMapReady: (controller) {
                  _mapController = controller;
                  for (var location in locations) {
                    final marker = NMarker(
                      icon: NOverlayImage.fromAssetImage('assets/images/sub_logo.png'),
                      id: location.name,
                      position: NLatLng(location.latitude!, location.longitude!),
                      caption: NOverlayCaption(text: location.name),
                    );
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
                      height: MediaQuery.of(context).size.height * 0.2,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListView.builder(
                        itemCount: locations.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                            final location = locations.elementAt(index);
                            return Card(
                              borderOnForeground: false,
                              child: InkWell (
                                onTap: () async {
                                  focusLocation = NLatLng(location.latitude!, location.longitude!);
                                  if (_mapController != null) {
                                    await _mapController!.updateCamera(
                                      NCameraUpdate.withParams(
                                        target: focusLocation,
                                        zoom: 16,
                                      ),
                                    );
                                  }
                                  // 지오코딩 정보 가져오기 (선택사항)
                                  // API 키가 설정되어 있을 때만 호출
                                  try {
                                    final geocoding = await _facilityService.getGeoCoding(location);
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
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(location.name, style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                       Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           Text('주소: ${location.roadAddress!}', style: TextStyle(fontSize: 14,),),
                                         ],  
                                       ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                        Text('운영여부:', style: TextStyle(fontSize: 14,),),
                                        Text(location.status!, style: TextStyle(fontSize: 14,),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('TEL:', style: TextStyle(fontSize: 14,),),
                                          Text(location.phoneNumber as String, style: TextStyle(fontSize: 14,),),
                                        ],
                                      ),
                                    ],
                                  )
                                  ),
                              ),
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