import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gift_suggestion.dart'; // Sınıfın olduğu yere göre yolu ayarla

class GeminiService {
  static const String _apiKey = 'AIzaSyCJq08OqlxpNuGVHuunJ4NmSxBxUoEnzuM';
  static const String _url =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey';

  static Future<List<GiftSuggestion>> getGiftSuggestions(String prompt) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt},
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"];
      if (text != null) {
        return _parseGiftSuggestions(text);
      } else {
        throw Exception('Gemini API yanıtı beklenen formatta değil.');
      }
    } else {
      throw Exception(
        'Gemini API hatası: ${response.statusCode}\n${response.body}',
      );
    }
  }

  static List<GiftSuggestion> _parseGiftSuggestions(String responseText) {
    final lines = LineSplitter.split(responseText).toList();
    List<GiftSuggestion> suggestions = [];

    for (var i = 0; i < lines.length; i++) {
      if (lines[i].trim().startsWith("**")) {
        try {
          final titleLine = lines[i].trim();
          final title = titleLine.replaceAll("**", "").trim();

          final priceLine = lines[i + 1].trim();
          final price = priceLine.replaceFirst("Fiyat:", "").trim();

          final linkLine = lines[i + 2].trim();
          final link = linkLine.replaceFirst("Link:", "").trim();

          final imageUrlLine = lines[i + 3].trim();
          final imageUrl = imageUrlLine.replaceFirst("Görsel:", "").trim();

          final descLine = lines[i + 4].trim();
          final description = descLine.replaceFirst("Açıklama:", "").trim();

          suggestions.add(
            GiftSuggestion(
              title: title,
              price: price,
              link: link,
              imageUrl: imageUrl,
              description: description,
            ),
          );
        } catch (e) {
          // Hatalı format varsa atla
          continue;
        }
      }
    }

    return suggestions;
  }
}
