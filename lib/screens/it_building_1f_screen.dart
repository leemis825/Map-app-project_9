import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart'; // 공통 모델 불러오기
import '../widgets/lecturestatusdot.dart'; // LectureStatusDot import 추가

class ItBuilding1fScreen extends StatelessWidget {
  final double imageWidth = 2518; // 1층 도면 원본 가로 크기
  final double imageHeight = 1147; // 1층 도면 원본 세로 크기

  final List<RoomInfo> rooms = [
    RoomInfo(name: '1103', left: 510, top: 359),
    RoomInfo(name: '1122', left: 1709, top: 414),
    RoomInfo(name: '1125', left: 1933, top: 414),
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
          double screenWidth = constraints.maxWidth; // 화면 가로 크기
          double screenHeight = constraints.maxHeight; // 화면 세로 크기
          double scale = screenHeight / imageHeight; // 화면 비율 계산
          double scaledImageWidth = imageWidth * scale; // 이미지 가로 크기 비율 조정

          return Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),  // 스크롤 물리 엔진 설정 (웹에서 동작하게 하기 위해)
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
                    // 강의실 버튼
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
                        left: left + 32, // 강의실 이름 옆에 배치하려면 + 약간의 오프셋 추가
                        top: top + 40, // 강의실 위쪽으로 조금 배치
                        child: LectureStatusDot(roomName: room.name), // 상태 점 표시
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
        height: 60,
        alignment: Alignment.center,
        color: Colors.transparent,
        /*child: Text(                  //컴포넌트 위치 확인용 텍스트, 삭제 X
          roomName,
          style: GoogleFonts.doHyeon(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0054A7),
          ),
        ),*/
      ),
    );
  }
}
