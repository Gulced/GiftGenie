import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String apiKey = 'AIzaSyDacDmPTb-O6cP_2XEQSgpTE51Vm8Px48w';

  static const String url =
      'https://generativelanguage.googleapis.com/v1beta2/models/chat-bison-001:generateMessage?key=$apiKey';

  static Future<String> getGiftSuggestions(String prompt) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "prompt": {
          "messages": [
            {"author": "user", "content": prompt}
          ]
        },
        "temperature": 0.7,
        "candidateCount": 1
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content'];
    } else {
      throw Exception(
        'Gemini API hatası: ${response.statusCode}\n${response.body}',
      );
    }
  }
}
