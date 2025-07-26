import 'package:flutter/material.dart';
import '../service/gemini_service.dart';

class GiftSuggestionPage extends StatefulWidget {
  const GiftSuggestionPage({super.key});

  @override
  State<GiftSuggestionPage> createState() => _GiftSuggestionPageState();
}

class _GiftSuggestionPageState extends State<GiftSuggestionPage> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _hobbiesController = TextEditingController();
  final _budgetController = TextEditingController();
  final _relationController = TextEditingController();

  String _suggestion = '';
  bool _loading = false;

  Future<void> _getSuggestions() async {
    if (!_formKey.currentState!.validate()) return;

    final prompt = """
Bir kişiye hediye önerisi ver:
- Yaş: ${_ageController.text}
- Hobiler: ${_hobbiesController.text}
- Bütçe: ${_budgetController.text} TL
- İlişki türü: ${_relationController.text}

Lütfen 3 öneri ver ve neden önerdiğini açıkla.
""";

    setState(() => _loading = true);

    try {
      final result = await GeminiService.getGiftSuggestions(prompt);
      setState(() => _suggestion = result);
    } catch (e) {
      setState(() => _suggestion = 'Hediye önerisi alınamadı: $e');
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
            const Text("Hediye Bul", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: "Yaş"),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? "Yaş girin" : null,
            ),
            TextFormField(
              controller: _hobbiesController,
              decoration: const InputDecoration(labelText: "Hobiler"),
              validator: (value) => value!.isEmpty ? "Hobiler girin" : null,
            ),
            TextFormField(
              controller: _budgetController,
              decoration: const InputDecoration(labelText: "Bütçe (TL)"),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? "Bütçe girin" : null,
            ),
            TextFormField(
              controller: _relationController,
              decoration: const InputDecoration(labelText: "İlişki türü (arkadaş, sevgili, aile vs.)"),
              validator: (value) => value!.isEmpty ? "İlişki türü girin" : null,
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
            _loading
                ? const CircularProgressIndicator()
                : Text(_suggestion, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
