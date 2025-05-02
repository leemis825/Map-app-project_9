import 'package:flutter/material.dart';

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
    return Drawer(
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
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.schedule, color: Colors.black),
            title: const Text('시간표', style: TextStyle(color: Colors.black)),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
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
        ],
      ),
    );
  }
}
