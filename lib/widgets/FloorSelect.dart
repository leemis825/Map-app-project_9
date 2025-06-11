/*import 'package:flutter/material.dart';
import '../screens/lecture_schedule_screen.dart';
import '../screens/AppDrawer.dart';
import '../data/lecture_data.dart';
import 'search_bar_with_results.dart';
import '../screens/it_building_1f_screen.dart';
import '../screens/it_building_2f_screen.dart';
import '../screens/it_building_3f_screen.dart';
import '../screens/it_building_4f_screen.dart';
import '../screens/it_building_5f_screen.dart';
import '../screens/it_building_6f_screen.dart';
import '../screens/it_building_7f_screen.dart';
import '../screens/it_building_8f_screen.dart';
import '../screens/it_building_9f_screen.dart';
import '../screens/it_building_10f_screen.dart';

class FloorSelectorButton extends StatelessWidget {
  bool isDarkMode = false;
  int selectedFloor = 1;
  bool showFloorButtons = false;
  final List<int> floors = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  //final VoidCallback onToggle;
  //final Function(int) onSelectFloor;

  /**const FloorSelectorButton({
    super.key,
    required this.selectedFloor,
    required this.showFloorButtons,
    required this.floors,
    required this.onToggle,
    required this.onSelectFloor,
  });*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        isDarkMode: isDarkMode,
        onToggleDarkMode: (value) {
          setState(() {
            isDarkMode = value;
          });
        },
      ),
      body: Column(
        children: [
          if (selectedFloor == 1)
            ItBuilding1fScreen()
          else if (selectedFloor == 2)
            ItBuilding2fScreen()
          else if (selectedFloor == 3)
            ItBuilding3fScreen()
          else if (selectedFloor == 4)
            ItBuilding4fScreen()
          else if (selectedFloor == 5)
            ItBuilding5fScreen()
          else if (selectedFloor == 6)
            ItBuilding6fScreen()
          else if (selectedFloor == 7)
            ItBuilding7fScreen()
          else if (selectedFloor == 8)
            ItBuilding8fScreen()
          else if (selectedFloor == 9)
            ItBuilding9fScreen()
          else if (selectedFloor == 10)
            ItBuilding10fScreen(),
          Positioned(
            top: 5,
            right: 32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showFloorButtons = !showFloorButtons;
                    });
                  },
                  child: Text('$selectedFloor층'),
                ),
                if (showFloorButtons)
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 200,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.builder(
                      itemCount: floors.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedFloor = floors[index];
                                showFloorButtons = false;
                              });
                            },
                            child: Text('${floors[index]}층'),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/
