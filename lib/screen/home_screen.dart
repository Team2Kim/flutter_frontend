import 'package:flutter/material.dart';
import 'package:gukminexdiary/widget/custom_appbar.dart';
import 'package:gukminexdiary/widget/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        title: '홈',
        automaticallyImplyLeading: true,
      ),
      drawer: const CustomDrawer(),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '검색',
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: ListView(
              children: [
                Card(
                  child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/facility/search');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade50, Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset('assets/icons/gym.png', width: 25, height: 25,),
                            const Text('시설 검색', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                          ],
                      ),
                    ),  
                  ),
                ),
                SizedBox(height: 10),
                const Row(children: [Text("운동 검색", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),],),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Card( 
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/video/search/name');
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.yellow.shade100, Colors.white],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.yellow.shade100),
                                ),
                                padding: const EdgeInsets.all(20),
                                child: 
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.video_library, size: 25,),
                                    Text('이름 검색', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                  ],
                              ),
                            ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                      child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/video/search/muscle');
                          },
                        child:
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.red.shade100, Colors.white],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.red.shade100),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset('assets/icons/muscle.png', width: 25, height: 25,),
                                const Text('근육 검색', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
                ),
                Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/diary');
                    },
                    child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade100, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.green.shade100),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Image.asset('assets/icons/diary.png', width: 50, height: 50,),
                        const Text('AI 운동 일지', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                  )
                ),
                Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/bookmark');
                    },
                  child:
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.purple.shade100, Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.purple.shade100),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.bookmark, size: 50,),
                          Text('즐겨찾기', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                  ),
                ),
                // Card(
                //   child: InkWell(
                //     onTap: () {
                //       Navigator.pushNamed(context, '/api/test');
                //     },
                //   child:
                //     Container(
                //       padding: const EdgeInsets.all(20),
                //       child: const Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Icon(Icons.api, size: 50,),
                //           Text('API 테스트', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),),
            Image.asset('assets/images/main_logo.png', width: 100, height: 100),
          ],
        )
      ),
    );
  }
}