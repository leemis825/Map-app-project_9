import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/models.dart';
import '../widgets/locate_button.dart'; // ✅ 위치 아이콘 공통 위젯 추가

class ItBuilding3fScreen extends StatelessWidget {
  final double imageWidth = 1749; // 3층 도면의 원본 가로 크기
  final double imageHeight = 799; // 3층 도면의 원본 세로 크기

  final List<RoomInfo> rooms = [
    RoomInfo(name: '3108', left: 405, top: 430),
    RoomInfo(name: '3208', left: 415, top: 100),
    RoomInfo(name: '3210', left: 685, top: 100),
    RoomInfo(name: '3224', left: 1270, top: 100),
    RoomInfo(name: '3228', left: 1480, top: 100),
    RoomInfo(name: '3120', left: 1070, top: 280),
    RoomInfo(name: '3128', left: 1280, top: 280),
  ];

  final List<IconInfo> icons = [
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

                    // 계단 및 엘리베이터 아이콘
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
      floatingActionButton: const LocateButton(), // ✅ BLE 위치 버튼 추가
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
        child: Text(
          roomName,
          style: GoogleFonts.doHyeon(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
      ),
    );
  }
}
