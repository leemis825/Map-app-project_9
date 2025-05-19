import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'lecture_schedule_screen.dart';
import '../models/models.dart'; // 공통 모델 불러오기
import '../widgets/lecturestatusdot.dart'; // LectureStatusDot import 추가
import '../widgets/locate_button.dart'; // ✅ 공통 위치 버튼 위젯 import

class ItBuilding7fScreen extends StatelessWidget {
  final double imageWidth = 1756; // 7층 도면 원본 가로 크기
  final double imageHeight = 799; // 7층 도면 원본 세로 크기

  final List<RoomInfo> rooms = [
    RoomInfo(name: '7210', left: 535, top: 280),
    RoomInfo(name: '7221', left: 1115, top: 285),
    RoomInfo(name: '7225', left: 1320, top: 285),
  ];


  ItBuilding7fScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IT융합대학 7층 지도'),
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
                      'assets/images/it_building_7f_map.png',
                      fit: BoxFit.fill,
                      width: scaledImageWidth,
                      height: screenHeight,
                    ),

                    // 강의실 버튼
                    ...rooms.map((room) {
                      double left = room.left / imageWidth * scaledImageWidth;
                      double top = room.top / imageHeight * screenHeight;
                      return Positioned(
                        left: left,
                        top: top,
                        child: clickableRoomArea(context, room.name),
                      );
                    }),

                    // ✅ 강의실 상태 점
                    ...rooms.map((room) {
                      double left = room.left / imageWidth * scaledImageWidth;
                      double top = room.top / imageHeight * screenHeight;
                      return Positioned(
                        left: left + 35,
                        top: top + 40,
                        child: LectureStatusDot(roomName: room.name),
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

  // ✅ 강의실 버튼 위젯
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
        /*child: Text(
          roomName,
          style: GoogleFonts.doHyeon(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),*/
      ),
    );
  }
}
