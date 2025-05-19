import 'package:flutter/material.dart';
import '../data/lecture_data.dart';
import '../widgets/search_bar_with_results.dart';
import 'lecture_detail_screen.dart';

class LectureScheduleScreen extends StatefulWidget {
  final String roomName = '0';
  const LectureScheduleScreen({required roomName, super.key});

  @override
  State<LectureScheduleScreen> createState() => _LectureScheduleScreenState();
}

class _LectureScheduleScreenState extends State<LectureScheduleScreen> {
  late String currentRoomName;

  final List<String> days = ['월', '화', '수', '목', '금'];
  final List<String> timePeriods = [
    '08:00',
    '08:30',
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '12:30',
    '13:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00',
    '17:30',
    '18:00',
    '18:30',
    '19:00',
    '19:30',
  ];

  final Map<String, Color> subjectColors = {};
  final List<Color> colorPool = [
    const Color(0xFF7DA7D9),
    const Color(0xFF0054A7),
    const Color.fromARGB(255, 48, 62, 133),
    Colors.blue.shade300,
    const Color.fromARGB(255, 46, 87, 162),
    const Color.fromARGB(255, 57, 178, 233),
    const Color.fromARGB(255, 107, 151, 227),
  ];

  Color getSubjectColor(String subject) {
    if (!subjectColors.containsKey(subject)) {
      final color = colorPool[subjectColors.length % colorPool.length];
      subjectColors[subject] = color;
    }
    return subjectColors[subject]!;
  }

  @override
  void initState() {
    super.initState();
    currentRoomName = widget.roomName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0054A7),
        title: Text(
          '내 시간표',
          style: const TextStyle(color: Colors.white), // ✅ 글씨 흰색
        ),
      ),
    );
  }

  Widget _buildCustomTimeTable() {
    final lectures = LectureDataManager.getLecturesForRoom(currentRoomName);
    final rendered = <String>{};

    const double colWidth = 60;
    const double dayWidth = 70;
    const double rowHeight = 40;
    const double headerHeight = 30;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: colWidth * 3 + dayWidth * days.length,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      _buildHeaderCell('교시', colWidth),
                      _buildHeaderCell('A/B', colWidth),
                      _buildHeaderCell('시간', colWidth),
                      ...days.map(
                        (day) => Container(
                          width: dayWidth,
                          height: headerHeight,
                          alignment: Alignment.center,
                          color: const Color.fromARGB(255, 131, 153, 180),
                          child: Text(
                            day,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...List.generate(timePeriods.length, (i) {
                    final isA = i % 2 == 0;
                    final period = i ~/ 2;
                    return SizedBox(
                      height: rowHeight,
                      child: Row(
                        children: [
                          Container(
                            width: colWidth,
                            height: rowHeight,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              color:
                                  isA
                                      ? Colors.grey.shade100
                                      : Colors.grey.shade200,
                            ),
                            child:
                                isA
                                    ? Text(
                                      '$period교시',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    )
                                    : const SizedBox.shrink(),
                          ),
                          Container(
                            width: colWidth,
                            height: rowHeight,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              color: Colors.white,
                            ),
                            child: Text(
                              isA ? 'A' : 'B',
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                          Container(
                            width: colWidth,
                            height: rowHeight,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              color: Colors.white,
                            ),
                            child: Text(
                              timePeriods[i],
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                          ...List.generate(days.length, (j) {
                            return Container(
                              width: dayWidth,
                              height: rowHeight,
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
              ...lectures.map((lecture) {
                final dayIdx = days.indexOf(lecture['day']);
                final start = lecture['start'] ?? '';
                final end = lecture['end'] ?? '';
                final startIdx = timePeriods.indexWhere(
                  (p) => p.startsWith(start.padLeft(5, '0')),
                );
                final endIdx = timePeriods.indexWhere(
                  (p) => p.startsWith(end.padLeft(5, '0')),
                );

                if (dayIdx == -1 || startIdx == -1 || endIdx == -1)
                  return const SizedBox.shrink();

                final top = headerHeight + startIdx * rowHeight;
                final left = colWidth * 3 + dayIdx * dayWidth;
                final height = (endIdx - startIdx) * rowHeight;

                final key =
                    '${lecture['subject']}_${lecture['professor']}_${lecture['day']}_${lecture['start']}';
                if (rendered.contains(key)) return const SizedBox.shrink();
                rendered.add(key);

                final subject = lecture['subject'] ?? '기본';
                final bgColor = getSubjectColor(subject);
                final textColor = Colors.white;
                //ThemeData.estimateBrightnessForColor(bgColor) ==
                //Brightness.dark ? Colors.white : Colors.black;

                return Positioned(
                  top: top,
                  left: left,
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
                      width: dayWidth,
                      height: height,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 1,
                      ),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            subject,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            lecture['professor'] ?? '',
                            style: TextStyle(color: textColor, fontSize: 9),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text, double width) {
    return Container(
      width: width,
      height: 30,
      alignment: Alignment.center,
      color: const Color.fromARGB(255, 131, 153, 180),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}
