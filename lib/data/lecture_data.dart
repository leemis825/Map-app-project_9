import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class LectureDataManager {
  static Map<String, dynamic> _data = {};
  static bool _isLoaded = false; // ✅ 이미 불러왔는지 체크

  // JSON 파일 로드
  static Future<void> loadLectureData() async {
    if (_isLoaded) return; // ✅ 이미 읽었으면 다시 읽지 않음
    try {
      final String jsonString = await rootBundle.loadString('assets/data/classroom_schedule_final.json');
      _data = json.decode(jsonString);
      _isLoaded = true; // ✅ 로딩 완료 표시
    } catch (e) {
      print('Error loading lecture data: $e');
    }
  }

  // 특정 강의실(roomName) 데이터 가져오기
  static List<dynamic> getLecturesForRoom(String roomName) {
    return _data[roomName] ?? [];
  }
}
