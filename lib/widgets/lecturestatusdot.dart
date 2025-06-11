import 'package:flutter/material.dart';
import '../data/lecture_data.dart';

class LectureStatusDot extends StatelessWidget {
  final String roomName;

  const LectureStatusDot({required this.roomName, super.key});

  @override
  Widget build(BuildContext context) {
    final isOngoing = LectureDataManager.isLectureOngoing(roomName);

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: isOngoing ? Colors.red : Colors.grey,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
      ),
    );
  }
}
