import 'package:flutter/material.dart';
import 'package:campus_map_app/screens/campus_map_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'campus_map_screen.dart'; // 기존 지도 화면
import 'package:provider/provider.dart';
import '../user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin(BuildContext context) async {
    final id = _idController.text.trim();
    final password = _passwordController.text.trim();

    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('students').doc(id).get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;

        if (data['password'] == password) {
          // 로그인 성공 시 userId 저장
          Provider.of<UserProvider>(context, listen: false).setUserId(id);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const CampusMapScreen()),
          );
        } else {
          // 비밀번호 틀림
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('비밀번호가 올바르지 않습니다.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        // 학번 없음
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('존재하지 않는 학번입니다.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인 중 오류 발생: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0054A7),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 상단 로고와 텍스트
            Column(
              children: [
                Image.asset('assets/images/logo.png', height: 100),
                const SizedBox(height: 16),
                const Text(
                  '조선대학교\n캠퍼스 맵',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '포털시스템 아이디 및 비밀번호와 동일합니다',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // 아이디 입력
            TextField(
              controller: _idController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '아이디',
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF228CDD),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 비밀번호 입력
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '비밀번호',
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF228CDD),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
            ),
          ],
        ),
      ),

      // 로그인 버튼
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(32),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0054A7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => _handleLogin(context),
            child: const Text('로그인'),
          ),
        ),
      ),
    );
  }
}
