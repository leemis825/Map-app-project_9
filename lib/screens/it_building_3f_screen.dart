import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart'; // 공통 모델 불러오기
import '../widgets/lecturestatusdot.dart'; // 상태 점
import '../widgets/locate_button.dart'; // 위치 버튼
import '../widgets/qr_button.dart'; // QR 버튼
import '../widgets/navigate_button.dart'; // 경로안내 버튼

class ItBuilding3fScreen extends StatelessWidget {
  final double imageWidth = 1749;
  final double imageHeight = 799;

  final List<RoomInfo> rooms = [
    RoomInfo(name: '3108', left: 381, top: 500),
    RoomInfo(name: '3208', left: 415, top: 110),
    RoomInfo(name: '3210', left: 678, top: 110),
    RoomInfo(name: '3224', left: 1265, top: 105),
    RoomInfo(name: '3228', left: 1465, top: 105),
    RoomInfo(name: '3120', left: 1060, top: 285),
    RoomInfo(name: '3128', left: 1270, top: 285),
  ];

  ItBuilding3fScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IT융합대학 3층 지도'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: Colors.white,
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
                    // 배경 도면 이미지
                    Image.asset(
                      'assets/images/it_building_3f_map.png',
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

                    // 강의실 상태 점
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

      // ✅ 오른쪽 하단 FAB 3개 세로 정렬 (Z플립 대응)
      floatingActionButton: Stack(
        children: [
          Positioned(
            right: 16,
            bottom: 16,
            child: const LocateButton(),
          ),
          Positioned(
            right: 16,
            bottom: 96,
            child: const QrButton(),
          ),
          Positioned(
            right: 16,
            bottom: 176,
            child: const NavigateButton(),
          ),
        ],
      ),
    );
  }

  // 강의실 클릭 영역
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
        /*
        child: Text(
          roomName,
          style: GoogleFonts.doHyeon(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
        */
      ),
    );
  }
}
