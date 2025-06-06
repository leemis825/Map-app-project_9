import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MyPage.dart';
import 'MyTimetable.dart';
import 'chatscreen.dart'; // ← 경로와 파일명에 맞게 조정
import '../user_provider.dart';
import 'login_screen.dart'; // 로그인 화면 경로 맞게 수정

class AppDrawer extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onToggleDarkMode;

  const AppDrawer({
    Key? key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserProvider>(context).userId;

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 64, // 일반 리스트 높이 맞추기
            child: Center(
              child: Text(
                '메뉴',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.black),
            title: const Text('마이페이지', style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.pop(context); // Drawer 닫기
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyPageScreen(studentId: userId),
                ),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.schedule, color: Colors.black),
            title: const Text('시간표', style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.pop(context); // Drawer 닫기
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LectureScheduleScreen(studentId: userId),
                ),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.chat, color: Colors.black),
            title: const Text('Q&A', style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              );
            },
          ),
          const Divider(height: 1),
          /*ListTile(
            leading: const Icon(Icons.dark_mode, color: Colors.black),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('다크모드', style: TextStyle(color: Colors.black)),
                Switch(
                  value: isDarkMode,
                  onChanged: onToggleDarkMode,
                  activeColor: Colors.white,
                  activeTrackColor: Colors.black,
                  inactiveThumbColor: Colors.black,
                  inactiveTrackColor: Colors.transparent,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.black),
            title: const Text('설정', style: TextStyle(color: Colors.black)),
            onTap: () {},
          ),
          const Divider(height: 1),*/

          // ✅ 로그아웃 버튼 추가
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.black),
            title: const Text('로그아웃', style: TextStyle(color: Colors.black)),
            onTap: () {
              Provider.of<UserProvider>(context, listen: false).logout();

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
