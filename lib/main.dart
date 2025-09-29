import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screens.dart'; // 모든 화면, 위젯, 상수를 통합한 파일
import 'constants.dart'; // 별도의 상수 파일
import 'package:intl/date_symbol_data_local.dart';
import 'dart:io';

// HTTP 오버라이드 클래스 추가
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // HTTP 오버라이드 설정 (네트워크 보안을 위해)
  HttpOverrides.global = MyHttpOverrides();

  await initializeDateFormatting('ko_KR', null); // 이 코드를 추가
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashWrapper(), // SplashWrapper로 시작
    );
  }
}

// 스플래시 래퍼 클래스
class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  @override
  void initState() {
    super.initState();
    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    // 최소 3초간 스플래시 표시
    await Future.delayed(const Duration(seconds: 3));

    // Firebase 인증 상태 확인 - 주석 처리
    // final user = FirebaseAuth.instance.currentUser;

    if (mounted) {
      // 로그인 체크 없이 바로 MainScreen으로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );

      // 기존 로그인 체크 코드 주석 처리
      // if (user != null) {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => const MainScreen()),
      //   );
      // } else {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => const AuthScreen()),
      //   );
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}