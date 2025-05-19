import 'package:flutter/material.dart';

class LectureScheduleScreen extends StatelessWidget {
  final String? roomName;

  const LectureScheduleScreen({this.roomName, super.key});

  static const List<String> days = ['월', '화', '수', '목', '금'];
  static const List<String> times = [
    '1교시',
    '2교시',
    '3교시',
    '4교시',
    '5교시',
    '6교시',
    '7교시',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(roomName != null ? '$roomName 시간표' : '내 시간표')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Table(
          border: TableBorder.all(),
          columnWidths: const {
            0: FixedColumnWidth(60), // 시간 표시 칸
          },
          children: [
            // 헤더 행
            TableRow(
              children: [
                const TableCell(child: Center(child: Text('시간'))),
                ...days.map(
                  (day) => TableCell(child: Center(child: Text(day))),
                ),
              ],
            ),
            // 시간표 행들
            ...times.map(
              (time) => TableRow(
                children: [
                  TableCell(child: Center(child: Text(time))),
                  ...List.generate(days.length, (index) {
                    return const TableCell(
                      child: SizedBox(
                        height: 50,
                        child: Center(child: Text('')),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
