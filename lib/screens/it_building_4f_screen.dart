import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart'; // ✅ 강의실 시간표 화면 import

class ItBuilding4fScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  ItBuilding4fScreen({super.key}); // ✅ 스크롤 컨트롤러

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IT융합대학 4층 지도'),
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
                'assets/images/it_building_4f_map.png', // ✅ 4층 도면
                fit: BoxFit.contain,
              ),

              // 강의실 버튼들 (4층 강의실)
              Positioned(
                left: 80, top: 150,
                child: roomButton(context, '4204'),
              ),
              Positioned(
                left: 160, top: 150,
                child: roomButton(context, '4205'),
              ),
              Positioned(
                left: 240, top: 150,
                child: roomButton(context, '4206'),
              ),
              Positioned(
                left: 320, top: 150,
                child: roomButton(context, '4207'),
              ),
              Positioned(
                left: 400, top: 150,
                child: roomButton(context, '4208'),
              ),
              Positioned(
                left: 480, top: 150,
                child: roomButton(context, '4209'),
              ),
              Positioned(
                left: 560, top: 150,
                child: roomButton(context, '4210'),
              ),
              Positioned(
                left: 640, top: 150,
                child: roomButton(context, '4211'),
              ),
              Positioned(
                left: 720, top: 150,
                child: roomButton(context, '4212'),
              ),
              Positioned(
                left: 800, top: 150,
                child: roomButton(context, '4213'),
              ),
              Positioned(
                left: 900, top: 150,
                child: roomButton(context, '4218'),
              ),
              Positioned(
                left: 1000, top: 150,
                child: roomButton(context, '4222'),
              ),
              Positioned(
                left: 1100, top: 150,
                child: roomButton(context, '4225'),
              ),
              Positioned(
                left: 1200, top: 150,
                child: roomButton(context, '4228'),
              ),
              Positioned(
                left: 950, top: 300,
                child: roomButton(context, '4120'),
              ),
              Positioned(
                left: 1050, top: 300,
                child: roomButton(context, '4122'),
              ),
              Positioned(
                left: 1150, top: 300,
                child: roomButton(context, '4123'),
              ),
              Positioned(
                left: 1250, top: 300,
                child: roomButton(context, '4124'),
              ),
              Positioned(
                left: 1350, top: 300,
                child: roomButton(context, '4125'),
              ),
              Positioned(
                left: 1450, top: 300,
                child: roomButton(context, '4126'),
              ),
              Positioned(
                left: 1550, top: 300,
                child: roomButton(context, '4127'),
              ),
              Positioned(
                left: 1650, top: 300,
                child: roomButton(context, '4128'),
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
