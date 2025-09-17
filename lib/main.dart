import 'package:flutter/material.dart';
import 'package:gukminexdiary/provider/auth_provider.dart';
import 'package:gukminexdiary/provider/facility_provider.dart';
import 'package:gukminexdiary/screen/home_screen.dart';
import 'package:gukminexdiary/screen/auth_screen.dart';
import 'package:gukminexdiary/screen/diary_screen.dart';
import 'package:gukminexdiary/screen/map_search_screen.dart';
import 'package:gukminexdiary/screen/facility_search_screen.dart';
import 'package:gukminexdiary/screen/setting_screen.dart';
import 'package:gukminexdiary/screen/video_search_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized(); // runApp 실행 이전이면 필요

  await FlutterNaverMap().init(
          clientId: '${dotenv.env['NAVER_MAP_CLIENT_ID']}',
          onAuthFailed: (ex) {
            switch (ex) {
              case NQuotaExceededException(:final message):
                print("사용량 초과 (message: $message)");
                break;
              case NUnauthorizedClientException() ||
              NClientUnspecifiedException() ||
              NAnotherAuthFailedException():
                print("인증 실패: $ex");
                break;
            }
          });
          
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
        ChangeNotifierProvider(create: (context) => FacilityProvider()),
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
          '/map/search': (context) => const MapSearchScreen(),
          '/setting': (context) => const SettingScreen(),
          '/video/search': (context) => const VideoSearchScreen()
        }
      )
    );
  }
}

