import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart'; // 공통 모델
import '../widgets/lecturestatusdot.dart'; // 강의실 상태 점
import 'space_detail_screen.dart'; // 공간 소개 화면
import '../widgets/locate_button.dart'; // ✅ 위치 버튼 공통 위젯 import

class ItBuilding1fScreen extends StatelessWidget {
  final double imageWidth = 2518; // 1층 도면 원본 가로 크기
  final double imageHeight = 1147; // 1층 도면 원본 세로 크기

  // 강의실 목록
  final List<RoomInfo> rooms = [
    RoomInfo(name: '1103', left: 510, top: 359),
    RoomInfo(name: '1122', left: 1709, top: 414),
    RoomInfo(name: '1125', left: 1933, top: 414),
  ];

  // 공공시설 목록 (예: s.space)
  final List<Space> spaces = [
    Space(
      name: 's.space',
      left: 1615,
      top: 150,
      description: 's.space는 학생들을 위한 카페형 협업 공간입니다.',
    ),
    Space(
      name: 'i.space',
      left: 1480,
      top: 414,
      description: '가상현실(VR), 증강현실(AR) 및 관련 기술을 체험할 수 있는 공간입니다.',
    ),

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
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;
          double scale = screenHeight / imageHeight;
          double scaledImageWidth = imageWidth * scale;

          return Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                width: scaledImageWidth,
                height: screenHeight,
                child: Stack(
                  children: [
                    // 배경 이미지
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
                    // 상태 점
                    ...rooms.map((room) {
                      double left = room.left / imageWidth * scaledImageWidth;
                      double top = room.top / imageHeight * screenHeight;
                      return Positioned(
                        left: left + 32,
                        top: top + 40,
                        child: LectureStatusDot(roomName: room.name),
                      );
                    }),
                    // 공공시설 버튼 (예: s.space)
                    ...spaces.map((space) {
                      double left = space.left / imageWidth * scaledImageWidth;
                      double top = space.top / imageHeight * screenHeight;
                      return Positioned(
                        left: left,
                        top: top,
                        child: clickableSpaceArea(context, space),
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

  // ✅ 강의실 클릭 시 시간표 화면 이동
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

  // ✅ 공공시설 클릭 시 소개 화면 이동
  Widget clickableSpaceArea(BuildContext context, Space space) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpaceDetailScreen(space: space),
          ),
        );
      },
      child: Container(
        width: 80,
        height: 60,
        alignment: Alignment.center,
        color: Colors.transparent,
      ),
    );
  }
}
