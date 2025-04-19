import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart'; // ✅ 강의실 시간표 화면 import

class ItBuilding8fScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  ItBuilding8fScreen({super.key}); // ✅ 스크롤 컨트롤러

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IT융합대학 8층 지도'),
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
                'assets/images/it_building_8f_map.png', // ✅ 8층 도면
                fit: BoxFit.contain,
              ),

              // 왼쪽 강의실
              Positioned(left: 80, top: 150, child: roomButton(context, '8202')),
              Positioned(left: 180, top: 150, child: roomButton(context, '8206')),
              Positioned(left: 280, top: 150, child: roomButton(context, '8210')),
              Positioned(left: 360, top: 150, child: roomButton(context, '8212')),
              Positioned(left: 440, top: 150, child: roomButton(context, '8213')),

              // 아래쪽 강의실
              Positioned(left: 80, top: 300, child: roomButton(context, '8117')),
              Positioned(left: 160, top: 300, child: roomButton(context, '8119')),
              Positioned(left: 240, top: 300, child: roomButton(context, '8120')),
              Positioned(left: 320, top: 300, child: roomButton(context, '8122')),
              Positioned(left: 400, top: 300, child: roomButton(context, '8123')),
              Positioned(left: 480, top: 300, child: roomButton(context, '8125')),
              Positioned(left: 560, top: 300, child: roomButton(context, '8126')),
              Positioned(left: 640, top: 300, child: roomButton(context, '8128')),

              // 오른쪽 강의실
              Positioned(left: 750, top: 150, child: roomButton(context, '8221')),
              Positioned(left: 850, top: 150, child: roomButton(context, '8225')),
              Positioned(left: 950, top: 150, child: roomButton(context, '8226')),
              Positioned(left: 1050, top: 150, child: roomButton(context, '8228')),
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
