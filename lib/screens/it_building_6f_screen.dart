import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/lecturestatusdot.dart'; // LectureStatusDot import 추가
import 'lecture_schedule_screen.dart';
import '../models/models.dart'; // 공통 모델 불러오기

class ItBuilding6fScreen extends StatelessWidget {
  final double imageWidth = 1443; // 6층 도면 원본 가로 크기
  final double imageHeight = 658; // 6층 도면 원본 세로 크기

  final List<RoomInfo> rooms = [
    RoomInfo(name: '6210', left: 432, top: 235),
    RoomInfo(name: '6221', left: 905, top: 235),
    RoomInfo(name: '6225', left: 1073, top: 235),
  ];

  ItBuilding6fScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IT융합대학 6층 지도'),
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
                    // 도면 이미지
                    Image.asset(
                      'assets/images/it_building_6f_map.png',
                      fit: BoxFit.fill,
                      width: scaledImageWidth,
                      height: screenHeight,
                    ),

                    // 강의실 배치
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

  // 강의실 클릭 위젯
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
