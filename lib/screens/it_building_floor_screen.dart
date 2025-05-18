import 'package:flutter/material.dart';
import 'AppDrawer.dart';
import 'search_bar_with_results.dart';
import 'lecture_schedule_screen.dart';

class ItBuildingFloorScreen extends StatelessWidget {
  final int floor;
  final Offset? userPosition;

  const ItBuildingFloorScreen({
    super.key,
    required this.floor,
    this.userPosition,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = 'assets/images/it_building_${floor}f_map.png';

    // 비콘 위치 마커
    final beaconPins = [
      const Offset(50, 120),
      const Offset(180, 120),
      const Offset(300, 120),
    ];

    return Scaffold(
      drawer: AppDrawer(
        isDarkMode: false,
        onToggleDarkMode: (_) {},
      ),
      appBar: AppBar(
        title: Text('IT융합대학 ${floor}층'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("자주 묻는 질문을 확인하세요!")),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [2, 5].map((f) {
                return ListTile(
                  title: Text('$f층'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ItBuildingFloorScreen(floor: f, userPosition: null),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          );
        },
        child: const Icon(Icons.layers),
      ),
      body: Column(
        children: [
          SearchBarWithResults(
            initialText: '',
            onRoomSelected: (room) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LectureScheduleScreen(roomName: room),
                ),
              );
            },
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(imagePath, fit: BoxFit.cover),
                ),
                // 사용자 위치 마커
                if (userPosition != null)
                  Positioned(
                    left: userPosition!.dx,
                    top: userPosition!.dy,
                    child: const Icon(Icons.person_pin_circle, size: 36, color: Colors.blue),
                  ),
                // 강의실 마커 예시
                Positioned(
                  left: 180,
                  top: 120,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LectureScheduleScreen(roomName: 'IT512'),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      color: Colors.white70,
                      child: const Text('IT512'),
                    ),
                  ),
                ),
                // 비콘 마커
                for (var pos in beaconPins)
                  Positioned(
                    left: pos.dx,
                    top: pos.dy,
                    child: const Icon(Icons.location_pin, size: 28, color: Colors.red),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
