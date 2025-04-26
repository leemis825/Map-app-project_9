import 'package:flutter/material.dart';

class LectureDetailScreen extends StatelessWidget {
  final Map<String, dynamic> lecture;

  const LectureDetailScreen({super.key, required this.lecture});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('강의 상세 정보'),
        backgroundColor: const Color(0xFF004098), // 조선대 색상
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailRow('과목명', lecture['subject']),
            _buildDetailRow('교수명', lecture['professor']),
            _buildDetailRow('강의실', lecture['roomName']),
            _buildDetailRow('요일', lecture['day']),
            _buildDetailRow('시간', '${lecture['start']} ~ ${lecture['end']}'),
            _buildDetailRow('분반', lecture['section'] ?? '없음'),
            const SizedBox(height: 20),
            const Text(
              '강의 계획 요약',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              lecture['description'] ?? '이 강의에 대한 계획 요약이 아직 없습니다.',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            const Text(
              '성적 반영 비율',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              lecture['grading'] ?? '미입력',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value ?? '정보 없음'),
          ),
        ],
      ),
    );
  }
}
