import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart'; // ✅ 강의실 시간표 화면 import

class ItBuilding3fScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  ItBuilding3fScreen({super.key}); // ✅ 스크롤 컨트롤러

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IT융합대학 3층 지도'),
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
                'assets/images/it_building_3f_map.png', // ✅ 3층 도면
                fit: BoxFit.contain,
              ),

              // 강의실 버튼들 (3층 강의실)
              Positioned(
                left: 80, top: 170,
                child: roomButton(context, '3104'),
              ),
              Positioned(
                left: 180, top: 170,
                child: roomButton(context, '3104-1'),
              ),
              Positioned(
                left: 260, top: 170,
                child: roomButton(context, '3104-3'),
              ),
              Positioned(
                left: 340, top: 170,
                child: roomButton(context, '3104-4'),
              ),
              Positioned(
                left: 420, top: 170,
                child: roomButton(context, '3104-5'),
              ),
              Positioned(
                left: 500, top: 250,
                child: roomButton(context, '3108'),
              ),
              Positioned(
                left: 580, top: 250,
                child: roomButton(context, '3108-1'),
              ),
              Positioned(
                left: 660, top: 250,
                child: roomButton(context, '3108-2'),
              ),
              Positioned(
                left: 800, top: 100,
                child: roomButton(context, '3203'),
              ),
              Positioned(
                left: 900, top: 100,
                child: roomButton(context, '3208'),
              ),
              Positioned(
                left: 1000, top: 100,
                child: roomButton(context, '3210-1'),
              ),
              Positioned(
                left: 1100, top: 100,
                child: roomButton(context, '3210'),
              ),
              Positioned(
                left: 1200, top: 100,
                child: roomButton(context, '3214'),
              ),
              Positioned(
                left: 1350, top: 100,
                child: roomButton(context, '3220'),
              ),
              Positioned(
                left: 1450, top: 100,
                child: roomButton(context, '3224'),
              ),
              Positioned(
                left: 1550, top: 100,
                child: roomButton(context, '3228'),
              ),
              Positioned(
                left: 1400, top: 200,
                child: roomButton(context, '3120'),
              ),
              Positioned(
                left: 1500, top: 200,
                child: roomButton(context, '3128'),
              ),
              // 📌 추가 필요한 강의실 있으면 또 추가 가능
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
