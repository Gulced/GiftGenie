
class GiftSuggestion {
  final String link;
  final String imageUrl;
  final String description;

  GiftSuggestion({
    required this.link,
    required this.imageUrl,
    required this.description,
  });
}

// Basit satır-parçalama ile parse fonksiyonu:
List<GiftSuggestion> parseGiftSuggestions(String response) {
  final regex = RegExp(
      r'\d+\.\s*Ürün linki:\s*(.*?)\s*Fotoğraf:\s*(.*?)\s*Açıklama:\s*(.*?)(?=\n\d+\.|$)',
      dotAll: true);
  final matches = regex.allMatches(response);

  return matches.map((match) {
    return GiftSuggestion(
      link: match.group(1)?.trim() ?? '',
      imageUrl: match.group(2)?.trim() ?? '',
      description: match.group(3)?.trim() ?? '',
    );
  }).toList();
}