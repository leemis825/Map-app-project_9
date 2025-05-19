import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/models.dart'; // 공통 모델 불러오기

class ItBuilding2fScreen extends StatelessWidget {
  final double imageWidth = 1755; // 2층 도면의 원본 가로 크기
  final double imageHeight = 802; // 2층 도면의 원본 세로 크기

  final List<RoomInfo> rooms = [
    RoomInfo(name: '2105-2', left: 415, top: 600),
    RoomInfo(name: '2115-1', left: 415, top: 420),
    RoomInfo(name: '2104-1', left: 155, top: 420),
    RoomInfo(name: '2104-2', left: 155, top: 600),
    RoomInfo(name: '2119', left: 1024, top: 280),
    RoomInfo(name: '2210', left: 525, top: 105),
    RoomInfo(name: '2122', left: 1180, top: 280),
    RoomInfo(name: '2225', left: 1320, top: 100),
    RoomInfo(name: '2228', left: 1495, top: 100),
  ];

  final List<IconInfo> icons = [
    IconInfo(asset: 'assets/icons/stairs.svg', left: 70, top: 147),
    IconInfo(asset: 'assets/icons/stairs.svg', left: 840, top: 121),
    IconInfo(asset: 'assets/icons/stairs.svg', left: 1649, top: 210),
    IconInfo(asset: 'assets/icons/elevator.svg', left: 982, top: 115),
  ];

  ItBuilding2fScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IT융합대학 2층 지도')),
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

                    // ✅ 계단 및 엘리베이터 아이콘
                    ...icons.map((icon) {
                      double left = icon.left / imageWidth * scaledImageWidth;
                      double top = icon.top / imageHeight * screenHeight;
                      bool isStairs = icon.asset.contains('stairs');

                      return Positioned(
                        left: left,
                        top: top,
                        child: SvgPicture.asset(
                          icon.asset,
                          width: isStairs ? 24 : 36,
                          height: isStairs ? 24 : 36,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
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
    );
  }
}
