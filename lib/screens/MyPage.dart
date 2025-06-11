import 'dart:convert';
import 'package:flutter/material.dart';

class MyPageScreen extends StatelessWidget {
  final String studentId;
  const MyPageScreen({super.key, required this.studentId});

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
          orElse: () => <String, dynamic>{},
        );

    return student.isNotEmpty ? student : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ 흰색 배경 설정
      appBar: AppBar(
        title: const Text('마이페이지'),
        backgroundColor: Colors.white, // 조선대 색 계열이면 유지
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
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  height: 250,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF0054A7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 41,
                        top: 47,
                        child: Container(
                          width: 125,
                          height: 158,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.asset(
                            student['photo'] ??
                                'assets/images/default_profile.jpg',
                            fit: BoxFit.cover,
                            width: 125,
                            height: 158,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 186,
                        top: 105,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student['college'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 1.40,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              student['department'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 1.40,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Text(
                                  student['name'] ?? '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 1.40,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  student['id'] ?? '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 1.40,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
