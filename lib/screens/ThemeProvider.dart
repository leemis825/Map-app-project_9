import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // 현재 테마 모드 상태를 저장 (기본값은 다크 모드)
  ThemeMode _themeMode = ThemeMode.dark;

  // 테마 모드 가져오기
  ThemeMode get themeMode => _themeMode;

  // 테마 모드 변경 함수
  void toggleTheme() {
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }
    notifyListeners(); // 상태가 변경되었음을 알림
  }
}
