import 'package:flutter/material.dart';
import 'package:gukminexdiary/provider/navigation_provider.dart';
import 'package:gukminexdiary/screen/home_screen.dart';
import 'package:gukminexdiary/screen/diary_screen.dart';
import 'package:gukminexdiary/screen/facility_search_screen.dart';
import 'package:gukminexdiary/screen/video_search_screen.dart';
import 'package:gukminexdiary/screen/bookmark_screen.dart';
import 'package:gukminexdiary/widget/bottom_navigation_bar.dart';
import 'package:gukminexdiary/widget/custom_appbar.dart';
import 'package:gukminexdiary/widget/custom_drawer.dart';
import 'package:provider/provider.dart';

/// 앱 전체의 하단 네비게이션 + PageView 를 관리하는 루트 화면
class MainRootScreen extends StatefulWidget {
  const MainRootScreen({super.key});

  @override
  State<MainRootScreen> createState() => _MainRootScreenState();
}

class _MainRootScreenState extends State<MainRootScreen> {
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = const [
      FacilitySearchScreen(),
      VideoSearchScreen(lastPage: false),
      HomeScreen(),
      DiaryScreen(),
      BookmarkScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = context.watch<NavigationProvider>();
    final currentIndex = navigationProvider.currentIndex;

    return Scaffold(
      // AppBar는 각 개별 페이지에서 가지고 있고,
      appBar: CustomAppbar(
        title: currentIndex == NavigationProvider.facilityIndex
            ? '시설 검색'
            : currentIndex == NavigationProvider.videoSearchIndex
                ? '영상 검색'
                : currentIndex == NavigationProvider.homeIndex
                    ? '홈'
                    : currentIndex == NavigationProvider.diaryIndex
                        ? '운동 일지'
                        : '즐겨찾기',
        automaticallyImplyLeading: true,
      ),
      drawer: const CustomDrawer(),
      extendBody: true, // body를 네비게이션 바 뒤까지 확장
      backgroundColor: const Color.fromRGBO(241, 248, 255, 1),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.white, Color.fromRGBO(241, 248, 255, 1)],
            radius: 0.5,
            stops: [0.3, 0.7],
          ),
        ),
        child: PageView(
          controller: navigationProvider.pageController,
          physics: const NeverScrollableScrollPhysics(), // 손가락 스와이프 금지, 버튼으로만 이동
          onPageChanged: navigationProvider.handlePageChanged,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: currentIndex,
        onItemSelected: (index) {
          if (index == NavigationProvider.facilityIndex) {
            showDialog(context: context, builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white, width: 1),  
                borderRadius: BorderRadius.circular(10),
              ),
              surfaceTintColor: const Color.fromARGB(255, 172, 172, 172),
              backgroundColor: const Color.fromARGB(255, 107, 125, 223),
              title: Text('준비 중', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              content: Text('현재 준비 중인 기능입니다.', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal)),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: Text('확인', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal))),
              ],
            ));
          } else {
            context.read<NavigationProvider>().goTo(index);
          }
        },
      ),
    );
  }
}


