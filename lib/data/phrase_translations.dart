import 'dart:convert';
import 'package:flutter/services.dart';

class PhraseTranslations {
  static Map<String, Map<String, String>>? _cache;

  static Future<Map<String, Map<String, String>>> load() async {
    if (_cache != null) return _cache!;

    final jsonStr = await rootBundle.loadString('phrase_translations.json');
    final Map<String, dynamic> data = json.decode(jsonStr);

    _cache = {};
    for (final entry in data.entries) {
      final id = entry.key;
      final translations = entry.value as Map<String, dynamic>;
      _cache![id] = {
        'en': translations['en'] as String? ?? '',
        'pt': translations['pt'] as String? ?? '',
        'fr': translations['fr'] as String? ?? '',
        'it': translations['it'] as String? ?? '',
        'de': translations['de'] as String? ?? '',
      };
    }

    return _cache!;
  }

  static Future<String> translate(String phraseId, String languageCode) async {
    final translations = await load();
    final phraseTranslations = translations[phraseId];
    if (phraseTranslations == null) return '';
    return phraseTranslations[languageCode] ?? '';
  }

  static Future<Map<String, String>> getTranslations(String phraseId) async {
    final translations = await load();
    return translations[phraseId] ?? {};
  }
}
