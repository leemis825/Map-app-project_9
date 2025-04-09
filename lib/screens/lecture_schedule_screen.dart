import 'package:flutter/material.dart';
import '../data/lecture_data.dart'; // ✅ LectureDataManager 가져오기

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
                hintText: '강의실 번호를 입력하세요 (예: 3228)',
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
      defaultColumnWidth: FixedColumnWidth(80),
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

  Widget _buildLectureCell(String roomName, String day, String time) {
    String period = time.split('\n')[0]; // 예: "1A"
    final lectures = LectureDataManager.getLecturesForRoom(roomName); // ✅ 강의실별 데이터 가져오기

    for (var lecture in lectures) {
      if (lecture['day'] == day) {
        if (_isPeriodInTimeRange(period, lecture['start'], lecture['end'])) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(4),
            color: Colors.lightBlueAccent,
            child: Text(
              '${lecture['subject']}\n${lecture['professor']}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10),
            ),
          );
        }
      }
    }

    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: const Text(''),
    );
  }

  bool _isPeriodInTimeRange(String period, String startTime, String endTime) {
    final periodOrder = {
      '0A': '08:00', '0B': '08:30', '1A': '09:00', '1B': '09:30',
      '2A': '10:00', '2B': '10:30', '3A': '11:00', '3B': '11:30',
      '4A': '12:00', '4B': '12:30', '5A': '13:00', '5B': '13:30',
      '6A': '14:00', '6B': '14:30', '7A': '15:00', '7B': '15:30',
      '8A': '16:00', '8B': '16:30', '9A': '17:00', '9B': '17:30',
      '10A': '18:00', '10B': '18:30', '11A': '19:00', '11B': '19:30',
      '12A': '20:00', '12B': '20:30', '13A': '21:00', '13B': '21:30',
      '14A': '22:00', '14B': '22:30', '15A': '23:00', '15B': '23:30',
    };

    if (!periodOrder.containsKey(period)) return false;

    String periodTime = periodOrder[period]!;

    return (periodTime.compareTo(startTime) >= 0 && periodTime.compareTo(endTime) <= 0);
  }
}