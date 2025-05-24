import 'package:flutter/material.dart';

class ItBuildingNavigationScreen extends StatelessWidget {
  final String startRoom;
  final String endRoom;

  const ItBuildingNavigationScreen({
    super.key,
    required this.startRoom,
    required this.endRoom,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("IT 건물 경로 안내")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("🔹 출발 강의실: $startRoom", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            Text("🔸 도착 강의실: $endRoom", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 24),
            const Text("🛠️ (여기에 지도 및 경로 안내가 구현될 예정입니다)"),
          ],
        ),
      ),
    );
  }
}
