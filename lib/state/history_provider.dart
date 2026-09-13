import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryProvider extends ChangeNotifier {
  static const _key = 'frases_amor_history';

  List<String> _historyIds = [];
  SharedPreferences? _prefs;

  List<String> get historyIds => _historyIds;

  HistoryProvider() {
    _load();
  }

  Future<void> _load() async {
    _prefs = await SharedPreferences.getInstance();
    final list = _prefs?.getStringList(_key);
    if (list != null) {
      _historyIds = list;
    }
    notifyListeners();
  }

  Future<void> _save() async {
    await _prefs?.setStringList(_key, _historyIds);
  }

  void add(String id) {
    _historyIds = [id, ..._historyIds.where((e) => e != id).take(30)];
    _save();
    notifyListeners();
  }

  void clear() {
    _historyIds = [];
    _save();
    notifyListeners();
  }
}
