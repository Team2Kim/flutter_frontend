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
                  final marker = NMarker(
                    icon: NOverlayImage.fromAssetImage('assets/images/sub_logo.png'),
                    id: "Gangbuk_Fitness_Center",
                    position: location,
                    caption: NOverlayCaption(text: "강북체력인증센터"),
                  );
                  controller.addOverlay(marker);
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
                        scrollDirection: Axis.horizontal,
                        itemCount: 3, // 고정된 개수 추가
                        itemBuilder: (context, index) {
                            return Card(
                              borderOnForeground: false,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                child: Container(
                                  child: const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('강북체력인증센터', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                        Text('주소:', style: TextStyle(fontSize: 14,),),
                                        Text('서울특별시 강북구 오현로31길 51 (번동) 3층', style: TextStyle(fontSize: 14,),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                        Text('운영시간:', style: TextStyle(fontSize: 14,),),
                                        Text('평일 09:00~18:00', style: TextStyle(fontSize: 14,),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                        Text('TEL:', style: TextStyle(fontSize: 14,),),
                                        Text('02-980-0101', style: TextStyle(fontSize: 14,),),
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