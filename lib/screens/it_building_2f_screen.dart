import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart'; // 공통 모델 불러오기
import '../widgets/lecturestatusdot.dart'; // 강의실 상태 점
import '../widgets/locate_button.dart'; // 위치 버튼
import '../widgets/qr_button.dart'; // QR 버튼
import '../widgets/navigate_button.dart'; // 경로 안내 버튼

class ItBuilding2fScreen extends StatelessWidget {
  final double imageWidth = 1755; // 도면 원본 가로 크기
  final double imageHeight = 802; // 도면 원본 세로 크기

  final List<RoomInfo> rooms = [
    RoomInfo(name: '2105-2', left: 415, top: 600),
    RoomInfo(name: '2115-1', left: 418, top: 425),
    RoomInfo(name: '2104-2', left: 160, top: 600),
    RoomInfo(name: '2119', left: 1030, top: 285),
    RoomInfo(name: '2210', left: 530, top: 105),
    RoomInfo(name: '2122', left: 1183, top: 285),
    RoomInfo(name: '2225', left: 1320, top: 105),
    RoomInfo(name: '2228', left: 1495, top: 105),
  ];

  ItBuilding2fScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IT융합대학 2층 지도'),
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
                    // ✅ 도면 이미지
                    Image.asset(
                      'assets/images/it_building_2f_map.png',
                      fit: BoxFit.fill,
                      width: scaledImageWidth,
                      height: screenHeight,
                    ),

                    // ✅ 강의실 클릭 영역
                    ...rooms.map((room) {
                      double left = room.left / imageWidth * scaledImageWidth;
                      double top = room.top / imageHeight * screenHeight;
                      return Positioned(
                        left: left,
                        top: top,
                        child: clickableRoomArea(context, room.name),
                      );
                    }),

                    // ✅ 강의실 상태 점 위치
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

      // ✅ FAB 버튼 3개를 오른쪽 하단 세로 정렬 (Z 플립 대응)
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

  // ✅ 강의실 클릭 시 시간표 화면으로 이동
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
