import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhraseSource {
  final String id;
  final String text;
  const PhraseSource(this.id, this.text);
}

class PhraseTranslations {
  static const _prefix = 'phrase_translation_v1';
  static String _language = 'es';
  static final Map<String, String> _cache = {};
  static SharedPreferences? _prefs;

  static String get language => _language;

  static Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    _language = _prefs?.getString('phrase_translation_language') ?? 'es';
    final keys = _prefs?.getKeys() ?? <String>{};
    for (final key in keys.where((k) => k.startsWith('$_prefix:'))) {
      final value = _prefs?.getString(key);
      if (value != null) _cache[key] = value;
    }
  }

  static String textFor(String id, String originalText) {
    if (_language == 'es') return originalText;
    return _cache[_key(_language, id)] ?? originalText;
  }

  static Future<void> setLanguage(
    String language,
    List<PhraseSource> phrases, {
    void Function(int done, int total)? onProgress,
  }) async {
    await initialize();
    _language = language;
    await _prefs?.setString('phrase_translation_language', language);

    if (language == 'es') {
      onProgress?.call(phrases.length, phrases.length);
      return;
    }

    final target = _targetLanguage(language);
    if (target == null) return;

    final modelManager = OnDeviceTranslatorModelManager();
    await modelManager.downloadModel(TranslateLanguage.spanish.bcpCode);
    await modelManager.downloadModel(target.bcpCode);

    final translator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.spanish,
      targetLanguage: target,
    );

    try {
      int done = 0;
      for (final phrase in phrases) {
        final key = _key(language, phrase.id);
        if (!_cache.containsKey(key)) {
          try {
            final translated = await translator.translateText(phrase.text);
            if (translated.trim().isNotEmpty) {
              _cache[key] = translated;
              await _prefs?.setString(key, translated);
            }
          } catch (_) {}
        }
        done++;
        onProgress?.call(done, phrases.length);
      }
    } finally {
      await translator.close();
    }
  }

  static String _key(String language, String id) => '$_prefix:$language:$id';

  static TranslateLanguage? _targetLanguage(String language) {
    switch (language) {
      case 'en': return TranslateLanguage.english;
      case 'pt': return TranslateLanguage.portuguese;
      case 'fr': return TranslateLanguage.french;
      case 'it': return TranslateLanguage.italian;
      case 'de': return TranslateLanguage.german;
      default: return null;
    }
  }
}
