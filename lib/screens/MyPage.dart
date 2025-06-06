import 'dart:convert';
import 'package:flutter/material.dart';

class MyPageScreen extends StatelessWidget {
  final String studentId;
  const MyPageScreen({super.key, required this.studentId});

  // ✅ 비동기로 학번에 해당하는 학생 정보 읽어오기
  Future<Map<String, dynamic>?> _loadStudentInfo(
    BuildContext context,
    String id,
  ) async {
    final jsonString = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/data/students_info.json');
    final data = jsonDecode(jsonString);

    final student = (data['students'] as List)
        .cast<Map<String, dynamic>>()
        .firstWhere(
          (student) => student['id'] == id,
          orElse: () => <String, dynamic>{}, // ✅ null 대신 빈 맵 반환
        );

    return student.isNotEmpty ? student : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ 흰색 배경 설정
      appBar: AppBar(
        title: const Text('마이페이지'),
        backgroundColor: const Color(0xFF004098), // 조선대 색 계열이면 유지
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _loadStudentInfo(context, studentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('오류가 발생했습니다.'));
          }

          final student = snapshot.data;
          if (student == null) {
            return const Center(child: Text('학생 정보를 찾을 수 없습니다.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '이름: ${student['name']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  '학번: ${student['id']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  '학과: ${student['department']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
