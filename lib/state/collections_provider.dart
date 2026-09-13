import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/collection.dart';
import '../data/initial_collections.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollectionsProvider extends ChangeNotifier {
  static const _key = 'frases_amor_collections';
  List<CollectionItem> _collections = [];
  SharedPreferences? _prefs;

  List<CollectionItem> get collections => List.unmodifiable(_collections);

  CollectionsProvider() { _load(); }

  Future<void> _load() async {
    _prefs = await SharedPreferences.getInstance();
    final jsonStr = _prefs?.getString(_key);
    if (jsonStr == null || jsonStr.trim().isEmpty) {
      _collections = List.from(initialCollections);
      await _save();
    } else {
      try {
        final list = json.decode(jsonStr) as List;
        _collections = list.map((e) => CollectionItem.fromJson(e as Map<String, dynamic>)).toList();
        if (_collections.isEmpty) {
          _collections = List.from(initialCollections);
          await _save();
        }
      } catch (_) {
        _collections = List.from(initialCollections);
        await _save();
      }
    }
    notifyListeners();
  }

  Future<void> _save() async {
    await _prefs?.setString(_key, json.encode(_collections.map((e) => e.toJson()).toList()));
  }

  void createCollection(String name, {String? phraseId}) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final now = DateTime.now();
    final col = CollectionItem(
      id: 'col-${now.microsecondsSinceEpoch}',
      name: trimmed,
      phraseIds: phraseId == null ? [] : [phraseId],
      createdAt: now.toIso8601String(),
      coverPhraseId: phraseId,
    );
    _collections = [..._collections, col];
    _save();
    notifyListeners();
  }

  void renameCollection(String id, String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    _collections = _collections.map((c) => c.id == id ? c.copyWith(name: trimmed) : c).toList();
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
      if (col.id != colId) return col;
      final exists = col.phraseIds.contains(phraseId);
      final ids = exists ? col.phraseIds.where((id) => id != phraseId).toList() : [...col.phraseIds, phraseId];
      return col.copyWith(phraseIds: ids, coverPhraseId: ids.isEmpty ? null : (col.coverPhraseId ?? ids.first));
    }).toList();
    _save();
    notifyListeners();
  }
}
