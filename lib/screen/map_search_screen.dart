import 'package:flutter/material.dart';
import 'package:gukminexdiary/widget/custom_appbar.dart';
import 'package:gukminexdiary/widget/custom_drawer.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({super.key});

  @override
  State<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final location = NLatLng(37.6304351, 127.0378089);
  Map<String, dynamic> locations = {
    'Ansan_Fitness_Center': {
      'address': '경기 안산시 상록구 한양대학로 55',
      'operation_time': '평일 09:00~18:00',
      'tel': '0507-1324-8052',
      'location': NLatLng(37.2967403, 126.8352371),
      'name': '안산체력인증센터',
    },
    'Suwon_Fitness_Center': {
      'address': '경기 수원시 영통구 광교산로 154-42 경기대학교 성신관2강의동 지하2003호',
      'operation_time': '평일 09:00~18:00',
      'tel': '0507-1359-1485',
      'location': NLatLng(37.2996813, 127.0335522),
      'name': '수원체력인증센터',
    },
    'Hwasung_Fitness_Center': {
      'address': '경기도 화성시 봉담읍 동화리 18 406-1) 화성국민체육센터 B1',
      'operation_time': '평일 09:00~18:00',
      'tel': '031-278-7548',
      'location': NLatLng(37.2208397, 126.9517371),
      'name': '화성체력인증센터',
    },
  };
  
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
                  initialCameraPosition: NCameraPosition(target: location, zoom: 14),
                ),
                onMapReady: (controller) {
                  for (var location in locations.values) {
                    final marker = NMarker(
                      icon: NOverlayImage.fromAssetImage('assets/images/sub_logo.png'),
                      id: location['name'],
                      position: location['location'],
                      caption: NOverlayCaption(text: location['name']),
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

                    // 영상 목록
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListView.builder(
                        itemCount: locations.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                            final location = locations.values.elementAt(index);
                            return Card(
                              borderOnForeground: false,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(location['name'] as String, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                        Text('주소:', style: TextStyle(fontSize: 14,),),
                                        Text(location['address'] as String, style: TextStyle(fontSize: 14,),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                        Text('운영시간:', style: TextStyle(fontSize: 14,),),
                                        Text(location['operation_time'] as String, style: TextStyle(fontSize: 14,),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('TEL:', style: TextStyle(fontSize: 14,),),
                                          Text(location['tel'] as String, style: TextStyle(fontSize: 14,),),
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