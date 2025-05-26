import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'lecture_schedule_screen.dart'; // ✅ 강의실 시간표 화면 import
import '../models/models.dart'; // 공통 모델 불러오기
import '../widgets/lecturestatusdot.dart'; // LectureStatusDot import 추가
import 'lecture_schedule_screen.dart';
import '../widgets/locate_button.dart'; // ✅ 위치 버튼 위젯 추가
import '../widgets/qr_button.dart'; // ✅ QR 버튼 추가
import '../widgets/navigate_button.dart'; // ✅ 경로 안내 버튼 추가

class ItBuilding9fScreen extends StatelessWidget {
  final double imageWidth = 1753; // 9층 도면 원본 가로 크기
  final double imageHeight = 795;  // 9층 도면 원본 세로 크기

  final List<RoomInfo> rooms = [
    RoomInfo(name: '9206', left: 303, top: 280),
    RoomInfo(name: '9210', left: 527, top: 280),
    RoomInfo(name: '9221', left: 1102, top: 280),
    RoomInfo(name: '9225', left: 1312, top: 280),
  ];


  ItBuilding9fScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                    // ✅ 강의실 버튼
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
    );
  }

  // ✅ 강의실 클릭 영역
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
