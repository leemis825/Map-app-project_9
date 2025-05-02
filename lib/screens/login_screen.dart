import 'package:flutter/material.dart';
import 'campus_map_screen.dart'; // 기존 지도 화면 import

class LoginScreen extends StatelessWidget {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  void _handleLogin(BuildContext context) {
    final id = _idController.text.trim();
    final password = _passwordController.text.trim();

    if (id == 'qwer' && password == '1234') {
      // 로그인 성공
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CampusMapScreen()),
      );
    } else {
      // 로그인 실패
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('아이디 또는 비밀번호가 잘못되었습니ㅁ다!'),
          duration: Duration(seconds: 2),
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

            // 아이디 입력창
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

            // 비밀번호 입력창
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

      // ✅ 하단에 로그인 버튼 고정
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
