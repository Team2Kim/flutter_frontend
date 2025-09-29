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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
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
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('홈', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('일기', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pushNamed(context, '/diary');
            },
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('시설 검색', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pushNamed(context, '/facility/search');
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_library),
            title: const Text('영상 검색', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pushNamed(context, '/video/search');
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark),
            title: const Text('즐겨찾기', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pushNamed(context, '/bookmark');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('설정', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pushNamed(context, '/setting');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('로그아웃', style: TextStyle(fontSize: 18, color: Colors.red)),
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
        ],
      ),
    );
  }
}