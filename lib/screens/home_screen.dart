import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key}); // const 생성자 추가
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('조선대학교 Home Screen'),
      ),
      body: Center(
        child: Text('여기는 본관 / IT융합대학 상세 페이지!'),
      ),
    );
  }
}
