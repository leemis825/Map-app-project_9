import 'package:flutter/material.dart';
import 'campus_map_screen.dart';

final Map<String, Map<String, String>> keywordBotData = {
  '캠퍼스': {
    '중앙도서관': '중앙도서관은 평일 7시부터 24시까지 운영되며, 시험 기간엔 연장 개방돼요. 열람실 예약은 도서관 어플에서 가능해요!',
    '캠퍼스 지도': '조선대학교 캠퍼스 전체 지도가 궁금하신가요? 주요 건물과 위치를 한눈에 확인할 수 있어요. [지도 보기] 버튼을 눌러주세요!',
    '식당': '오늘 학식 뭐 나올까 궁금하시죠? 학생회관 1층 식당과 공대 식당이 인기가 많아요. 식단표는 조선대 홈페이지 또는 앱에서 확인할 수 있어요!',
  },
  'IT융합대학': {
    '휴게 공간': '2층과 4층, 5층에 휴게 공간이 있어요. 소파랑 콘센트도 있어서 쉬거나 과제하기 좋아요!',
    '프린터': '공용 프린터는 1층, 2층, 5층에 구비되어 있답니다. 사용법도 간단하니 유용하실 거예요!',
    'space실': 'IT융합대학에는 여러 개의 space실이 있어요. 궁금하시다면 실내 지도의 민트색으로 되어 있는 부분을 클릭해주세요!',
    '강의 여부': '저희 앱은 강의 여부를 캠퍼스 실내 지도에서 쉽게 볼 수 있어요. 빨간색 점과 회색 점이 해당 강의실의 강의 여부를 알려 준답니다.',
    '강의실': 'IT융합대학에는 1~10층까지 다양한 강의실이 있어요. 강의실 위치나 시간표가 궁금하시면 층을 선택해 주세요!',
  },
};


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> messages = [];
  String? selectedCategory;

  final ScrollController _scrollController = ScrollController();
  bool isMapKeywordSelected = false;

  void sendMessage(String text) {
    setState(() {
      messages.add({'user': text});
      messages.add({'bot': getBotResponse(text)});
      isMapKeywordSelected = text == '캠퍼스 지도';
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _resetChat() {
    setState(() {
      messages.clear();
      selectedCategory = null;
      isMapKeywordSelected = false;
    });
  }

  String getBotResponse(String input) {
    for (var category in keywordBotData.entries) {
      if (category.value.containsKey(input)) {
        return category.value[input]!;
      }
    }
    return "죄송해요, 아직 그건 잘 몰라요.";
  }

  Widget _buildCategoryButton(String category) {
    return ElevatedButton(
      onPressed: () => setState(() {
        selectedCategory = category;
      }),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[200],
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(category),
    );
  }

  Widget _buildKeywordButton(String keyword) {
    return ActionChip(
      label: Text(keyword),
      onPressed: () => sendMessage(keyword),
      backgroundColor: Colors.blue.shade100,
      labelStyle: const TextStyle(color: Colors.black),
      elevation: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('키워드봇', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF004098),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: '초기화',
            onPressed: _resetChat,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: selectedCategory == null
                ? Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children:
              keywordBotData.keys.map(_buildCategoryButton).toList(),
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '➤ ${selectedCategory!} 관련 키워드를 선택하세요:',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: keywordBotData[selectedCategory!]!
                      .keys
                      .map(_buildKeywordButton)
                      .toList(),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    selectedCategory = null;
                    isMapKeywordSelected = false;
                  }),
                  child: const Text('← 처음으로 돌아가기'),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg.containsKey('user');
                final text = msg.values.first ?? '';

                return Align(
                  alignment:
                  isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color:
                      isUser ? Colors.blue[200] : Colors.grey.shade300,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft:
                        isUser ? const Radius.circular(16) : Radius.zero,
                        bottomRight:
                        isUser ? Radius.zero : const Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),

          if (isMapKeywordSelected)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CampusMapScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('지도 가기'),
              ),
            ),
        ],
      ),
    );
  }
}
