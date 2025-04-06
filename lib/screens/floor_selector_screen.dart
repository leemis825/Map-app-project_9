/*import 'package:flutter/material.dart';
import 'it_building_1f_screen.dart';
import 'it_building_2f_screen.dart';
import 'it_building_3f_screen.dart';
import 'it_building_4f_screen.dart';
import 'it_building_5f_screen.dart';
import 'it_building_6f_screen.dart';
import 'it_building_7f_screen.dart';
import 'it_building_8f_screen.dart';
import 'it_building_9f_screen.dart';
import 'it_building_10f_screen.dart';

class FloorSelectorScreen extends StatelessWidget {
  final List<Map<String, dynamic>> floors = [
    {'floor': '1층', 'screen': ItBuilding1fScreen()},
    {'floor': '2층', 'screen': ItBuilding2fScreen()},
    {'floor': '3층', 'screen': ItBuilding3fScreen()},
    {'floor': '4층', 'screen': ItBuilding4fScreen()},
    {'floor': '5층', 'screen': ItBuilding5fScreen()},
    {'floor': '6층', 'screen': ItBuilding6fScreen()},
    {'floor': '7층', 'screen': ItBuilding7fScreen()},
    {'floor': '8층', 'screen': ItBuilding8fScreen()},
    {'floor': '9층', 'screen': ItBuilding9fScreen()},
    {'floor': '10층', 'screen': ItBuilding10fScreen()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IT융합대학 층 선택'),
      ),
      body: ListView.builder(
        itemCount: floors.length,
        itemBuilder: (context, index) {
          final floor = floors[index];
          return ListTile(
            title: Text(
              floor['floor'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => floor['screen']),
              );
            },
          );
        },
      ),
    );
  }
}
*/