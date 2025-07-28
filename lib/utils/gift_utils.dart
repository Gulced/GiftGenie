import '../models/gift_suggestion.dart';

List<GiftSuggestion> parseGiftSuggestions(String response) {
  final regex = RegExp(
    r'Ürün Linki:\s*\[([^\]]+)\]\s*Fotoğraf Adresi:\s*\[([^\]]+)\]\s*Açıklama:\s*(.+)',
    multiLine: true,
  );

  final matches = regex.allMatches(response);
  return matches.map((match) {
    return GiftSuggestion(
      link: match.group(1)?.trim() ?? '',
      imageUrl: match.group(2)?.trim() ?? '',
      description: match.group(3)?.trim() ?? '',
    );
  }).toList();
}

String buildGiftPrompt({
  required int yas,
  required String cinsiyet,
  required String iliski,
  required List<String> hobiler,
  required String kisilik,
  required int minButce,
  required int maxButce,
  required int onerilenSayi,
}) {
  return """
Kullanıcıdan alınan bilgiler:
•⁠  ⁠Yaş: $yas
•⁠  ⁠Cinsiyet: $cinsiyet
•⁠  ⁠İlişki türü: $iliski
•⁠  ⁠Hobiler / ilgi alanları: ${hobiler.join(", ")}
•⁠  ⁠Kişilik tipi: $kisilik
•⁠  ⁠Bütçe aralığı: $minButce-$maxButce TL

Yukarıdaki özelliklere uygun $onerilenSayi hediye öner. Her öneri için:
•⁠  ⁠1 tane ürün linki ver (örnek: trendyol.com veya amazon.com.tr linki),
•⁠  ⁠O linkteki ürünün fotoğraf adresini ver,
•⁠  ⁠O ürün için kısa bir açıklama yaz.
Her öneriyi aşağıdaki formatta ve tüm başlıkları kullanarak listele (başka hiçbir açıklama ekleme):

*   *Hediye Önerisi 1:*
    *   Ürün Linki: [ürün_linki]
    *   Fotoğraf Adresi: [fotoğraf_linki]
    *   Açıklama: kısa açıklama
*   *Hediye Önerisi 2:*
    *   Ürün Linki: [ürün_linki]
    *   Fotoğraf Adresi: [fotoğraf_linki]
    *   Açıklama: kısa açıklama
... ve devamı
""";
}
