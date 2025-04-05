/*
main.dart에서 Firebase 초기화
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

회원가입 기능 구현
import 'package:firebase_auth/firebase_auth.dart';

Future<String?> signUp(String email, String password) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return null; // 성공
  } catch (e) {
    return e.toString(); // 에러 메시지 반환
  }
}

로그인 기능 구현
Future<String?> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return null; // 성공
  } catch (e) {
    return e.toString(); // 에러 메시지 반환
  }
}

현재 로그인된 사용자 확인
User? getCurrentUser() {
  return FirebaseAuth.instance.currentUser;
}

 */