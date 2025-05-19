import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/models.dart';
import '../widgets/locate_button.dart'; // ✅ 위치 버튼 공통 위젯 import

class ItBuilding1fScreen extends StatelessWidget {
  final double imageWidth = 2518; // 1층 도면 원본 가로 크기
  final double imageHeight = 1147; // 1층 도면 원본 세로 크기

  final List<RoomInfo> rooms = [
    RoomInfo(name: '1103', left: 374, top: 359),
    RoomInfo(name: '1122', left: 1709, top: 414),
    RoomInfo(name: '1125', left: 1933, top: 414),
  ];

  ItBuilding1fScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'IT융합대학 1층 지도',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
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
                      'assets/images/it_building_1f_map.png',
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
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: const LocateButton(), // ✅ 위치 버튼 추가
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
        height: 60,
        alignment: Alignment.center,
        color: Colors.transparent,
        /*
        child: Text(
          roomName,
          style: GoogleFonts.doHyeon(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0054A7),
          ),
        ),
        */
      ),
    );
  }
}
