import 'package:flutter/material.dart';
import 'package:campus_map_app/screens/it_building_floor_screen.dart';
import 'package:campus_map_app/beacon/beacon_scanner.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Center(child: Text('')),
          Positioned(
            bottom: 24,
            left: 24,
            child: GestureDetector(
              onTap: () async {
                final beacon = await BeaconScanner().scanStrongestBeacon();

                // 하나라도 잡히면 → 2층으로 이동
                if (beacon != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ItBuildingFloorScreen(
                        floor: 2,
                        userPosition: Offset(180, 120), // 임의의 중앙 위치
                      ),
                    ),
                  );
                } else {
                  _showSnackBar("비콘 인식 실패");
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade100,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.my_location, color: Colors.deepPurple, size: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
