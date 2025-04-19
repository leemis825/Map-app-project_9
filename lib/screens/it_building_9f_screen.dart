import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart'; // ✅ 강의실 시간표 화면 import

class ItBuilding9fScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  ItBuilding9fScreen({super.key}); // ✅ 스크롤 컨트롤러

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IT융합대학 9층 지도'),
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
                'assets/images/it_building_9f_map.png', // ✅ 9층 도면
                fit: BoxFit.contain,
              ),

              // 왼쪽 강의실
              Positioned(left: 80, top: 150, child: roomButton(context, '9202')),
              Positioned(left: 180, top: 150, child: roomButton(context, '9206')),
              Positioned(left: 280, top: 150, child: roomButton(context, '9210')),
              Positioned(left: 360, top: 150, child: roomButton(context, '9212')),
              Positioned(left: 440, top: 150, child: roomButton(context, '9213')),

              // 아래쪽 강의실
              Positioned(left: 80, top: 300, child: roomButton(context, '9103')),
              Positioned(left: 160, top: 300, child: roomButton(context, '9105')),
              Positioned(left: 240, top: 300, child: roomButton(context, '9106')),
              Positioned(left: 320, top: 300, child: roomButton(context, '9108')),
              Positioned(left: 400, top: 300, child: roomButton(context, '9109')),
              Positioned(left: 480, top: 300, child: roomButton(context, '9111')),
              Positioned(left: 560, top: 300, child: roomButton(context, '9112')),
              Positioned(left: 640, top: 300, child: roomButton(context, '9114')),

              // 오른쪽 강의실
              Positioned(left: 750, top: 150, child: roomButton(context, '9221')),
              Positioned(left: 850, top: 150, child: roomButton(context, '9225')),
              Positioned(left: 950, top: 150, child: roomButton(context, '9226')),
              Positioned(left: 1050, top: 150, child: roomButton(context, '9228')),

              // 오른쪽 아래 강의실
              Positioned(left: 750, top: 300, child: roomButton(context, '9117')),
              Positioned(left: 830, top: 300, child: roomButton(context, '9119')),
              Positioned(left: 910, top: 300, child: roomButton(context, '9120')),
              Positioned(left: 990, top: 300, child: roomButton(context, '9122')),
              Positioned(left: 1070, top: 300, child: roomButton(context, '9123')),
              Positioned(left: 1150, top: 300, child: roomButton(context, '9125')),
              Positioned(left: 1230, top: 300, child: roomButton(context, '9126')),
              Positioned(left: 1310, top: 300, child: roomButton(context, '9128')),
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
