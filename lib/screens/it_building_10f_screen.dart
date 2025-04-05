import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart'; // ✅ 강의실 시간표 화면 import

class ItBuilding10fScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController(); // ✅ 스크롤 컨트롤러

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IT융합대학 10층 지도'),
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
                'assets/images/it_building_10f_map.png', // ✅ 10층 도면
                fit: BoxFit.contain,
              ),

              // 왼쪽 강의실
              Positioned(left: 80, top: 150, child: roomButton(context, '10202')),
              Positioned(left: 180, top: 150, child: roomButton(context, '10206')),
              Positioned(left: 280, top: 150, child: roomButton(context, '10210')),
              Positioned(left: 360, top: 150, child: roomButton(context, '10212')),
              Positioned(left: 440, top: 150, child: roomButton(context, '10213')),

              // 아래쪽 강의실
              Positioned(left: 80, top: 300, child: roomButton(context, '10103')),
              Positioned(left: 160, top: 300, child: roomButton(context, '10105')),
              Positioned(left: 240, top: 300, child: roomButton(context, '10106')),
              Positioned(left: 320, top: 300, child: roomButton(context, '10108')),
              Positioned(left: 400, top: 300, child: roomButton(context, '10109')),
              Positioned(left: 480, top: 300, child: roomButton(context, '10111')),
              Positioned(left: 560, top: 300, child: roomButton(context, '10112')),
              Positioned(left: 640, top: 300, child: roomButton(context, '10114')),

              // 오른쪽 강의실
              Positioned(left: 750, top: 150, child: roomButton(context, '10221')),
              Positioned(left: 850, top: 150, child: roomButton(context, '10225')),
              Positioned(left: 950, top: 150, child: roomButton(context, '10228')),

              // 오른쪽 아래 강의실
              Positioned(left: 750, top: 300, child: roomButton(context, '10117')),
              Positioned(left: 830, top: 300, child: roomButton(context, '10119')),
              Positioned(left: 910, top: 300, child: roomButton(context, '10120')),
              Positioned(left: 990, top: 300, child: roomButton(context, '10122')),
              Positioned(left: 1070, top: 300, child: roomButton(context, '10123')),
              Positioned(left: 1150, top: 300, child: roomButton(context, '10125')),
              Positioned(left: 1230, top: 300, child: roomButton(context, '10126')),
              Positioned(left: 1310, top: 300, child: roomButton(context, '10128')),
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
