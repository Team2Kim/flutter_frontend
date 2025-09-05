import 'package:flutter/material.dart';
import 'package:gukminexdiary/provider/auth_provider.dart';
import 'package:gukminexdiary/screen/home_screen.dart';
import 'package:gukminexdiary/screen/auth_screen.dart';
import 'package:gukminexdiary/screen/diary_screen.dart';
import 'package:gukminexdiary/screen/facility_search_screen.dart';
import 'package:gukminexdiary/screen/setting_screen.dart';
import 'package:gukminexdiary/screen/video_search_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: MaterialApp(
        title: '국민체력 일기장',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
        routes: {
          '/auth': (context) => const AuthScreen(),
          '/home': (context) => const HomeScreen(),
          '/diary': (context) => const DiaryScreen(),
          '/facility/search': (context) => const FacilitySearchScreen(),
          '/setting': (context) => const SettingScreen(),
          '/video/search': (context) => const VideoSearchScreen()
        }
      )
    );
  }
}

