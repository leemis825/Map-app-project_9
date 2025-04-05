import 'package:flutter/material.dart';
import '../data/lecture_data.dart'; // ✅ 데이터 가져오기

class LectureScheduleScreen extends StatefulWidget {
  final String roomName;

  const LectureScheduleScreen({required this.roomName, Key? key}) : super(key: key);

  @override
  _LectureScheduleScreenState createState() => _LectureScheduleScreenState();
}

class _LectureScheduleScreenState extends State<LectureScheduleScreen> {
  late String currentRoomName;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentRoomName = widget.roomName;
    _controller.text = widget.roomName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$currentRoomName 강의실 시간표'),
      ),
      body: Column(
        children: [
          // 🔍 검색창
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: '강의실 번호를 입력하세요 (예: 2119)',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                setState(() {
                  currentRoomName = value;
                });
              },
            ),
          ),
          // 📋 시간표
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: _buildTimeTable(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeTable() {
    final List<String> days = ['월', '화', '수', '목', '금'];
    final List<String> times = [
      '0A\n08:00', '0B\n08:30',
      '1A\n09:00', '1B\n09:30',
      '2A\n10:00', '2B\n10:30',
      '3A\n11:00', '3B\n11:30',
      '4A\n12:00', '4B\n12:30',
      '5A\n13:00', '5B\n13:30',
      '6A\n14:00', '6B\n14:30',
      '7A\n15:00', '7B\n15:30',
      '8A\n16:00', '8B\n16:30',
      '9A\n17:00', '9B\n17:30',
      '10A\n18:00', '10B\n18:30',
      '11A\n19:00', '11B\n19:30',
      '12A\n20:00', '12B\n20:30',
      '13A\n21:00', '13B\n21:30',
      '14A\n22:00', '14B\n22:30',
      '15A\n23:00', '15B\n23:30',
    ];

    return Table(
      border: TableBorder.all(color: Colors.grey),
      defaultColumnWidth: FixedColumnWidth(80), // ✨ 열 너비 늘리기
      children: [
        // 🗓️ 요일 헤더
        TableRow(
          children: [
            Container(
              height: 50,
              color: Colors.white,
            ),
            ...days.map((day) => _buildHeaderCell(day)).toList(),
          ],
        ),
        // ⏰ 시간표 본문
        for (var time in times)
          TableRow(
            children: [
              _buildTimeCell(time),
              ...days.map((day) => _buildLectureCell(currentRoomName, day, time)).toList(),
            ],
          ),
      ],
    );
  }

  // 요일 헤더 셀
  Widget _buildHeaderCell(String day) {
    return Container(
      alignment: Alignment.center,
      color: Colors.blue[100],
      child: Text(
        day,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  // 시간 셀 (왼쪽)
  Widget _buildTimeCell(String time) {
    return Container(
      alignment: Alignment.center,
      color: Colors.grey[200],
      child: Text(
        time,
        textAlign: TextAlign.center,
      ),
    );
  }

  // 수업 셀
  Widget _buildLectureCell(String roomName, String day, String time) {
    String period = time.split('\n')[0]; // 0A, 1A, 이런 것
    final lectures = lectureData.where((lecture) => lecture['강의실'] == roomName).toList();

    for (var lecture in lectures) {
      List<String> slots = lecture['강의시간']!.split(',');

      for (var slot in slots) {
        if (slot.startsWith(day)) {
          var rangeWithTime = slot.substring(2).split('(')[0]; // "9A~9B"
          var range = rangeWithTime.split('~');

          String start = range[0].trim();
          String end = range[1].trim();

          if (_isPeriodInRange(period, start, end)) {
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(4),
              color: Colors.lightBlueAccent, // 💙 수업 있는 칸 색상
              child: Text(
                '${lecture['과목명']}\n${lecture['교수']}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10),
              ),
            );
          }
        }
      }
    }

    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: const Text(''),
    );
  }

  // 🔥 현재 시간(period)이 start ~ end 범위에 포함되는지 확인
  bool _isPeriodInRange(String period, String start, String end) {
    final Map<String, int> periodOrder = {
      '0A': 0, '0B': 1, '1A': 2, '1B': 3, '2A': 4, '2B': 5, '3A': 6, '3B': 7,
      '4A': 8, '4B': 9, '5A': 10, '5B': 11, '6A': 12, '6B': 13, '7A': 14, '7B': 15,
      '8A': 16, '8B': 17, '9A': 18, '9B': 19, '10A': 20, '10B': 21, '11A': 22, '11B': 23,
      '12A': 24, '12B': 25, '13A': 26, '13B': 27, '14A': 28, '14B': 29, '15A': 30, '15B': 31,
    };

    return periodOrder[period]! >= periodOrder[start]! && periodOrder[period]! <= periodOrder[end]!;
  }
}
