import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'lecture_schedule_screen.dart';
import '../models/models.dart';
import '../widgets/locate_button.dart'; // ✅ 위치 버튼 위젯 추가

class ItBuilding9fScreen extends StatelessWidget {
  final double imageWidth = 1753;
  final double imageHeight = 795;

  final List<RoomInfo> rooms = [
    RoomInfo(name: '9206', left: 300, top: 280),
    RoomInfo(name: '9210', left: 525, top: 280),
    RoomInfo(name: '9221', left: 1110, top: 280),
    RoomInfo(name: '9225', left: 1317, top: 280),
  ];

  final List<IconInfo> icons = [
    IconInfo(asset: 'assets/icons/stairs.svg', left: 68.5, top: 321),
    IconInfo(asset: 'assets/icons/stairs.svg', left: 840, top: 290),
    IconInfo(asset: 'assets/icons/stairs.svg', left: 1650, top: 383),
    IconInfo(asset: 'assets/icons/elevator.svg', left: 982.7, top: 285),
  ];

  ItBuilding9fScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IT융합대학 9층 지도'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double scale = screenHeight / imageHeight;
          double scaledImageWidth = imageWidth * scale;

          return Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: scaledImageWidth,
                height: screenHeight,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/it_building_9f_map.png',
                      fit: BoxFit.fill,
                      width: scaledImageWidth,
                      height: screenHeight,
                    ),
                    ...rooms.map((room) {
                      double left = room.left / imageWidth * scaledImageWidth;
                      double top = room.top / imageHeight * screenHeight;
                      return Positioned(
                        left: left,
                        top: top,
                        child: clickableRoomArea(context, room.name),
                      );
                    }),
                    ...icons.map((icon) {
                      double left = icon.left / imageWidth * scaledImageWidth;
                      double top = icon.top / imageHeight * screenHeight;
                      bool isStairs = icon.asset.contains('stairs');

                      return Positioned(
                        left: left,
                        top: top,
                        child: SvgPicture.asset(
                          icon.asset,
                          width: isStairs ? 24 : 36,
                          height: isStairs ? 24 : 36,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: const LocateButton(), // ✅ BLE 위치 기능 버튼 추가
    );
  }

  Widget clickableRoomArea(BuildContext context, String roomName) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LectureScheduleScreen(roomName: roomName),
          ),
        );
      },
      child: Container(
        width: 80,
        height: 50,
        alignment: Alignment.center,
        color: Colors.transparent,
        child: Text(
          roomName,
          style: GoogleFonts.doHyeon(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
      ),
    );
  }
}
