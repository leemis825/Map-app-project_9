// ✅ 완전 병합 셀 구조의 시간표 UI 구현 - Stack + Positioned 기반
// ✅ 교시(A/B)와 시간 추가 (왼쪽 열 고정, 2열 구조)
// ✅ 교시와 시간 수평 정렬 (overflow 해결)
// ✅ 기존 기능(검색, 터치 이동, 병합 셀) 전혀 변동 없음

import 'package:flutter/material.dart';
import '../data/lecture_data.dart';
import 'lecture_detail_screen.dart';

class LectureScheduleScreen extends StatefulWidget {
  final String roomName;
  const LectureScheduleScreen({required this.roomName, super.key});

  @override
  State<LectureScheduleScreen> createState() => _LectureScheduleScreenState();
}

class _LectureScheduleScreenState extends State<LectureScheduleScreen> {
  late String currentRoomName;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> suggestions = [];

  final List<String> days = ['월', '화', '수', '목', '금'];
  final List<String> timeSlots = [
    '08:00', '08:30', '09:00', '09:30',
    '10:00', '10:30', '11:00', '11:30',
    '12:00', '12:30', '13:00', '13:30',
    '14:00', '14:30', '15:00', '15:30',
    '16:00', '16:30', '17:00', '17:30',
    '18:00', '18:30', '19:00', '19:30',
  ];

  final Map<String, Color> subjectColors = {
    '수학': Colors.lightBlue,
    '영어': Colors.green,
    '과학': Colors.deepPurple,
    '국어': Colors.redAccent,
    '역사': Colors.orange,
    '예체능': Colors.pinkAccent,
    '기본': Colors.blue.shade300,
  };

  @override
  void initState() {
    super.initState();
    currentRoomName = widget.roomName;
    _controller.text = widget.roomName;
  }

  void _handleSearch(String keyword) {
    keyword = keyword.trim();
    if (_dataContainsRoom(keyword)) {
      setState(() {
        currentRoomName = keyword;
        suggestions.clear();
      });
    } else {
      setState(() {
        suggestions = LectureDataManager.searchLecturesByKeyword(keyword);
        if (suggestions.isEmpty) {
          suggestions = [
            {'subject': '검색 결과 없음', 'roomName': '', 'professor': ''},
          ];
        }
      });
    }
  }

  bool _dataContainsRoom(String roomName) {
    return LectureDataManager.getLecturesForRoom(roomName).isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF004098),
        title: Text('$currentRoomName 강의실 시간표'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("자주 묻는 질문을 확인하세요!")),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: '강의실, 강의명, 교수명 검색',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _handleSearch,
              onSubmitted: _handleSearch,
            ),
          ),
          if (suggestions.isNotEmpty)
            Container(
              height: 150,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView.builder(
                itemCount: suggestions.length.clamp(0, 3),
                itemBuilder: (context, index) {
                  final item = suggestions[index];
                  if (item['subject'] == '검색 결과 없음') {
                    return ListTile(
                      title: Text('🔍 ${_controller.text}에 대한 결과가 없습니다.'),
                    );
                  }
                  return ListTile(
                    title: Text('📘 ${item['subject']} (${item['roomName']})'),
                    subtitle: Text('👨‍🏫 ${item['professor']}'),
                    onTap: () {
                      setState(() {
                        currentRoomName = item['roomName'];
                        _controller.text = item['roomName'];
                        suggestions.clear();
                      });
                    },
                  );
                },
              ),
            ),
          Expanded(child: _buildCustomTimeTable()),
        ],
      ),
    );
  }

  Widget _buildCustomTimeTable() {
    final lectures = LectureDataManager.getLecturesForRoom(currentRoomName);

    const double dayCellWidth = 70;
    const double timeCellHeight = 40;
    const double timeLabelWidth = 90;
    const double dayLabelHeight = 30;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: timeLabelWidth + dayCellWidth * days.length,
          height: dayLabelHeight + timeCellHeight * timeSlots.length,
          child: Stack(
            children: [
              Positioned.fill(
                child: Column(
                  children: [
                    SizedBox(height: dayLabelHeight),
                    ...List.generate(timeSlots.length, (i) {
                      final int period = i ~/ 2;
                      final String half = (i % 2 == 0) ? 'A' : 'B';
                      final bool isFirstHalf = half == 'A';
                      final String time = timeSlots[i];

                      return SizedBox(
                        height: timeCellHeight,
                        child: Row(
                          children: [
                            Container(
                              width: timeLabelWidth,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                color: Colors.grey.shade100,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (isFirstHalf) ...[
                                    Container(
                                      width: 30,
                                      alignment: Alignment.center,
                                      child: Text('$period교시', style: const TextStyle(fontSize: 10)),
                                    ),
                                    Container(
                                      width: 30,
                                      alignment: Alignment.center,
                                      child: Text('A\n$time', style: const TextStyle(fontSize: 10), textAlign: TextAlign.center),
                                    ),
                                  ] else ...[
                                    SizedBox(width: 30),
                                    Container(
                                      width: 30,
                                      alignment: Alignment.center,
                                      child: Text('B\n$time', style: const TextStyle(fontSize: 10), textAlign: TextAlign.center),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            ...List.generate(days.length, (j) {
                              return Container(
                                width: dayCellWidth,
                                height: timeCellHeight,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),

              Positioned(
                top: 0,
                left: timeLabelWidth,
                child: Row(
                  children: days.map((day) => Container(
                    width: dayCellWidth,
                    height: dayLabelHeight,
                    color: const Color(0xFF7DA7D9),
                    alignment: Alignment.center,
                    child: Text(day, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  )).toList(),
                ),
              ),

              ...lectures.map((lecture) {
                final dayIdx = days.indexOf(lecture['day']);
                final startIdx = timeSlots.indexOf(lecture['start']);
                final endIdx = timeSlots.indexOf(lecture['end']);
                if (dayIdx == -1 || startIdx == -1 || endIdx == -1)
                  return const SizedBox.shrink();

                final blockTop = dayLabelHeight + startIdx * timeCellHeight;
                final blockLeft = timeLabelWidth + dayIdx * dayCellWidth;
                final blockHeight = (endIdx - startIdx) * timeCellHeight;

                Color bgColor = subjectColors[lecture['subject']] ?? subjectColors['기본']!;

                return Positioned(
                  top: blockTop,
                  left: blockLeft,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LectureDetailScreen(lecture: lecture),
                        ),
                      );
                    },
                    child: Container(
                      width: dayCellWidth,
                      height: blockHeight,
                      margin: const EdgeInsets.all(1),
                      padding: const EdgeInsets.all(2),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            lecture['subject'] ?? '',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            lecture['professor'] ?? '',
                            style: const TextStyle(color: Colors.white, fontSize: 9),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
