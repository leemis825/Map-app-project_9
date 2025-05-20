import 'package:flutter/material.dart';
import '../models/models.dart';
import 'room_intro.dart'; // RoomScreen을 import

class SpaceDetailScreen extends StatelessWidget {
  final Space space;

  const SpaceDetailScreen({super.key, required this.space});
  String getImagePath(String spaceName) {
    switch (spaceName) {
      case 'i.space':
        return 'assets/images/i.space.png';
      case 's.space':
        return 'assets/images/s.space.png';
      case 'tdm.space':
        return 'assets/images/tdm.space.png';
      default:
        return 'assets/images/default.png'; // 예비 이미지
    }
  }
  @override
  Widget build(BuildContext context) {
    return RoomScreen(
      title: space.name,
      description: space.description,
      imagePath: getImagePath(space.name), // 실제 이미지 경로로 교체
    );
  }
}
