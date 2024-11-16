import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';

class ChatBotService {
  final String apiKey = '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'; // API Key
  final String apiUrl = 'https://api-inference.huggingface.co/models/Qwen/Qwen2.5-Coder-32B-Instruct/v1/chat/completions';

  final Dio _dio = Dio();

  // Hàm gửi yêu cầu và xử lý stream
  Future<String> getResponse(String prompt) async {
    try {
      String responseContent = ''; // Chuỗi kết quả hoàn chỉnh

      final response = await _dio.post(
        apiUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
          responseType: ResponseType.stream, // Đọc dữ liệu theo kiểu stream
        ),
        data: json.encode({
          "messages": [
            {"role": "user", "content": prompt}
          ],
          "max_tokens": 500,
          "stream": true,
        }),
      );

      // Đọc dữ liệu từ stream và xử lý
      await response.data!.stream
          .cast<List<int>>() // Chuyển stream thành List<int>
          .transform(utf8.decoder) // Giải mã từ byte sang chuỗi
          .transform(LineSplitter()) // Chia thành các dòng
          .forEach((line) {
        print('Received line: $line'); // In ra dòng nhận được để kiểm tra dữ liệu

        if (line.trim().isEmpty) return; // Bỏ qua dòng rỗng

        // Loại bỏ "data: " nếu có
        line = line.replaceFirst('data: ', '');

        try {
          final jsonChunk = jsonDecode(line); // Parse JSON từ mỗi dòng
          final delta = jsonChunk['choices']?[0]?['delta'];
          if (delta != null && delta['content'] != null) {
            responseContent += delta['content']; // Ghép chuỗi trả về
            print('Streaming: $responseContent'); // In ra chuỗi đã ghép
          }
        } catch (e) {
          print('Error parsing chunk: $e'); // Bỏ qua nếu không thể parse chunk
        }
      });

      // Trả về chuỗi hoàn chỉnh sau khi kết thúc stream
      return responseContent.trim();
    } catch (e) {
      print('Error occurred: $e');
      return 'An error occurred. Please try again.';
    }
  }
}
