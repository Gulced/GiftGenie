class GiftSuggestion {
  final String title;
  final String description;
  final String link;
  final String imageUrl;
  final String price; // ✅ Bunu ekle

  GiftSuggestion({
    required this.title,
    required this.description,
    required this.link,
    required this.imageUrl,
    required this.price, // ✅ Bunu da ekle
  });

  factory GiftSuggestion.fromJson(Map<String, dynamic> json) {
    return GiftSuggestion(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      link: json['link'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: json['price'] ?? '', // ✅ burada da varsa ekle
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'link': link,
      'imageUrl': imageUrl,
      'price': price, // ✅ buraya da
    };
  }
}
