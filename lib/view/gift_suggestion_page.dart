import 'package:flutter/material.dart';
import '../service/gemini_service.dart';

class GiftSuggestionPage extends StatefulWidget {
  const GiftSuggestionPage({super.key});

  @override
  State<GiftSuggestionPage> createState() => _GiftSuggestionPageState();
}

class _GiftSuggestionPageState extends State<GiftSuggestionPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _hobbiesController = TextEditingController();
  final _budgetController = TextEditingController();
  final _relationController = TextEditingController();
  final _personalityController = TextEditingController();

  String _suggestion = '';
  bool _loading = false;

  Future<void> _getSuggestions() async {
    if (!_formKey.currentState!.validate()) return;

    final prompt = """
Bir kişiye hediye önerisi ver:
- İsim: ${_nameController.text}
- Yaş: ${_ageController.text}
- Cinsiyet: ${_genderController.text}
- Kişilik özellikleri: ${_personalityController.text}
- Hobiler: ${_hobbiesController.text}
- Bütçe: ${_budgetController.text} TL
- İlişki türü: ${_relationController.text}

Lütfen 3 öneri ver. Her biri için:
- Hediye açıklaması
- Neden uygun olduğu
- Uygun ürün linki (örnek: trendyol.com veya amazon.com.tr)
- Fotoğraf linki
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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF9D6EF7)),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF9D6EF7)),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF9D6EF7), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8ECFF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Hediye Bul",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration("İsim"),
                validator: (value) => value!.isEmpty ? "İsim girin" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _ageController,
                decoration: _inputDecoration("Yaş"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Yaş girin" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _genderController,
                decoration: _inputDecoration("Cinsiyet"),
                validator: (value) => value!.isEmpty ? "Cinsiyet girin" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _personalityController,
                decoration: _inputDecoration("Kişilik özellikleri"),
                validator: (value) => value!.isEmpty ? "Kişilik tipi girin" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _hobbiesController,
                decoration: _inputDecoration("Hobiler"),
                validator: (value) => value!.isEmpty ? "Hobiler girin" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _budgetController,
                decoration: _inputDecoration("Bütçe (TL)"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Bütçe girin" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _relationController,
                decoration: _inputDecoration("İlişki türü (arkadaş, sevgili, aile vs.)"),
                validator: (value) => value!.isEmpty ? "İlişki türü girin" : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _loading ? null : _getSuggestions,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9D6EF7),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Hediye Öner",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              if (_loading)
                const Center(child: CircularProgressIndicator())
              else if (_suggestion.isNotEmpty)
                Text(
                  _suggestion,
                  style: const TextStyle(fontSize: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
