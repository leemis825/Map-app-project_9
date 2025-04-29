import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class LectureDataManager {
  static Map<String, dynamic> _data = {};
  static bool _isLoaded = false; // ✅ 이미 불러왔는지 체크

  // ✅ JSON 파일 로드
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

  // ✅ 특정 강의실(roomName) 데이터 가져오기
  static List<dynamic> getLecturesForRoom(String roomName) {
    return _data[roomName] ?? [];
  }

  // ✅ 강의명 또는 교수명으로 검색 (전 강의실 대상)
  static List<Map<String, dynamic>> searchLecturesByKeyword(String keyword) {
    keyword = keyword.toLowerCase();
    List<Map<String, dynamic>> results = [];

    _data.forEach((roomName, lectures) {
      for (var lecture in lectures) {
        final subject = lecture['subject']?.toLowerCase() ?? '';
        final professor = lecture['professor']?.toLowerCase() ?? '';

        if (subject.contains(keyword) || professor.contains(keyword)) {
          results.add({
            'roomName': roomName,
            'day': lecture['day'],
            'start': lecture['start'],
            'end': lecture['end'],
            'subject': lecture['subject'],
            'professor': lecture['professor'],
          });
        }
      }
    });

    return results;
  }

  // ✅ 모든 강의 데이터를 roomName 포함하여 반환
  static List<Map<String, dynamic>> getAllLectures() {
    List<Map<String, dynamic>> all = [];

    _data.forEach((roomName, lectures) {
      for (var lecture in lectures) {
        all.add({
          'roomName': roomName,
          'day': lecture['day'],
          'start': lecture['start'],
          'end': lecture['end'],
          'subject': lecture['subject'],
          'professor': lecture['professor'],
        });
      }
    });

    return all;
  }
}
