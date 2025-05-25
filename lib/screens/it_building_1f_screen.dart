import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../widgets/lecturestatusdot.dart';
import 'space_detail_screen.dart';
import '../widgets/locate_button.dart';
import '../widgets/qr_button.dart';
import '../widgets/navigate_button.dart';

class ItBuilding1fScreen extends StatelessWidget {
  final double imageWidth = 2518;
  final double imageHeight = 1147;

  final List<RoomInfo> rooms = [
    RoomInfo(name: '1103', left: 510, top: 359),
    RoomInfo(name: '1122', left: 1709, top: 414),
    RoomInfo(name: '1125', left: 1933, top: 414),
  ];

  final List<Space> spaces = [
    Space(
      name: 's.space',
      left: 1615,
      top: 150,
      description: 's.space는 학생들을 위한 카페형 협업 공간입니다.',
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
                    // 도면 이미지
                    Image.asset(
                      'assets/images/it_building_1f_map.png',
                      fit: BoxFit.fill,
                      width: scaledImageWidth,
                      height: screenHeight,
                    ),

                    // 강의실 클릭 영역
                    ...rooms.map((room) {
                      double left = room.left / imageWidth * scaledImageWidth;
                      double top = room.top / imageHeight * screenHeight;
                      return Positioned(
                        left: left,
                        top: top,
                        child: clickableRoomArea(context, room.name),
                      );
                    }).toList(),

                    // 강의실 상태 점
                    ...rooms.map((room) {
                      double left = room.left / imageWidth * scaledImageWidth;
                      double top = room.top / imageHeight * screenHeight;
                      return Positioned(
                        left: left + 32,
                        top: top + 40,
                        child: LectureStatusDot(roomName: room.name),
                      );
                    }).toList(),

                    // 공공시설 클릭 영역
                    ...spaces.map((space) {
                      double left = space.left / imageWidth * scaledImageWidth;
                      double top = space.top / imageHeight * screenHeight;
                      return Positioned(
                        left: left,
                        top: top,
                        child: clickableSpaceArea(context, space),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
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
        height: 50,
        alignment: Alignment.center,
        color: Colors.transparent,
      ),
    );
  }

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
