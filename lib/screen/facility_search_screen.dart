import 'package:flutter/material.dart';
import 'package:gukminexdiary/widget/custom_appbar.dart';
import 'package:gukminexdiary/widget/custom_drawer.dart';

class FacilitySearchScreen extends StatefulWidget {
  const FacilitySearchScreen({super.key});

  @override
  State<FacilitySearchScreen> createState() => _FacilitySearchScreenState();
}

class _FacilitySearchScreenState extends State<FacilitySearchScreen> {
  final TextEditingController _searchController = TextEditingController();
    void _performSearch() {
    // 여기에 검색 로직을 구현할 수 있습니다
    print('검색어: ${_searchController.text}');
    print('선택된 필터들:');
  }

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      appBar: CustomAppbar(
        title: '시설 검색',
        automaticallyImplyLeading: true,
      ),
      body: Container(
          padding: const EdgeInsets.all(20),
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
              // 영상 목록
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return Card(
                      borderOnForeground: false,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          child: const Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('강북체력인증센터', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                                  const Icon(Icons.video_library, size: 36,),
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
    );
  }
}