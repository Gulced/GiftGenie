import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:swipe_cards/swipe_cards.dart';
import '../service/gemini_service.dart';
import '../service/prompt_builder.dart';
import '../models/gift_suggestion.dart';

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

  bool _loading = false;
  String _rawGeminiOutput = '';
  List<SwipeItem> _swipeItems = [];
  late MatchEngine _matchEngine;

  Future<void> _getSuggestions() async {
    if (!_formKey.currentState!.validate()) return;

    final prompt = buildGiftPrompt(
      yas: int.tryParse(_ageController.text) ?? 0,
      cinsiyet: _genderController.text.trim(),
      iliski: _relationController.text.trim(),
      hobiler: _hobbiesController.text.split(',').map((e) => e.trim()).toList(),
      kisilik: _personalityController.text.trim(),
      minButce: int.tryParse(_budgetMinController.text) ?? 0,
      maxButce: int.tryParse(_budgetMaxController.text) ?? 0,
      onerilenSayi: int.tryParse(_suggestionCountController.text) ?? 3,
    );

    setState(() {
      _loading = true;
      _rawGeminiOutput = '';
      _swipeItems.clear();
    });

    try {
      final suggestions = await GeminiService.getGiftSuggestions(prompt);
      _swipeItems = suggestions
          .map((gift) => SwipeItem(
        content: gift,
        likeAction: () {
          // Favoriye eklenecekse buraya işlem yaz
        },
      ))
          .toList();

      _matchEngine = MatchEngine(swipeItems: _swipeItems);

      setState(() {
        _rawGeminiOutput = 'Hediye önerileri alındı.';
      });
    } catch (e) {
      setState(() {
        _rawGeminiOutput = 'Hata: $e';
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  Widget _buildSwipeCards() {
    return _swipeItems.isEmpty
        ? Text(_rawGeminiOutput)
        : SizedBox(
      height: 500,
      child: SwipeCards(
        matchEngine: _matchEngine,
        itemBuilder: (context, index) {
          final gift = _swipeItems[index].content as GiftSuggestion;
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (gift.imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      gift.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox(
                        height: 200,
                        child: Center(child: Icon(Icons.image_not_supported)),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gift.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(gift.description),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () async {
                          final url = Uri.parse(gift.link);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        },
                        child: Text(
                          gift.link,
                          style: const TextStyle(
                              color: Color(0xFF9D6EF7),
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        onStackFinished: () {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Kartlar bitti!")));
        },
        upSwipeAllowed: false,
        fillSpace: true,
      ),
    );
  }

  Widget _buildFormField(String label, TextEditingController controller,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelStyle: const TextStyle(color: Color(0xFF9D6EF7)),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFE0D7F7)),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF9D6EF7), width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) => value!.isEmpty ? "$label girin" : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text("✨ Kişiye Özel Hediye Bul",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4B3C77),
                    )),
                const SizedBox(height: 16),
                _buildFormField("Yaş", _ageController, isNumber: true),
                _buildFormField("Cinsiyet", _genderController),
                _buildFormField("İlişki türü", _relationController),
                _buildFormField("Hobiler (virgülle)", _hobbiesController),
                _buildFormField("Kişilik tipi", _personalityController),
                _buildFormField("Minimum Bütçe", _budgetMinController, isNumber: true),
                _buildFormField("Maksimum Bütçe", _budgetMaxController, isNumber: true),
                _buildFormField("Kaç öneri istiyorsun?", _suggestionCountController, isNumber: true),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: _loading ? null : _getSuggestions,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9D6EF7),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 24),
                  ),
                  child:
                  const Text("🎁 Hediye Öner", style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 24),
                if (_loading)
                  const CircularProgressIndicator()
                else
                  _buildSwipeCards(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
