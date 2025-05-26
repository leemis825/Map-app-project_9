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

  final List<Space> spaces = [
    Space(
      name: 'tdm.space',
      left: 165,
      top: 280,
      description: 'Thinking Design Making\n학생들이 자유롭게 토론하며 프로젝트를 수행하는 개방된 공간입니다.',
    ),
  ];

  ItBuilding2fScreen({super.key});

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
                      'assets/images/it_building_2f_map.png',
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
      floatingActionButton: const LocateButton(), // ✅ BLE 위치 기능 버튼 추가
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
