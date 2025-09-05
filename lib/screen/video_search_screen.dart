import 'package:flutter/material.dart';
import 'package:gukminexdiary/widget/custom_appbar.dart';
import 'package:gukminexdiary/widget/custom_drawer.dart';

class VideoSearchScreen extends StatefulWidget {
  const VideoSearchScreen({super.key});

  @override
  State<VideoSearchScreen> createState() => _VideoSearchScreenState();
}

class _VideoSearchScreenState extends State<VideoSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        title: '영상 검색',
        automaticallyImplyLeading: true,
      ),
      body: const Center(
        child: Text(
          '영상 검색 화면',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
