import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          ListTile(
            title: const Text('홈', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            title: const Text('일기', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pushNamed(context, '/diary');
            },
          ),
          ListTile(
            title: const Text('시설 검색', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pushNamed(context, '/facility/search');
            },
          ),
          ListTile(
            title: const Text('설정', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pushNamed(context, '/setting');
            },
          ),
          ListTile(
            title: const Text('영상 검색', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pushNamed(context, '/video/search');
            },
          ),
          ListTile(
            title: const Text('로그아웃', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pushNamed(context, '/auth');
            },
          ),
        ],
      ),
    );
  }
}