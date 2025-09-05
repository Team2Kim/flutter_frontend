import 'package:flutter/material.dart';
import 'package:gukminexdiary/widget/custom_appbar.dart';
import 'package:gukminexdiary/widget/custom_drawer.dart';

class FacilitySearchScreen extends StatefulWidget {
  const FacilitySearchScreen({super.key});

  @override
  State<FacilitySearchScreen> createState() => _FacilitySearchScreenState();
}

class _FacilitySearchScreenState extends State<FacilitySearchScreen> {
  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      appBar: const CustomAppbar(
        title: '시설 검색',
        automaticallyImplyLeading: true,
      ),
      body: const Center(
        child: Text(
          '시설 검색 화면',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}