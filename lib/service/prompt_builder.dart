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
Aşağıdaki bilgilere göre Türk e-ticaret sitelerinden alınabilecek hediye önerileri ver:

- Yaş: $yas
- Cinsiyet: $cinsiyet
- İlişki türü: $iliski
- Hobiler / İlgi alanları: ${hobiler.join(", ")}
- Kişilik tipi: $kisilik
- Bütçe aralığı: $minButce - $maxButce TL

Toplam $onerilenSayi adet öneri yap. Her bir öneriyi aşağıdaki formatta sırala ve **yalnızca bu formatı kullan** (başka hiçbir şey ekleme):

**Ürün Adı**
Fiyat: ... TL  
Link: https://...  
Görsel: https://...  
Açıklama: ...

---
""";
}
