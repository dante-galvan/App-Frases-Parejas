import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  static const _key = 'frases_amor_saved';

  Set<String> _savedIds = {};
  SharedPreferences? _prefs;

  Set<String> get savedIds => _savedIds;

  FavoritesProvider() {
    _load();
  }

  Future<void> _load() async {
    _prefs = await SharedPreferences.getInstance();
    final list = _prefs?.getStringList(_key);
    if (list != null) {
      _savedIds = Set.from(list);
    }
    notifyListeners();
  }

  Future<void> _save() async {
    await _prefs?.setStringList(_key, _savedIds.toList());
  }

  bool isSaved(String id) => _savedIds.contains(id);

  void toggle(String id) {
    if (_savedIds.contains(id)) {
      _savedIds = Set.from(_savedIds)..remove(id);
    } else {
      _savedIds = Set.from(_savedIds)..add(id);
    }
    _save();
    notifyListeners();
  }

  void add(String id) {
    if (!_savedIds.contains(id)) {
      _savedIds = Set.from(_savedIds)..add(id);
      _save();
      notifyListeners();
    }
  }

  void remove(String id) {
    if (_savedIds.contains(id)) {
      _savedIds = Set.from(_savedIds)..remove(id);
      _save();
      notifyListeners();
    }
  }
}
