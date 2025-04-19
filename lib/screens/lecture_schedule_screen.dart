import 'package:flutter/material.dart';
import '../data/lecture_data.dart'; // 강의 데이터를 가져오는 클래스

// 강의실 시간표 화면을 나타내는 StatefulWidget
class LectureScheduleScreen extends StatefulWidget {
  final String roomName; // 초기 강의실 이름

  const LectureScheduleScreen({required this.roomName, super.key});

  @override
  _LectureScheduleScreenState createState() => _LectureScheduleScreenState();
}

class _LectureScheduleScreenState extends State<LectureScheduleScreen> {
  late String currentRoomName; // 현재 표시 중인 강의실 이름
  final TextEditingController _controller = TextEditingController(); // 검색창 입력 컨트롤러

  @override
  void initState() {
    super.initState();
    currentRoomName = widget.roomName; // 초기 강의실 설정
    _controller.text = widget.roomName; // 텍스트 필드에도 초기값 설정
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ 앱 전체 배경을 흰색으로 설정
      appBar: AppBar(
        title: Text('$currentRoomName 강의실 시간표'), // 상단 제목
      ),
      body: Column(
        children: [
          // 🔍 검색창 위젯
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
          // 📋 시간표 표 출력 부분
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: _buildTimeTable(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 시간표 테이블을 구성하는 함수
  Widget _buildTimeTable() {
    final List<String> days = ['월', '화', '수', '목', '금'];
    final List<String> times = [
      '0A\n08:00', '0B\n08:30', '1A\n09:00', '1B\n09:30',
      '2A\n10:00', '2B\n10:30', '3A\n11:00', '3B\n11:30',
      '4A\n12:00', '4B\n12:30', '5A\n13:00', '5B\n13:30',
      '6A\n14:00', '6B\n14:30', '7A\n15:00', '7B\n15:30',
      '8A\n16:00', '8B\n16:30', '9A\n17:00', '9B\n17:30',
      '10A\n18:00', '10B\n18:30', '11A\n19:00', '11B\n19:30',
      '12A\n20:00', '12B\n20:30', '13A\n21:00', '13B\n21:30',
      '14A\n22:00', '14B\n22:30', '15A\n23:00', '15B\n23:30',
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final double timeColumnWidth = 60;
        final double dayColumnWidth = (constraints.maxWidth - timeColumnWidth) / 5;

        return Table(
          border: TableBorder.all(color: Colors.grey),
          columnWidths: {
            0: const FixedColumnWidth(60),
            for (int i = 1; i <= 5; i++) i: FixedColumnWidth(dayColumnWidth),
          },
          children: [
            TableRow(
              children: [
                Container(height: 50, color: Colors.white),
                ...days.map((day) => _buildHeaderCell(day)).toList(),
              ],
            ),
            for (var time in times)
              TableRow(
                children: [
                  _buildTimeCell(time),
                  ...days.map((day) => _buildLectureCell(currentRoomName, day, time)).toList(),
                ],
              ),
          ],
        );
      },
    );
  }

  Widget _buildHeaderCell(String day) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.fill,
      child: Container(
        alignment: Alignment.center,
        color: Colors.pink[50],
        constraints: const BoxConstraints(minHeight: 20),
        child: Text(
          day,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTimeCell(String time) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.fill,
      child: Container(
        alignment: Alignment.center,
        color: Colors.grey[200],
        constraints: const BoxConstraints(minHeight: 40),
        child: Text(
          time,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildLectureCell(String roomName, String day, String time) {
    String period = time.split('\n')[0];
    final lectures = LectureDataManager.getLecturesForRoom(roomName);

    for (var lecture in lectures) {
      if (lecture['day'] == day) {
        if (_isPeriodInTimeRange(period, lecture['start'], lecture['end'])) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
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
      constraints: const BoxConstraints(minHeight: 40),
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
