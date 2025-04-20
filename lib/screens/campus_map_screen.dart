import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart';
import '../data/lecture_data.dart';
import 'home_screen.dart';
import 'menu.dart';

class CampusMapScreen extends StatefulWidget {
  @override
  _CampusMapScreenState createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    LectureDataManager.loadLectureData(); // ✅ 데이터 로드
  }

  void _handleSearch(String keyword) {
    keyword = keyword.trim();
    if (LectureDataManager.getLecturesForRoom(keyword).isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LectureScheduleScreen(roomName: keyword)),
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
    if (item['subject'] == '검색 결과 없음') return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LectureScheduleScreen(roomName: item['roomName'])),
    );
  }

  void showHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("자주 묻는 질문을 확인하세요!")),
    );
  }

  void moveToCurrentLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("현재 위치로 이동 중입니다.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF004098),
        title: TextField(
          controller: _searchController,
          onChanged: _handleSearch,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "🔍 강의명, 교수명, 강의실 검색",
            hintStyle: TextStyle(color: Colors.white60),
            border: InputBorder.none,
          ),
          cursorColor: Colors.white, // 깜빡이는 커서
        ),
        actions: [
          IconButton(icon: const Icon(Icons.help_outline), onPressed: showHelp),
        ],
      ),
      body: Stack(
        children: [
          // 캠퍼스 지도
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/campus_map.png',
                  width: 1500,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height,
                ),
                Positioned(
                  left: 440,
                  top: 100,
                  child: campusButton(context, '본관 중앙', const HomeScreen()),
                ),
                Positioned(
                  left: 800,
                  top: 100,
                  child: campusButton(context, 'IT융합대학', MenuScreen()),
                ),
              ],
            ),
          ),

          // 🔍 추천 검색 결과
          if (_searchResults.isNotEmpty)
            Positioned(
              top: 60,
              left: 16,
              right: 16,
              child: Card(
                elevation: 4,
                color: Colors.white,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _searchResults.length.clamp(0, 3),
                  itemBuilder: (context, index) {
                    final item = _searchResults[index];
                    if (item['subject'] == '검색 결과 없음') {
                      return ListTile(
                        title: Text('🔍 ${_searchController.text}에 대한 결과가 없습니다.'),
                      );
                    }
                    return ListTile(
                      title: Text('📘 ${item['subject']} - ${item['professor']}'),
                      subtitle: Text('🏫 ${item['roomName']}호, ${item['day']} ${item['start']}~${item['end']}'),
                      onTap: () => _handleSearchTap(item),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: moveToCurrentLocation,
        child: const Icon(Icons.my_location),
        backgroundColor: const Color(0xFF004098),
      ),
    );
  }

  Widget campusButton(BuildContext context, String label, Widget destination) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF004098),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
