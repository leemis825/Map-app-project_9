// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'user_provider.dart';
import 'screens/login_screen.dart';
import 'screens/campus_map_screen.dart';
import 'widgets/responsive_layout.dart';

// (Firebase 설정 파일이 있는 경우) 아래 두 줄을 필요에 맞게 추가하세요.
import 'firebase_options.dart';
import 'firebase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // == (1) Firebase 초기화 ==
  // Firebase.initializeApp 호출 부분은 프로젝트 환경에 따라 옵션을 넣어주세요.
  // 예) await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Firebase 사용 안 한다면 이 부분을 제거해도 됩니다.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ✅ JSON에서 학생 데이터 업로드(학생 정보 업데이트 사항 없을 시 주석 처리 해도 됨)
  await uploadStudentsFromJson();

  // == (2) 앱 실행: UserProvider를 최상단에 올려서 MyApp 감싸기 ==
  runApp(
    ChangeNotifierProvider(create: (_) => UserProvider(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provider가 여기서 이미 등록된 상태임
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '조선대학교 캠퍼스 지도',
      // 반응형 레이아웃 적용 (있다면)
      builder: (context, child) => ResponsiveLayout(child: child!),

      // 앱을 실행하면 제일 먼저 LoginScreen을 띄우겠다.
      home: const LoginScreen(),

      // 필요하다면 Named Route 추가
      routes: {
        '/campus_map': (context) => const CampusMapScreen(),
        // '/qr_navigate': (context) => const QrNavigateScreen(),
      },
    );
  }
}
