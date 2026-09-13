import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/collection.dart';
import '../data/initial_collections.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollectionsProvider extends ChangeNotifier {
  static const _key = 'frases_amor_collections';

  List<CollectionItem> _collections = [];
  SharedPreferences? _prefs;

  List<CollectionItem> get collections => _collections;

  CollectionsProvider() {
    _load();
  }

  Future<void> _load() async {
    _prefs = await SharedPreferences.getInstance();
    final jsonStr = _prefs?.getString(_key);
    if (jsonStr != null) {
      try {
        final list = json.decode(jsonStr) as List;
        _collections = list
            .map((e) => CollectionItem.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {
        _collections = List.from(initialCollections);
      }
    } else {
      _collections = List.from(initialCollections);
    }
    notifyListeners();
  }

  Future<void> _save() async {
    await _prefs?.setString(
      _key,
      json.encode(_collections.map((e) => e.toJson()).toList()),
    );
  }

  void createCollection(String name, {String? phraseId}) {
    final col = CollectionItem(
      id: 'col-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      phraseIds: phraseId != null ? [phraseId] : [],
      createdAt: DateTime.now().toIso8601String().split('T').first,
      coverPhraseId: phraseId,
    );
    _collections = [..._collections, col];
    _save();
    notifyListeners();
  }

  void deleteCollection(String id) {
    _collections = _collections.where((c) => c.id != id).toList();
    _save();
    notifyListeners();
  }

  void togglePhraseInCollection(String colId, String phraseId) {
    _collections = _collections.map((col) {
      if (col.id == colId) {
        final exists = col.phraseIds.contains(phraseId);
        return col.copyWith(
          phraseIds: exists
              ? col.phraseIds.where((id) => id != phraseId).toList()
              : [...col.phraseIds, phraseId],
        );
      }
      return col;
    }).toList();
    _save();
    notifyListeners();
  }
}
