import 'package:flutter/material.dart';
import '../data/lecture_data.dart';

class SearchBarWithResults extends StatefulWidget {
  final String initialText; // 🔸 검색창에 기본으로 표시될 텍스트 (초기 강의실 이름 등)
  final Function(String) onRoomSelected; // 🔸 검색어를 선택했을 때 실행되는 콜백 함수

  const SearchBarWithResults({
    required this.initialText,
    required this.onRoomSelected,
    super.key,
  });

  @override
  State<SearchBarWithResults> createState() => _SearchBarWithResultsState();
}

class _SearchBarWithResultsState extends State<SearchBarWithResults> {
  late TextEditingController _controller; // 🔸 검색어 입력 컨트롤러
  final FocusNode _focusNode = FocusNode(); // 🔸 포커스 감지용
  List<Map<String, dynamic>> suggestions = []; // 🔸 자동완성 추천 결과 저장 리스트

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialText,
    ); // 🔹 초기 검색어 세팅

    _focusNode.addListener(() {
      // 🔹 검색창이 포커스를 잃었을 때 자동완성 결과 제거
      if (!_focusNode.hasFocus) {
        setState(() {
          suggestions.clear();
        });
      }
    });
  }

  // 🔍 사용자가 입력하거나 제출했을 때 실행되는 검색 처리 함수
  void _handleSearch(String keyword) {
    keyword = keyword.trim();

    if (keyword.isEmpty) {
      setState(() {
        suggestions.clear();
      });
      return;
    }

    final results =
        LectureDataManager.getAllLectures().where((lecture) {
          // 🔸 각 필드를 소문자로 비교
          final subject = lecture['subject']?.toLowerCase() ?? '';
          final professor = lecture['professor']?.toLowerCase() ?? '';
          final room = lecture['roomName']?.toLowerCase() ?? '';
          final kw = keyword.toLowerCase();
          return subject.contains(kw) ||
              professor.contains(kw) ||
              room.contains(kw);
        }).toList();

    setState(() {
      suggestions =
          results.isEmpty
              ? [
                {'subject': '검색 결과 없음', 'roomName': '', 'professor': ''},
              ]
              : results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // 노치 영역 대응
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                // 햄버거 메뉴 버튼
                Builder(
                  builder:
                      (context) => IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                ),
                // 검색창 클릭 시 다이얼로그 열기
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: _handleSearch,
                    onSubmitted: _handleSearch,
                    decoration: InputDecoration(
                      hintText: '강의명 또는 강의실을 입력하세요',
                      hintStyle: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        color: Color.fromARGB(255, 93, 92, 92),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 238, 238, 238),
                      prefixIcon: const Icon(Icons.search, color: Colors.black),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                // 도움말 버튼
                IconButton(
                  icon: const Icon(Icons.error_outline), // 느낌표 비슷한 아이콘
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("자주 묻는 질문을 확인하세요!")),
                    );
                  },
                ),
              ],
            ),
          ),
          // 검색 결과 리스트
          if (suggestions.isNotEmpty)
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: suggestions.length,
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
                      widget.onRoomSelected(item['roomName']);
                      _controller.text = item['roomName'];
                      setState(() {
                        suggestions.clear();
                      });
                      FocusScope.of(context).unfocus();
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
