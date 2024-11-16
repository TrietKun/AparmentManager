import 'package:apartment_manager_user/services/chatbot_service.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ChatBotService _chatBotService = ChatBotService();

  // Hàm gửi tin nhắn
  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      // Thêm tin nhắn của người dùng vào danh sách
      setState(() {
        _messages.add({'sender': 'user', 'message': _controller.text});
      });

      // Gửi yêu cầu tới OpenAI và nhận phản hồi
      String aiResponse = await _chatBotService.getResponse(_controller.text);

      // Thêm phản hồi của AI vào danh sách
      setState(() {
        _messages.add({'sender': 'ai', 'message': aiResponse});
      });

      // Xóa nội dung TextField
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
 
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: _messages[index]['sender'] == 'user'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: _messages[index]['sender'] == 'user'
                          ? Colors.blue
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      _messages[index]['message']!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
