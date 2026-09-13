import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/phrase.dart';
import 'images.dart';

class FrasesRepository {
  static List<Phrase>? _cache;

  static const Map<String, String> _categorySlugMap = {
    'Amor': 'amor',
    'Enamoramiento': 'enamoramiento',
    'Pareja': 'pareja',
    'Para dedicar': 'para_dedicar',
    'Pasion': 'pasion',
    'Pasión': 'pasion',
    'Buenos dias amor': 'buenos_dias_amor',
    'Buenos días amor': 'buenos_dias_amor',
    'Buenas noches amor': 'buenas_noches_amor',
  };

  static const Map<String, String> _slugToEsName = {
    'amor': 'Amor',
    'enamoramiento': 'Enamoramiento',
    'pareja': 'Pareja',
    'para_dedicar': 'Para dedicar',
    'pasion': 'Pasion',
    'buenos_dias_amor': 'Buenos dias amor',
    'buenas_noches_amor': 'Buenas noches amor',
  };

  static String slugForCategory(String categoryName) {
    return _categorySlugMap[categoryName] ?? categoryName.toLowerCase();
  }

  static String esNameForSlug(String slug) {
    return _slugToEsName[slug] ?? slug;
  }

  static List<String> allSlugs() => _slugToEsName.keys.toList();

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
        categoryId: slugForCategory(categoria),
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
      categoryCount[p.categoryId] = (categoryCount[p.categoryId] ?? 0) + 1;
    }

    final Map<String, int> categoryCurrent = {};
    final Set<String> lastThreeIds = {};
    for (final p in phrases) {
      categoryCurrent[p.categoryId] = (categoryCurrent[p.categoryId] ?? 0) + 1;
      final count = categoryCount[p.categoryId]!;
      final current = categoryCurrent[p.categoryId]!;
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
          categoryId: p.categoryId,
          isFeaturedToday: isFeatured,
          isTrending: isTrending,
          isNew: isNew,
        );
      }
    }
  }

  static List<String> categoriesFrom(List<Phrase> phrases) {
    return phrases.map((p) => p.categoryId).toSet().toList();
  }

  static int countForCategory(List<Phrase> phrases, String categoryId) {
    return phrases.where((p) => p.categoryId == categoryId).length;
  }
}
