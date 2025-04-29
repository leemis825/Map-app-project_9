import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'lecture_schedule_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart'; // 공통 모델 불러오기

class ItBuilding5fScreen extends StatelessWidget {
  final double imageWidth = 1758; // 도면 원본 가로 크기
  final double imageHeight = 796; // 도면 원본 세로 크기

  final List<RoomInfo> rooms = [
    // 예: RoomInfo(name: '5123', left: 420, top: 300),
  ];

  // 아이콘 정보 리스트
  final List<IconInfo> icons = [
    IconInfo(asset: 'assets/icons/stairs.svg', left: 80, top: 319), //계단 (왼쪽에서부터)
    IconInfo(asset: 'assets/icons/stairs.svg', left: 852, top: 290), //계단 2
    IconInfo(asset: 'assets/icons/stairs.svg', left: 1665, top: 384), //계단 3
    IconInfo(asset: 'assets/icons/elevator.svg', left: 998, top: 283), //엘레베이터
    //IconInfo(asset: 'assets/icons/toilet.svg', left: 300, top: 100),
  ];

  ItBuilding5fScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IT융합대학 5층 지도')),
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
                      'assets/images/it_building_5f_map.png',
                      fit: BoxFit.fill,
                      width: scaledImageWidth,
                      height: screenHeight,
                    ),

                    // 강의실
                    ...rooms.map((room) {
                      double left = room.left / imageWidth * scaledImageWidth;
                      double top = room.top / imageHeight * screenHeight;
                      return Positioned(
                        left: left,
                        top: top,
                        child: clickableRoomArea(context, room.name),
                      );
                    }),

                    // 아이콘 배치
                    ...icons.map((icon) {
                      double left = icon.left / imageWidth * scaledImageWidth;
                      double top = icon.top / imageHeight * screenHeight;

                      // stairs.svg일 경우만 크기 다르게 지정
                      bool isStairs = icon.asset.contains('stairs');

                      return Positioned(
                        left: left,
                        top: top,
                        child: SvgPicture.asset(
                          icon.asset,
                          width: isStairs ? 24 : 36, // stairs는 24, 나머지는 36
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

