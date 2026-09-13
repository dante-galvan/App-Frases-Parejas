import 'dart:ui';
import 'package:flutter/foundation.dart';
import '../models/phrase.dart';
import '../data/frases_repository.dart';
import '../data/phrase_translations.dart';

class PhrasesProvider extends ChangeNotifier {
  List<Phrase> _phrases = [];
  bool _isLoading = true;
  String? _error;
  Map<String, Map<String, String>> _translations = {};

  List<Phrase> get phrases => _phrases;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Phrase> get featuredPhrases =>
      _phrases.where((p) => p.isFeaturedToday).toList();

  List<Phrase> get trendingPhrases =>
      _phrases.where((p) => p.isTrending).toList();

  List<Phrase> get newPhrases =>
      _phrases.where((p) => p.isNew).toList();

  List<String> get categories => FrasesRepository.categoriesFrom(_phrases);

  PhrasesProvider() {
    _load();
  }

  Future<void> _load() async {
    try {
      _phrases = await FrasesRepository.load();
      _translations = await PhraseTranslations.load();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  String getText(Phrase phrase, Locale locale) {
    if (locale.languageCode == 'es') return phrase.text;

    final phraseTranslations = _translations[phrase.id];
    if (phraseTranslations == null) return phrase.text;

    return phraseTranslations[locale.languageCode] ?? phrase.text;
  }

  int countForCategory(String categoryId) =>
      FrasesRepository.countForCategory(_phrases, categoryId);

  Phrase? getById(String id) {
    try {
      return _phrases.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Phrase> byCategory(String categoryId) =>
      _phrases.where((p) => p.categoryId == categoryId).toList();

  List<Phrase> byTone(String tone) =>
      _phrases.where((p) => p.tone == tone).toList();

  List<Phrase> search(String query, Locale locale) {
    final q = query.toLowerCase();
    return _phrases.where((p) {
      final text = getText(p, locale).toLowerCase();
      return text.contains(q) ||
          p.category.toLowerCase().contains(q) ||
          p.categoryId.toLowerCase().contains(q) ||
          p.tone.toLowerCase().contains(q) ||
          p.tags.any((t) => t.toLowerCase().contains(q));
    }).toList();
  }
}
