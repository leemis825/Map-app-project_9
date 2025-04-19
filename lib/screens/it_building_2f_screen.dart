import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart'; // ✅ 강의실 시간표 화면 import

class ItBuilding2fScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  ItBuilding2fScreen({super.key}); // ✅ 스크롤 컨트롤러

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IT융합대학 2층 지도'),
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
                'assets/images/it_building_2f_map.png', // ✅ 2층 도면 파일
                fit: BoxFit.contain,
              ),

              // 강의실 버튼들 (2층 강의실)
              Positioned(
                left: 80, top: 170,
                child: roomButton(context, '2104'),
              ),
              Positioned(
                left: 230, top: 170,
                child: roomButton(context, '2115-1'),
              ),
              Positioned(
                left: 380, top: 170,
                child: roomButton(context, '2105-2'),
              ),
              Positioned(
                left: 600, top: 100,
                child: roomButton(context, '2204'),
              ),
              Positioned(
                left: 700, top: 100,
                child: roomButton(context, '2205'),
              ),
              Positioned(
                left: 800, top: 100,
                child: roomButton(context, '2210-1'),
              ),
              Positioned(
                left: 900, top: 100,
                child: roomButton(context, '2210'),
              ),
              Positioned(
                left: 1000, top: 100,
                child: roomButton(context, '2211'),
              ),
              Positioned(
                left: 700, top: 150,
                child: roomButton(context, '2119'),
              ),
              Positioned(
                left: 1250, top: 170,
                child: roomButton(context, '2122'),
              ),
              Positioned(
                left: 1350, top: 170,
                child: roomButton(context, '2125'),
              ),
              Positioned(
                left: 1450, top: 170,
                child: roomButton(context, '2128'),
              ),
              Positioned(
                left: 1500, top: 100,
                child: roomButton(context, '2225'),
              ),
              Positioned(
                left: 1600, top: 100,
                child: roomButton(context, '2228'),
              ),
              // 📌 추가로 필요한 강의실은 계속 추가 가능
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
