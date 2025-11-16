import 'package:flutter/material.dart';
import 'package:gukminexdiary/screen/home_screen.dart';
import 'package:gukminexdiary/screen/diary_screen.dart';
import 'package:gukminexdiary/screen/facility_search_screen.dart';
import 'package:gukminexdiary/screen/video_search_screen.dart';
import 'package:gukminexdiary/screen/bookmark_screen.dart';
import 'package:gukminexdiary/widget/bottom_navigation_bar.dart';
import 'package:gukminexdiary/widget/custom_appbar.dart';
import 'package:gukminexdiary/widget/custom_drawer.dart';

/// 앱 전체의 하단 네비게이션 + PageView 를 관리하는 루트 화면
class MainRootScreen extends StatefulWidget {
  const MainRootScreen({super.key});

  @override
  State<MainRootScreen> createState() => _MainRootScreenState();
}

class _MainRootScreenState extends State<MainRootScreen> {
  late final PageController _pageController;
  int _currentIndex = 2; // 기본 홈 탭 (0:시설, 1:영상, 2:홈, 3:일지, 4:즐겨찾기)

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavItemSelected(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar는 각 개별 페이지에서 가지고 있고,
      appBar: CustomAppbar(
        title: _currentIndex == 0
            ? '시설 검색'
            : _currentIndex == 1
                ? '영상 검색'
                : _currentIndex == 2
                    ? '홈'
                    : _currentIndex == 3
                        ? '운동 일지'
                        : '즐겨찾기',
        automaticallyImplyLeading: true,
      ),
      drawer: CustomDrawer(
        onTabSelected: _onNavItemSelected,
      ),
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
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(), // 손가락 스와이프 금지, 버튼으로만 이동
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: const [
            FacilitySearchScreen(),
            VideoSearchScreen(lastPage: false),
            HomeScreen(),
            DiaryScreen(),
            BookmarkScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: _currentIndex,
        onItemSelected: _onNavItemSelected,
      ),
    );
  }
}


