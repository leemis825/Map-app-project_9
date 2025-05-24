// lib/utils/floor_screen_router.dart

import 'package:flutter/material.dart';

// 각 층별 도면 화면 import
import '../screens/it_building_1f_screen.dart';
import '../screens/it_building_2f_screen.dart';
import '../screens/it_building_3f_screen.dart';
import '../screens/it_building_4f_screen.dart';
import '../screens/it_building_5f_screen.dart';
import '../screens/it_building_6f_screen.dart';
import '../screens/it_building_7f_screen.dart';
import '../screens/it_building_8f_screen.dart';
import '../screens/it_building_9f_screen.dart';
import '../screens/it_building_10f_screen.dart';

/// 층수(int) → 해당 도면 화면 반환
Widget? getScreenForFloor(int floor) {
  switch (floor) {
    case 1:
      return ItBuilding1fScreen();
    case 2:
      return ItBuilding2fScreen();
    case 3:
      return ItBuilding3fScreen();
    case 4:
      return ItBuilding4fScreen();
    case 5:
      return ItBuilding5fScreen();
    case 6:
      return ItBuilding6fScreen();
    case 7:
      return ItBuilding7fScreen();
    case 8:
      return ItBuilding8fScreen();
    case 9:
      return ItBuilding9fScreen();
    case 10:
      return ItBuilding10fScreen();
    default:
      return null; // 등록되지 않은 층
  }
}
