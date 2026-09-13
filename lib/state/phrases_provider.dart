import 'package:flutter/foundation.dart';
import '../models/phrase.dart';
import '../models/app_settings.dart';
import '../data/frases_repository.dart';
import '../utils/phrase_translations.dart';

class PhrasesProvider extends ChangeNotifier {
  List<Phrase> _phrases = [];
  bool _isLoading = true;
  bool _isTranslating = false;
  String? _error;

  List<Phrase> get phrases => _phrases;
  bool get isLoading => _isLoading;
  bool get isTranslating => _isTranslating;
  String? get error => _error;

  List<Phrase> get featuredPhrases => _phrases.where((p) => p.isFeaturedToday).toList();
  List<Phrase> get trendingPhrases => _phrases.where((p) => p.isTrending).toList();
  List<Phrase> get newPhrases => _phrases.where((p) => p.isNew).toList();
  List<String> get categories => FrasesRepository.categoriesFrom(_phrases);

  PhrasesProvider() {
    _load();
  }

  Future<void> _load() async {
    try {
      _phrases = await FrasesRepository.load();
      await PhraseTranslations.initialize();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setLanguage(LanguageCode language) async {
    if (_phrases.isEmpty) return;
    _isTranslating = language != LanguageCode.es;
    notifyListeners();
    try {
      await PhraseTranslations.setLanguage(
        language.name,
        _phrases.map((p) => PhraseSource(p.id, p.sourceText)).toList(),
      );
    } catch (e) {
      _error = 'translation: $e';
    } finally {
      _isTranslating = false;
      notifyListeners();
    }
  }

  int countForCategory(String categoryId) => FrasesRepository.countForCategory(_phrases, categoryId);

  Phrase? getById(String id) {
    try {
      return _phrases.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Phrase> byCategory(String categoryId) => _phrases.where((p) => p.categoryId == categoryId).toList();
  List<Phrase> byTone(String tone) => _phrases.where((p) => p.tone == tone).toList();

  List<Phrase> search(String query) {
    final q = query.toLowerCase();
    return _phrases.where((p) {
      return p.text.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q) ||
          p.categoryId.toLowerCase().contains(q) ||
          p.tone.toLowerCase().contains(q) ||
          p.tags.any((t) => t.toLowerCase().contains(q));
    }).toList();
  }
}
