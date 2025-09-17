import 'package:flutter/material.dart';
import 'package:gukminexdiary/provider/facility_provider.dart';
import 'package:gukminexdiary/widget/custom_appbar.dart';
import 'package:gukminexdiary/widget/custom_drawer.dart';
import 'package:provider/provider.dart';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final facilityProvider = Provider.of<FacilityProvider>(context, listen: false);
      facilityProvider.getLocations();
    });
  }
  


  @override
  Widget build(BuildContext context) {  
    final facilityProvider = Provider.of<FacilityProvider>(context);
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
                  itemCount: facilityProvider.locations.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    final location = facilityProvider.locations[index];
                    return Card(
                      borderOnForeground: false,
                      child: InkWell(
                        onTap: () {
                          facilityProvider.setFocusLocation(location.latitude!, location.longitude!);
                          facilityProvider.setFocusLocationIndex(index);
                          Navigator.pushNamed(context, '/map/search');
                        },
                        child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(location.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                                    const Icon(Icons.video_library, size: 36,),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Column(
                                  children: [
                                  Text('주소: ${location.roadAddress ?? ''}', style: TextStyle(fontSize: 14,),),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                  Text('운영여부:', style: TextStyle(fontSize: 14,),),
                                  Text(location.status ?? '', style: TextStyle(fontSize: 14,),),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                  Text('TEL:', style: TextStyle(fontSize: 14,),),
                                  Text(location.phoneNumber ?? '', style: TextStyle(fontSize: 14,),),
                                  ],
                                ),
                              ],
                            )
                          ),
                        ),
                      )
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