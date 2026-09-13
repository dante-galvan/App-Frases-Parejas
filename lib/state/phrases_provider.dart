import 'package:flutter/foundation.dart';
import '../models/phrase.dart';
import '../data/frases_repository.dart';

class PhrasesProvider extends ChangeNotifier {
  List<Phrase> _phrases = [];
  bool _isLoading = true;
  String? _error;

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
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
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
