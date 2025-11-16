import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  State<BottomNavigationBarWidget> createState() => _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
          // padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 80,
            padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 0),
            child: Row(
              children: [
                Expanded(child: ElevatedButton(
                  onPressed: () {}, 
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, 
                    children: [Image.asset('assets/icons/gym.png', width: 20, height: 20,), 
                    Text('시설 검색', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),)],),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                    ),
                  ),
                )),  
                Expanded(child: ElevatedButton(
                  onPressed: () {}, 
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.video_library), Text('운동 검색', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),)],),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                )),
                Expanded(child: ElevatedButton(
                  onPressed: () {}, 
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, 
                    children: [Icon(Icons.home), Text('홈', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),)],
                    ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                )),
                Expanded(child: ElevatedButton(
                  onPressed: () {}, 
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, 
                    children: [
                      Image.asset('assets/icons/diary.png', width: 20, height: 20,),
                      Text('AI 일지', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),)
                    ],),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                )),
                Expanded(child: ElevatedButton(
                  onPressed: () {}, 
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, 
                    children: [
                      Icon(Icons.bookmark), 
                      Text('즐겨찾기', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),)
                    ],),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                    ),
                  ),
                )),
              ],
            )
          )
    );
  }
}