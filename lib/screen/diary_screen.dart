import 'package:flutter/material.dart';
import 'package:gukminexdiary/widget/custom_appbar.dart';
import 'package:gukminexdiary/widget/custom_drawer.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        title: '일기',
        automaticallyImplyLeading: true,
      ),
      body: const Center(
        child: Text(
          '일기 화면',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
