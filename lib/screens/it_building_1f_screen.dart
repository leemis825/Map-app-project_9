import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart'; // ✅ 강의실 시간표 화면 import
import 'floor_selector_screen.dart'; // ✅ 층 이동 화면 import (이건 곧 만들어줄게)

class ItBuilding1fScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController(); // ✅ 스크롤 컨트롤러

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IT융합대학 1층 지도'),
        actions: [
          IconButton(
            icon: const Icon(Icons.layers), // 층 이동 아이콘
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FloorSelectorScreen()), // ✅ 층 선택 화면으로 이동
              );
            },
          ),
        ],
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
                'assets/images/it_building_1f_map.png', // 1층 도면
                fit: BoxFit.contain,
              ),

              // ✅ 강의실 버튼 (위치 대략 설정)
              Positioned(left: 100, top: 150, child: roomButton(context, '1101')),
              Positioned(left: 200, top: 150, child: roomButton(context, '1103')),
              Positioned(left: 300, top: 150, child: roomButton(context, '1105')), // 1105-1, 1105-2 => 통합
              Positioned(left: 400, top: 150, child: roomButton(context, '1107')),
              Positioned(left: 500, top: 150, child: roomButton(context, '1210')),

              Positioned(left: 650, top: 250, child: roomButton(context, '1119')),
              Positioned(left: 750, top: 250, child: roomButton(context, '1122')),
              Positioned(left: 850, top: 250, child: roomButton(context, '1125')),
              Positioned(left: 950, top: 250, child: roomButton(context, '1128')),

              Positioned(left: 100, top: 450, child: roomButton(context, '1006')), // 1006-1 ~ 1006-6 통합
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
      child: Text(
        roomName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
