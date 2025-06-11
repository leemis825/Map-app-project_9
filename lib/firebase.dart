import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadStudentsFromJson() async {
  // JSON 파일 불러오기
  final jsonString = await rootBundle.loadString(
    'assets/data/students_info.json',
  );
  final Map<String, dynamic> data = json.decode(jsonString);

  // students 배열 가져오기
  final List<dynamic> students = data['students'];
  final collection = FirebaseFirestore.instance.collection('students');

  for (var student in students) {
    await collection.doc(student['id']).set(student);
  }
}
