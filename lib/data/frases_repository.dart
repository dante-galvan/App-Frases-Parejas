import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/phrase.dart';
import 'images.dart';

class FrasesRepository {
  static List<Phrase>? _cache;

  static Future<List<Phrase>> load() async {
    if (_cache != null) return _cache!;

    final jsonStr = await rootBundle.loadString('frases_amor_224.json');
    final Map<String, dynamic> data = json.decode(jsonStr);
    final List<dynamic> frasesList = data['frases'];

    final sortedImages = List<String>.from(availableImages)..sort();

    _cache = frasesList.map((e) {
      final map = e as Map<String, dynamic>;
      final id = map['id'] as int;
      final texto = map['texto'] as String;
      final categoria = map['categoria'] as String;
      final imageIndex = (id - 1).clamp(0, sortedImages.length - 1);
      final image = sortedImages[imageIndex];

      return Phrase(
        id: id.toString(),
        text: texto,
        image: image,
        category: categoria,
      );
    }).toList();

    return _cache!;
  }

  static List<String> categoriesFrom(List<Phrase> phrases) {
    return phrases.map((p) => p.category).toSet().toList();
  }

  static int countForCategory(List<Phrase> phrases, String category) {
    return phrases.where((p) => p.category == category).length;
  }
}
