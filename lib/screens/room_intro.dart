import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoomScreen extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const RoomScreen({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.doHyeon(  // AppBar 텍스트 글씨체 변경
            fontSize: 24,  // 원하는 크기로 설정
            color: Colors.black,  // 글씨색 변경 (기본은 흰색)
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 표시
            Image.asset(
              imagePath,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
            // 북마크 아이콘
            Align(
              alignment: Alignment.topLeft, // 원하는 위치로 설정
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20), // 위와 왼쪽에 여백을 추가
                child: SizedBox(
                  width: 47,
                  height: 49,
                  child: Image.asset(
                    'assets/images/Bookmark.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            // 설명 텍스트
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                description,
                style: GoogleFonts.doHyeon(  // GoogleFonts 패키지 사용
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
