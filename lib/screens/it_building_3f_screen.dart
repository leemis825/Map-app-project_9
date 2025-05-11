import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart'; // 공통 모델 불러오기
import '../widgets/lecturestatusdot.dart'; // LectureStatusDot import 추가

// const ItBuilding3fScreen({super.key}); 에러로 20250429 수정 -> const 삭제
// 나머지 1-10까지도 동일하게 수정

class ItBuilding3fScreen extends StatelessWidget {
  final double imageWidth = 1749; // 3층 도면의 원본 가로 크기
  final double imageHeight = 799; // 3층 도면의 원본 세로 크기

  final List<RoomInfo> rooms = [
    RoomInfo(name: '3108', left: 381, top: 500),
    RoomInfo(name: '3208', left: 415, top: 110),
    RoomInfo(name: '3210', left: 678, top: 110),
    RoomInfo(name: '3224', left: 1265, top: 105),
    RoomInfo(name: '3228', left: 1465, top: 105),
    RoomInfo(name: '3120', left: 1060, top: 285),
    RoomInfo(name: '3128', left: 1270, top: 285),
  ];

  final List<IconInfo> icons = [
    // 계단 아이콘 4개
    IconInfo(asset: 'assets/icons/stairs.svg', left: 72, top: 150),
    IconInfo(asset: 'assets/icons/stairs.svg', left: 843, top: 121),
    IconInfo(asset: 'assets/icons/stairs.svg', left: 1652, top: 212),
    IconInfo(asset: 'assets/icons/elevator.svg', left: 986, top: 115),
  ];

  ItBuilding3fScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IT융합대학 3층 지도'),
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
