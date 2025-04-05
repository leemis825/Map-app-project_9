import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart'; // ✅ 강의실 시간표 화면 import

class ItBuilding6fScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController(); // ✅ 스크롤 컨트롤러

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IT융합대학 6층 지도'),
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
                'assets/images/it_building_6f_map.png', // ✅ 6층 도면
                fit: BoxFit.contain,
              ),

              // 왼쪽 강의실
              Positioned(left: 80, top: 150, child: roomButton(context, '6202')),
              Positioned(left: 160, top: 150, child: roomButton(context, '6203')),
              Positioned(left: 240, top: 150, child: roomButton(context, '6210')),
              Positioned(left: 320, top: 150, child: roomButton(context, '6212')),
              Positioned(left: 400, top: 150, child: roomButton(context, '6213')),

              // 아래쪽 강의실
              Positioned(left: 80, top: 300, child: roomButton(context, '6103')),
              Positioned(left: 160, top: 300, child: roomButton(context, '6103-1')),
              Positioned(left: 240, top: 300, child: roomButton(context, '6108')),
              Positioned(left: 320, top: 300, child: roomButton(context, '6109')),
              Positioned(left: 400, top: 300, child: roomButton(context, '6111')),
              Positioned(left: 480, top: 300, child: roomButton(context, '6112')),
              Positioned(left: 560, top: 300, child: roomButton(context, '6114')),

              // 오른쪽 강의실
              Positioned(left: 700, top: 150, child: roomButton(context, '6221')),
              Positioned(left: 780, top: 150, child: roomButton(context, '6225')),
              Positioned(left: 860, top: 150, child: roomButton(context, '6226')),
              Positioned(left: 940, top: 150, child: roomButton(context, '6228')),

              Positioned(left: 700, top: 300, child: roomButton(context, '6117')),
              Positioned(left: 780, top: 300, child: roomButton(context, '6119')),
              Positioned(left: 860, top: 300, child: roomButton(context, '6120')),
              Positioned(left: 940, top: 300, child: roomButton(context, '6122')),
              Positioned(left: 1020, top: 300, child: roomButton(context, '6123')),
              Positioned(left: 1100, top: 300, child: roomButton(context, '6125')),
              Positioned(left: 1180, top: 300, child: roomButton(context, '6126')),
              Positioned(left: 1260, top: 300, child: roomButton(context, '6128')),
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
