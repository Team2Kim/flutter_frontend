import 'package:flutter/material.dart';
import 'package:gukminexdiary/widget/custom_appbar.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: '북마크', automaticallyImplyLeading: true),
      body: Center(child: Text('북마크 화면')),
    );
  }
}