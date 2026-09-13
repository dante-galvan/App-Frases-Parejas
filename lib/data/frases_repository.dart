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

    final phrases = frasesList.map((e) {
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

    _assignFlags(phrases);

    _cache = phrases;
    return _cache!;
  }

  static void _assignFlags(List<Phrase> phrases) {
    const trendingIds = {
      '5', '15', '38', '50', '75', '100', '135', '160', '190', '220',
    };

    final Map<String, int> categoryCount = {};
    for (final p in phrases) {
      categoryCount[p.category] = (categoryCount[p.category] ?? 0) + 1;
    }

    final Map<String, int> categoryCurrent = {};
    final Set<String> lastThreeIds = {};
    for (final p in phrases) {
      categoryCurrent[p.category] = (categoryCurrent[p.category] ?? 0) + 1;
      final count = categoryCount[p.category]!;
      final current = categoryCurrent[p.category]!;
      if (current > count - 3) {
        lastThreeIds.add(p.id);
      }
    }

    for (int i = 0; i < phrases.length; i++) {
      final p = phrases[i];
      final isFeatured = i == 0;
      final isTrending = trendingIds.contains(p.id);
      final isNew = lastThreeIds.contains(p.id);

      if (isFeatured || isTrending || isNew) {
        phrases[i] = Phrase(
          id: p.id,
          text: p.text,
          image: p.image,
          category: p.category,
          isFeaturedToday: isFeatured,
          isTrending: isTrending,
          isNew: isNew,
        );
      }
    }
  }

  static List<String> categoriesFrom(List<Phrase> phrases) {
    return phrases.map((p) => p.category).toSet().toList();
  }

  static int countForCategory(List<Phrase> phrases, String category) {
    return phrases.where((p) => p.category == category).length;
  }
}
