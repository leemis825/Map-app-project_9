import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart'; // ✅ 강의실 시간표 화면 import

class ItBuilding5fScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController(); // ✅ 스크롤 컨트롤러

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IT융합대학 5층 지도'),
      ),
      body: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Stack(
            children: [
              Image.asset(
                'assets/images/it_building_5f_map.png', // ✅ 5층 도면
                fit: BoxFit.contain,
              ),

              // 강의실 버튼들 (5층 강의실)
              Positioned(left: 80, top: 150, child: roomButton(context, '5205-1')),
              Positioned(left: 160, top: 150, child: roomButton(context, '5205')),
              Positioned(left: 240, top: 150, child: roomButton(context, '5209')),
              Positioned(left: 320, top: 150, child: roomButton(context, '5212')),
              Positioned(left: 400, top: 150, child: roomButton(context, '5213')),
              Positioned(left: 480, top: 150, child: roomButton(context, '5219')),
              Positioned(left: 560, top: 150, child: roomButton(context, '5220')),
              Positioned(left: 640, top: 150, child: roomButton(context, '5221')),
              Positioned(left: 720, top: 150, child: roomButton(context, '5222')),
              Positioned(left: 800, top: 150, child: roomButton(context, '5223')),
              Positioned(left: 880, top: 150, child: roomButton(context, '5224')),
              Positioned(left: 960, top: 150, child: roomButton(context, '5227-1')),
              Positioned(left: 1040, top: 150, child: roomButton(context, '5227-2')),
              Positioned(left: 1120, top: 150, child: roomButton(context, '5227-3')),
              Positioned(left: 1200, top: 150, child: roomButton(context, '5227-4')),
              Positioned(left: 1280, top: 150, child: roomButton(context, '5227-5')),
              Positioned(left: 1360, top: 150, child: roomButton(context, '5227-6')),

              // 아래쪽 강의실
              Positioned(left: 500, top: 300, child: roomButton(context, '5111')),
              Positioned(left: 600, top: 300, child: roomButton(context, '5114')),
              Positioned(left: 700, top: 300, child: roomButton(context, '5117')),
              Positioned(left: 800, top: 300, child: roomButton(context, '5118')),
              Positioned(left: 900, top: 300, child: roomButton(context, '5119')),
              Positioned(left: 1000, top: 300, child: roomButton(context, '5120')),
              Positioned(left: 1100, top: 300, child: roomButton(context, '5121')),
              Positioned(left: 1200, top: 300, child: roomButton(context, '5122')),
              Positioned(left: 1300, top: 300, child: roomButton(context, '5123')),
              Positioned(left: 1400, top: 300, child: roomButton(context, '5125')),
              Positioned(left: 1500, top: 300, child: roomButton(context, '5126')),
              Positioned(left: 1580, top: 300, child: roomButton(context, '5126-1')),
              Positioned(left: 1660, top: 300, child: roomButton(context, '5126-2')),
              Positioned(left: 1740, top: 300, child: roomButton(context, '5126-3')),
              Positioned(left: 1820, top: 300, child: roomButton(context, '5126-4')),
              Positioned(left: 1900, top: 300, child: roomButton(context, '5126-5')),
              Positioned(left: 1980, top: 300, child: roomButton(context, '5126-6')),
              Positioned(left: 2060, top: 300, child: roomButton(context, '5126-7')),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ 강의실 버튼 위젯
  Widget roomButton(BuildContext context, String roomName) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.deepPurple),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LectureScheduleScreen(roomName: roomName),
          ),
        );
      },
      child: Text(roomName, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
