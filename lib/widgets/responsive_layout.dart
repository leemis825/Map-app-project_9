import 'package:flutter/material.dart';

/// 이 위젯은 다양한 화면 크기에서 일관된 UI를 보여주기 위해
/// 최대 너비를 제한하고 중앙 정렬을 적용합니다.
class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveLayout({
    super.key,
    required this.child,
    this.maxWidth = 430, // 기본 모바일 기준 폭
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;

          // 화면 크기가 600px 이상이면 maxWidth 없이 전체 너비를 사용
          if (screenWidth > 600) {
            return child;
          } else {
            // 화면 크기가 작으면 maxWidth를 적용하여 자식 위젯의 너비를 제한
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: child,
            );
          }
        },
      ),
    );
  }
}
