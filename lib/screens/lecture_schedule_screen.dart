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
              // 엔터 입력 시 강의실 이름 갱신
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
                scrollDirection: Axis.vertical, // 수직 스크롤
                child: _buildTimeTable(), // 시간표 생성 함수 호출
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 시간표 테이블을 구성하는 함수
  Widget _buildTimeTable() {
    // 요일 목록
    final List<String> days = ['월', '화', '수', '목', '금'];

    // 시간대 목록 (30분 단위)
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

    // LayoutBuilder를 사용해 화면의 너비 측정
    return LayoutBuilder(
      builder: (context, constraints) {
        final double timeColumnWidth = 60; // 시간 열의 고정 너비
        final double dayColumnWidth = (constraints.maxWidth - timeColumnWidth) / 5; // 요일 열 너비 계산

        return Table(
          border: TableBorder.all(color: Colors.grey), // 테두리 설정
          columnWidths: {
            0: const FixedColumnWidth(60), // 첫 번째 열은 시간
            for (int i = 1; i <= 5; i++) i: FixedColumnWidth(dayColumnWidth), // 월~금 요일 열
          },
          children: [
            // 상단 요일 헤더 행
            TableRow(
              children: [
                Container(height: 50, color: Colors.white), // 시간 헤더 빈칸
                ...days.map((day) => _buildHeaderCell(day)).toList(), // 요일 헤더
              ],
            ),
<<<<<<< HEAD
            ...days.map((day) => _buildHeaderCell(day)),
          ],
        ),
        // ⏰ 시간표 본문
        for (var time in times)
          TableRow(
            children: [
              _buildTimeCell(time),
              ...days.map((day) => _buildLectureCell(currentRoomName, day, time)),
            ],
          ),
      ],
=======
            // 각 시간대에 대해 테이블 행 생성
            for (var time in times)
              TableRow(
                children: [
                  _buildTimeCell(time), // 시간 셀
                  ...days.map((day) => _buildLectureCell(currentRoomName, day, time)).toList(), // 강의 셀
                ],
              ),
          ],
        );
      },
>>>>>>> yefin
    );
  }

  // 요일 헤더 셀 생성
  Widget _buildHeaderCell(String day) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.fill, // ✅ 셀 전체 채우기
      child: Container(
        alignment: Alignment.center,
        color: Colors.pink[50], // 분홍 배경
        constraints: const BoxConstraints(minHeight: 20), // ✅ 최소 높이 설정
        child: Text(
          day,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // 시간 셀 생성
  // 시간 셀 생성
  Widget _buildTimeCell(String time) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.fill, // ✅ 셀 전체 채우기
      child: Container(
        alignment: Alignment.center,
        color: Colors.grey[200], // 회색 배경
        constraints: const BoxConstraints(minHeight: 40), // ✅ 최소 높이로 통일
        child: Text(
          time,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }


  // 강의 셀 생성 (특정 요일+시간+강의실에 강의가 있다면 표시)
  // 강의 셀 생성 (특정 요일+시간+강의실에 강의가 있다면 표시)
  Widget _buildLectureCell(String roomName, String day, String time) {
    String period = time.split('\n')[0]; // '1A' 등 추출
    final lectures = LectureDataManager.getLecturesForRoom(roomName); // 해당 강의실의 모든 강의 목록

    for (var lecture in lectures) {
      if (lecture['day'] == day) {
        if (_isPeriodInTimeRange(period, lecture['start'], lecture['end'])) {
          // 강의 시간에 해당하면 내용 출력
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10), // 높이를 고정해서 줄 높이 통일!
            color: Colors.lightBlueAccent, // 하늘색 배경
            child: Text(
              '${lecture['subject']}\n${lecture['professor']}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10),
            ),
          );
        }
      }
    }

    // 해당 시간에 강의 없을 경우 빈 셀 (배경색을 투명하게 처리)
    return Container(
      alignment: Alignment.center,
      constraints: const BoxConstraints(minHeight: 40), // 빈칸 높이 맞추기
      child: const Text(''),
    );
  }


  // 시간대(period)가 시작~끝 범위에 포함되는지 확인하는 함수
  bool _isPeriodInTimeRange(String period, String startTime, String endTime) {
    // period를 실제 시간으로 변환하는 매핑
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

    // 해당 시간이 start~end 사이에 포함되면 true 반환
    return (periodTime.compareTo(startTime) >= 0 && periodTime.compareTo(endTime) <= 0);
  }
}
