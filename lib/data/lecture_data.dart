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
            'college': lecture['college'],
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
          'college': lecture['college'],
        });
      }
    });

    return all;
  }

  // ✅ 현재 시간이 주어진 강의실에서 강의 중인지 여부 확인
  static bool isLectureOngoing(String roomName) {
    final now = DateTime.now().toUtc().add(Duration(hours: 9)); //한국 시간대로 맞춤
    //final now = DateTime(2025, 5, 14, 14, 30);
    final koreanDays = ['월', '화', '수', '목', '금', '토', '일'];
    final today = koreanDays[now.weekday - 1];

    final nowMinutes = now.hour * 60 + now.minute;

    final lectures = getLecturesForRoom(roomName);
    for (var lecture in lectures) {
      if (lecture['day'] != today) continue;

      final startParts = lecture['start'].split(':');
      final endParts = lecture['end'].split(':');
      final startMinutes = int.parse(startParts[0]) * 60 +
          int.parse(startParts[1]);
      final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);

      if (nowMinutes >= startMinutes && nowMinutes < endMinutes) {
        return true;
      }
    }
    return false;
  }
}
