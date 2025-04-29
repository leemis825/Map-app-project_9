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
    _controller = TextEditingController(text: widget.initialText); // 🔹 초기 검색어 세팅

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

    final results = LectureDataManager.getAllLectures().where((lecture) {
      // 🔸 각 필드를 소문자로 비교
      final subject = lecture['subject']?.toLowerCase() ?? '';
      final professor = lecture['professor']?.toLowerCase() ?? '';
      final room = lecture['roomName']?.toLowerCase() ?? '';
      final kw = keyword.toLowerCase();
      return subject.contains(kw) || professor.contains(kw) || room.contains(kw);
    }).toList();

    setState(() {
      suggestions = results.isEmpty
          ? [{'subject': '검색 결과 없음', 'roomName': '', 'professor': ''}]
          : results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(), // 🔹 배경 터치 시 키보드 & 검색 결과 닫기
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: const InputDecoration(
                hintText: '강의실, 강의명, 교수명 검색',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _handleSearch,  // 🔍 입력 도중 자동검색
              onSubmitted: _handleSearch, // 🔍 엔터 입력 시 검색 실행
            ),
          ),
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

                  // ✅ 사용자가 검색 결과를 선택했을 때 실행되는 부분
                  return ListTile(
                    title: Text('📘 ${item['subject']} (${item['roomName']})'),
                    subtitle: Text('👨‍🏫 ${item['professor']}'),
                    onTap: () {
                      widget.onRoomSelected(item['roomName']); // 🔥 외부로 강의실 번호 전달 (여기까진 정상)
                      _controller.text = item['roomName']; // 🔹 텍스트필드도 해당 강의실 번호로 덮어쓰기
                      setState(() {
                        suggestions.clear(); // 🔹 추천 목록 제거
                      });
                      FocusScope.of(context).unfocus(); // 🔹 키보드 닫기
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
