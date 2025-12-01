import 'package:flutter/material.dart';
import 'package:gukminexdiary/provider/auth_provider.dart';
import 'package:gukminexdiary/provider/facility_provider.dart';
import 'package:gukminexdiary/screen/auth_screen.dart';
import 'package:gukminexdiary/screen/diary_screen.dart';
import 'package:gukminexdiary/screen/map_search_screen.dart';
import 'package:gukminexdiary/screen/facility_search_screen.dart';
import 'package:gukminexdiary/screen/setting_screen.dart';
import 'package:gukminexdiary/screen/video_search_screen.dart';
import 'package:gukminexdiary/provider/exercise_provider.dart';
import 'package:gukminexdiary/provider/bookmark_provider.dart';
import 'package:gukminexdiary/provider/navigation_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gukminexdiary/screen/bookmark_screen.dart';
import 'package:gukminexdiary/screen/muscle_selector_screen.dart';
import 'package:gukminexdiary/screen/api_test_screen.dart';
import 'package:gukminexdiary/screen/main_root_screen.dart';
import 'package:gukminexdiary/screen/privacy_consent_screen.dart';
import 'package:flutter/services.dart';

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // 앱 시작 시 인증 상태 확인
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top], // 상단 상태 바만 보이도록 설정
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => FacilityProvider()),
        ChangeNotifierProvider(create: (context) => ExerciseProvider()),
        ChangeNotifierProvider(create: (context) => BookmarkProvider()),
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp(
            title: '국민체력 일기장',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
              fontFamily: 'Pretendard',
            ),
            home: authProvider.isAuthenticated ? const MainRootScreen() : const AuthScreen(),
            routes: {
              '/auth': (context) => const AuthScreen(),
              '/home': (context) => const MainRootScreen(),
              '/diary': (context) => const DiaryScreen(),
              '/facility/search': (context) => const FacilitySearchScreen(),
              '/map/search': (context) => const MapSearchScreen(),
              '/setting': (context) => const SettingScreen(),
              '/video/search/name': (context) => const VideoSearchScreen(lastPage: false),
              '/video/search/muscle': (context) => const VideoSearchScreen(lastPage: true),
              '/bookmark': (context) => const BookmarkScreen(),
              // '/muscle/selector': (context) => const MuscleSelectorScreen(),
              '/muscle/selector': (context) => const MuscleSelectorScreen(),
              '/api/test': (context) => const ApiTestScreen(),
              '/privacy/consent': (context) => const PrivacyConsentScreen(),
            },
          );
        },
      ),
    );
  }
}

