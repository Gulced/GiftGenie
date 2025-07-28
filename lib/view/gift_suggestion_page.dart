import 'package:flutter/material.dart';
import '../service/gemini_service.dart';
import '../service/prompt_builder.dart';
import '../models/gift_suggestion.dart';
import '../utils/gift_utils.dart';

class GiftSuggestionPage extends StatefulWidget {
  const GiftSuggestionPage({super.key});

  @override
  State<GiftSuggestionPage> createState() => _GiftSuggestionPageState();
}

class _GiftSuggestionPageState extends State<GiftSuggestionPage> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _relationController = TextEditingController();
  final _hobbiesController = TextEditingController();
  final _personalityController = TextEditingController();
  final _budgetMinController = TextEditingController();
  final _budgetMaxController = TextEditingController();
  final _suggestionCountController = TextEditingController(text: "3");

  String _suggestion = '';
  bool _loading = false;
  List<GiftSuggestion> _giftSuggestions = [];

  Future<void> _getSuggestions() async {
    if (!_formKey.currentState!.validate()) return;

    final yas = int.tryParse(_ageController.text) ?? 0;
    final cinsiyet = _genderController.text.trim();
    final iliski = _relationController.text.trim();
    final hobiler =
    _hobbiesController.text.split(',').map((e) => e.trim()).toList();
    final kisilik = _personalityController.text.trim();
    final minButce = int.tryParse(_budgetMinController.text) ?? 0;
    final maxButce = int.tryParse(_budgetMaxController.text) ?? 0;
    final onerilenSayi = int.tryParse(_suggestionCountController.text) ?? 3;

    final prompt = buildGiftPrompt(
      yas: yas,
      cinsiyet: cinsiyet,
      iliski: iliski,
      hobiler: hobiler,
      kisilik: kisilik,
      minButce: minButce,
      maxButce: maxButce,
      onerilenSayi: onerilenSayi,
    );

    setState(() {
      _loading = true;
      _suggestion = '';
      _giftSuggestions = [];
    });

    try {
      final result = await GeminiService.getGiftSuggestions(prompt);
      final suggestions = parseGiftSuggestions(result);
      setState(() {
        _suggestion = result;
        _giftSuggestions = suggestions;
      });
    } catch (e) {
      setState(() {
        _suggestion = 'Hediye önerisi alınamadı: $e';
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text("Hediye Bul",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: "Yaş"),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? "Yaş girin" : null,
            ),
            TextFormField(
              controller: _genderController,
              decoration: const InputDecoration(labelText: "Cinsiyet"),
              validator: (value) => value!.isEmpty ? "Cinsiyet girin" : null,
            ),
            TextFormField(
              controller: _relationController,
              decoration: const InputDecoration(
                  labelText: "İlişki türü (arkadaş, sevgili, aile vs.)"),
              validator: (value) => value!.isEmpty ? "İlişki türü girin" : null,
            ),
            TextFormField(
              controller: _hobbiesController,
              decoration:
              const InputDecoration(labelText: "Hobiler (virgülle ayır)"),
              validator: (value) => value!.isEmpty ? "Hobiler girin" : null,
            ),
            TextFormField(
              controller: _personalityController,
              decoration: const InputDecoration(labelText: "Kişilik tipi"),
              validator: (value) =>
              value!.isEmpty ? "Kişilik tipi girin" : null,
            ),
            TextFormField(
              controller: _budgetMinController,
              decoration:
              const InputDecoration(labelText: "Minimum Bütçe (TL)"),
              keyboardType: TextInputType.number,
              validator: (value) =>
              value!.isEmpty ? "Minimum bütçe girin" : null,
            ),
            TextFormField(
              controller: _budgetMaxController,
              decoration:
              const InputDecoration(labelText: "Maksimum Bütçe (TL)"),
              keyboardType: TextInputType.number,
              validator: (value) =>
              value!.isEmpty ? "Maksimum bütçe girin" : null,
            ),
            TextFormField(
              controller: _suggestionCountController,
              decoration:
              const InputDecoration(labelText: "Kaç öneri istiyorsun?"),
              keyboardType: TextInputType.number,
              validator: (value) =>
              value!.isEmpty ? "Öneri sayısı girin" : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _getSuggestions,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9D6EF7),
              ),
              child: const Text("Hediye Öner"),
            ),
            const SizedBox(height: 20),
            if (_loading)
              const CircularProgressIndicator()
            else if (_giftSuggestions.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _giftSuggestions.map((gift) {
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Image.network(
                        gift.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported),
                      ),
                      title: Text(gift.description),
                      subtitle: Text(gift.link),
                    ),
                  );
                }).toList(),
              )
            else
              SelectableText(_suggestion, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
