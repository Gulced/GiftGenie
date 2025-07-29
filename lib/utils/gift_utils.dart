import '../models/gift_suggestion.dart';

List<GiftSuggestion> parseGiftSuggestions(String response) {
  final regex = RegExp(
    r'\d+\.\s*Ürün adı:\s*(.*?)\s*\|\s*Kısa açıklama:\s*(.*?)\s*\|\s*Link:\s*(.*?)\s*\|\s*Görsel:\s*(.*?)\s*\|\s*Açıklama:\s*(.*)',
    caseSensitive: false,
  );

  return regex.allMatches(response).map((match) {
    return GiftSuggestion(
      title: match.group(1)?.trim() ?? '',
      description: match.group(2)?.trim() ?? '',
      link: match.group(3)?.trim() ?? '',
      imageUrl: match.group(4)?.trim() ?? '',
    );
  }).toList();
}
