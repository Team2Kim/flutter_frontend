import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gukminexdiary/provider/auth_provider.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Future<void> _handleLogout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/auth');
    }
  }

  // 화면 네비게이션 헬퍼 메서드
  // 홈을 루트로 유지하고 해당 화면으로 이동 (스택 중복 방지)
  void _navigateToScreen(BuildContext context, String routeName) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    
    // 이미 해당 화면이면 아무것도 하지 않음 (Drawer만 닫힘)
    if (currentRoute == routeName) {
      return;
    }

    // 항상 홈을 루트로 만들고 해당 화면으로 이동
    // 1. 모든 스택을 제거하고 홈으로 이동
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (route) => false,
    );
    
    // 2. 다음 프레임에서 해당 화면으로 push (홈이 먼저 렌더링된 후)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Navigator.pushNamed(context, routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 107, 125, 223), const Color.fromARGB(255, 167, 174, 210)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          children: [
            const DrawerHeader(
              margin: EdgeInsets.zero,
              child: Center(
                child: Text(
                  '국민체력 일기장',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(91, 255, 255, 255),
              ),
              child: ListTile(
                leading: const Icon(Icons.home, color: Colors.white),
                title: const Text('홈', style: TextStyle(fontSize: 18, color: Colors.white)),
                onTap: () {
                  Navigator.of(context).pop(); // Drawer 닫기
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false, // 모든 이전 라우트 제거
                  );
                },
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(91, 255, 255, 255), 
                border: Border(top: BorderSide(color: Color.fromARGB(101, 255, 255, 255), width: 1)),
              ),
              child: ListTile(
                leading: const Icon(Icons.book, color: Colors.white),
                title: const Text('AI 운동 일지', style: TextStyle(fontSize: 18, color: Colors.white)),
                onTap: () {
                  Navigator.of(context).pop(); // Drawer 닫기
                  _navigateToScreen(context, '/diary');
                },
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(91, 255, 255, 255),
                border: Border(top: BorderSide(color: Color.fromARGB(101, 255, 255, 255), width: 1)),
              ),
              child: ListTile(
                leading: const Icon(Icons.search, color: Colors.white),
                title: const Text('시설 검색', style: TextStyle(fontSize: 18, color: Colors.white)),
                onTap: () {
                  Navigator.of(context).pop(); // Drawer 닫기
                  _navigateToScreen(context, '/facility/search');
                },
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(91, 255, 255, 255),
                border: Border(top: BorderSide(color: Color.fromARGB(101, 255, 255, 255), width: 1)),
              ),
              child: ListTile(
                leading: const Icon(Icons.video_library, color: Colors.white),
                title: const Text('운동 검색', style: TextStyle(fontSize: 18, color: Colors.white)),
                onTap: () {
                  Navigator.of(context).pop(); // Drawer 닫기
                  _navigateToScreen(context, '/video/search/name');
                },
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(91, 255, 255, 255),
                border: Border(top: BorderSide(color: Color.fromARGB(101, 255, 255, 255), width: 1)),
              ),
              child: ListTile(
                leading: const Icon(Icons.bookmark, color: Colors.white),
                title: const Text('즐겨찾기', style: TextStyle(fontSize: 18, color: Colors.white)),
                onTap: () {
                  Navigator.of(context).pop(); // Drawer 닫기
                  _navigateToScreen(context, '/bookmark');
                },
              ),
            ),          
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(91, 255, 255, 255),
                border: Border(top: BorderSide(color: Color.fromARGB(101, 255, 255, 255), width: 1)),
              ),
              child: ListTile(
                leading: const Icon(Icons.settings, color: Colors.white),
                title: const Text('설정', style: TextStyle(fontSize: 18, color: Colors.white)),
                onTap: () {
                  Navigator.of(context).pop(); // Drawer 닫기
                  _navigateToScreen(context, '/setting');
                },
              ),
            ),
            // const Divider(),
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(91, 0, 0, 0),
              ),
              child: ListTile(
              leading: const Icon(Icons.logout, color: Color.fromARGB(255, 252, 142, 134)),
              title: const Text('로그아웃', style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 252, 142, 134))),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('로그아웃'),
                      content: const Text('정말 로그아웃하시겠습니까?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('취소'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _handleLogout();
                          },
                          child: const Text('로그아웃', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ),
            Image.asset('assets/images/main_logo.png', width: 150, height: 100),
          ],
        ),
      )
    );
  }
}