import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart';

class ItBuilding1fScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IT 융합대학 1층 지도'),
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
              'assets/images/it_building_1f_map.png',
              fit: BoxFit.contain,
            ),

            // ✅ 강의실 버튼들
            Positioned(left: 230, top: 225, child: roomButton(context, '1103')),
            Positioned(left: 1030, top: 250, child: roomButton(context, '1122')),
            Positioned(left: 1170, top: 250, child: roomButton(context, '1125')),
            ],
          ),
        ),
      ),
    );
  }

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
