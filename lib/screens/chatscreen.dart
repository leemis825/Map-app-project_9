import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key}); // ✅ 생성자 수정
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> messages = [];
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      messages.add({'user': text});
    });

    final response = getBotResponse(text);

    setState(() {
      messages.add({'bot': response});
    });

    controller.clear();

    // 자동 스크롤
    Future.delayed(Duration(milliseconds: 100), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  String getBotResponse(String input) {
    input = input.toLowerCase();
    if (input.contains("엘리베이터")) return "엘리베이터는 각 층 중앙 복도 근처에 있어요.";
    if (input.contains("1층") && input.contains("강의실")) return "1층에는 1101, 1102 강의실이 있어요.";
    return "죄송해요, 아직 그건 잘 몰라요.";
  }

  Widget _buildKeywordChip(String keyword) {
    return ActionChip(
      label: Text(keyword),
      onPressed: () => sendMessage(keyword),
      backgroundColor: Colors.blue.shade100,
      labelStyle: TextStyle(color: Colors.black),
      elevation: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '키워드봇',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF004098),
        centerTitle: true,
      ),
      body: Column(
        children: [
          //초기 키워드
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _buildKeywordChip("엘리베이터 위치"),
                _buildKeywordChip("1층 강의실"),
                _buildKeywordChip("시설 소개")
              ],
            ),
          ),

          // 채팅 메시지 영역
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg.containsKey('user');
                final text = msg.values.first ?? '';

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[200] : Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomLeft: isUser ? Radius.circular(16) : Radius.circular(0),
                        bottomRight: isUser ? Radius.circular(0) : Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      text,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),

          // 입력창
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 4),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: '메시지를 입력하세요',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => sendMessage(controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
