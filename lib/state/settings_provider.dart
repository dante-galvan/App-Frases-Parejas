import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const _key = 'frases_amor_settings';

  AppSettings _settings = AppSettings.defaults();
  SharedPreferences? _prefs;
  bool _isLoading = true;

  AppSettings get settings => _settings;
  bool get isLoading => _isLoading;

  SettingsProvider() {
    load();
  }

  Future<void> load() async {
    _isLoading = true;
    _prefs = await SharedPreferences.getInstance();
    final jsonStr = _prefs?.getString(_key);
    if (jsonStr != null) {
      try {
        _settings = AppSettings.fromJson(
          json.decode(jsonStr) as Map<String, dynamic>,
        );
      } catch (_) {
        _settings = AppSettings.defaults();
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _save() async {
    await _prefs?.setString(_key, json.encode(_settings.toJson()));
  }

  void updateSettings(AppSettings newSettings) {
    _settings = newSettings;
    _save();
    notifyListeners();
  }

  void setDarkMode(bool value) {
    _settings = _settings.copyWith(darkMode: value);
    _save();
    notifyListeners();
  }

  void setLanguage(LanguageCode value) {
    _settings = _settings.copyWith(language: value);
    _save();
    notifyListeners();
  }

  void setInterests(List<String> value) {
    _settings = _settings.copyWith(interests: value);
    _save();
    notifyListeners();
  }

  void setHasCompletedOnboarding(bool value) {
    _settings = _settings.copyWith(hasCompletedOnboarding: value);
    _save();
    notifyListeners();
  }
}
