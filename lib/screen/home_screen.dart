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
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
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
              flex: 3,
              child: ListView(
              children: [
                Card(
                  child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/facility/search');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.search, size: 50,),
                            Text('시설 검색', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                          ],
                      ),
                    ),  
                  ),
                ),
                Card( 
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/video/search');
                    },
                    child: Container(
                        padding: const EdgeInsets.all(20),
                        child: 
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.video_library, size: 50,),
                            Text('영상 검색', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                          ],
                      ),
                    ),
                ),
                ),
                Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/diary');
                    },
                    child: Container(
                    padding: const EdgeInsets.all(20),
                    child: 
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Icon(Icons.fitness_center, size: 50,),
                        Text('운동 일지', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
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
              ],
            ),),
            Image.asset('assets/images/main_logo.png', width: 100, height: 100),
          ],
        )
      ),
    );
  }
}