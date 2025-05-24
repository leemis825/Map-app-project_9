import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'lecture_schedule_screen.dart';
import '../models/models.dart'; // 공통 모델 불러오기
import '../widgets/lecturestatusdot.dart'; // LectureStatusDot import 추가
import '../widgets/locate_button.dart'; // ✅ 위치 아이콘 공통 위젯 import
import '../widgets/qr_button.dart'; // ✅ QR 버튼
import '../widgets/navigate_button.dart'; // ✅ 경로 안내 버튼

class ItBuilding8fScreen extends StatelessWidget {
  final double imageWidth = 1756; // 8층 도면 원본 가로 크기
  final double imageHeight = 801; // 8층 도면 원본 세로 크기

  final List<RoomInfo> rooms = [
    RoomInfo(name: '8206', left: 330, top: 280),
    RoomInfo(name: '8210', left: 540, top: 280),
    RoomInfo(name: '8221', left: 1115, top: 280),
  ];

  ItBuilding8fScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IT융합대학 8층 지도'),
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
                    Image.asset(
                      'assets/images/it_building_8f_map.png',
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

      // ✅ 하단 FAB 3개 가로 정렬
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            QrButton(),
            SizedBox(width: 16),
            NavigateButton(),
            SizedBox(width: 16),
            LocateButton(),
          ],
        ),
      ),
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
