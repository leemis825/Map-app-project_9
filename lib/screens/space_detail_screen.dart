import 'package:flutter/material.dart';
import '../models/models.dart';
import 'room_intro.dart'; // RoomScreen을 import

class SpaceDetailScreen extends StatelessWidget {
  final Space space;

  const SpaceDetailScreen({super.key, required this.space});

  @override
  Widget build(BuildContext context) {
    return RoomScreen(
      title: space.name,
      description: space.description,
      imagePath: 'assets/images/s.space.png', // 실제 이미지 경로로 교체
    );
  }
}
