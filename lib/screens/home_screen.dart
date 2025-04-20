import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart';
import '../data/lecture_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    LectureDataManager.loadLectureData();
  }

  void _handleSearch(String keyword) {
    if (keyword.isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }

    final isRoom = LectureDataManager.getLecturesForRoom(keyword).isNotEmpty;

    if (isRoom) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LectureScheduleScreen(roomName: keyword),
        ),
      );
    } else {
      setState(() {
        _searchResults = LectureDataManager.searchLecturesByKeyword(keyword);
        if (_searchResults.isEmpty) {
          _searchResults = [
            {'subject': '검색 결과 없음', 'roomName': '', 'professor': ''}
          ];
        }
      });
    }
  }

  void _handleSearchTap(Map<String, dynamic> item) {
    if (item['roomName'] != '') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LectureScheduleScreen(roomName: item['roomName']),
        ),
      );
    }
  }

  void _showHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("여기는 본관 / IT융합대학 설명 페이지입니다.")),
    );
  }

  void _moveToCurrentLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("현재 위치 기능은 준비 중입니다.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF004098),
        title: TextField(
          controller: _searchController,
          onChanged: _handleSearch,
          decoration: const InputDecoration(
            hintText: '과목명 / 교수명 / 강의실 검색',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: _showHelp,
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Text(
              '여기는 본관 / IT융합대학 설명 페이지!',
              style: TextStyle(fontSize: 18),
            ),
          ),
          if (_searchResults.isNotEmpty)
            Positioned(
              top: kToolbarHeight,
              left: 16,
              right: 16,
              child: Card(
                elevation: 4,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _searchResults.length.clamp(0, 3),
                  itemBuilder: (context, index) {
                    final result = _searchResults[index];
                    if (result['subject'] == '검색 결과 없음') {
                      return ListTile(
                        title: Text('🔍 ${_searchController.text}에 대한 결과가 없습니다.'),
                      );
                    }
                    return ListTile(
                      title: Text('${result['subject']} (${result['roomName']})'),
                      subtitle: Text('👨‍🏫 ${result['professor']}'),
                      onTap: () => _handleSearchTap(result),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: _moveToCurrentLocation,
            backgroundColor: const Color(0xFF004098),
            child: const Icon(Icons.my_location),
          ),
        ),
      ),
    );
  }
}
