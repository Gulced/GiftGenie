import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class SerpApiService {
  static const String _apiKey =
      'bf0e75936d0582acd5803b88eafa5d0cca5e9bb6290289ec191a8d31992e80ac';

  static const List<String> turkishSites = [
    'trendyol',
    'hepsiburada',
    'n11',
    'vatan',
    'teknosa',
    'migros',
    'a101',
  ];

  static List<Product> filterProductsByPriceAndBrand(
      List<dynamic> items,
      int minTL,
      int maxTL,
      String description,
      String query,
      ) {
    List<Product> products = [];

    for (var item in items) {
      final rawPrice = item['price']?.toString() ?? '';
      final rawLink = item['link']?.toString().toLowerCase() ?? '';

      if (rawPrice.contains('TL') || rawPrice.contains('₺')) {
        final numericPrice = double.tryParse(
          rawPrice
              .replaceAll(RegExp(r'[^\d,\.]'), '')
              .replaceAll('.', '')
              .replaceAll(',', '.')
              .trim(),
        ) ??
            0;

        final isValidPrice = (minTL == 0 || numericPrice >= minTL) &&
            (maxTL == 0 || numericPrice <= maxTL);

        if (isValidPrice) {
          products.add(
            Product(
              title: item['title'] ?? query,
              price: rawPrice.replaceAll('₺', 'TL').replaceAll('TRY', 'TL'),
              link: item['link'] ?? '',
              imageUrl: item['thumbnail'] ?? '',
              description: description,
            ),
          );
        }
      }
    }

    final turkish = products.where(
          (p) => turkishSites.any((site) => p.link.toLowerCase().contains(site)),
    );

    return turkish.isNotEmpty ? turkish.toList() : products;
  }

  static Future<Product?> searchFirstProduct(
      String query,
      String description, {
        int? minTL,
        int? maxTL,
      }) async {
    try {
      String searchQuery = query;
      if (minTL != null && maxTL != null && minTL > 0 && maxTL > minTL) {
        searchQuery += ' $minTL TL - $maxTL TL';
      }

      final url =
          'https://serpapi.com/search.json?q=${Uri.encodeComponent(searchQuery)}'
          '&tbm=shop'
          '&hl=tr'
          '&gl=tr'
          '&location=Turkey'
          '&api_key=$_apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      final items = data['shopping_results'] as List<dynamic>?;

      if (items == null || items.isEmpty) return null;

      final filtered = filterProductsByPriceAndBrand(
        items,
        minTL ?? 0,
        maxTL ?? 0,
        description,
        query,
      );

      if (filtered.isNotEmpty) return filtered.first;

      // Filtreye uyan ürün yoksa ilkini geri döndür
      final fallback = items.first;
      return Product(
        title: fallback['title'] ?? query,
        price: 'Fiyat belirtilmemiş',
        link: fallback['link'] ?? '',
        imageUrl: fallback['thumbnail'] ?? '',
        description: description,
      );
    } catch (e) {
      print('Serp API hata: $e');
      return null;
    }
  }
}
