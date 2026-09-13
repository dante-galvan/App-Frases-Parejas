import 'dart:ui';

import '../models/app_settings.dart';

class CategoryTranslations {
  static const Map<String, Map<String, String>> _labels = {
    'amor': {
      'es': 'Amor',
      'en': 'Love',
      'pt': 'Amor',
      'fr': 'Amour',
      'it': 'Amore',
      'de': 'Liebe',
    },
    'enamoramiento': {
      'es': 'Enamoramiento',
      'en': 'Falling in love',
      'pt': 'Enamoramento',
      'fr': 'Coup de foudre',
      'it': 'Innamoramento',
      'de': 'Verliebtheit',
    },
    'pareja': {
      'es': 'Pareja',
      'en': 'Couple',
      'pt': 'Casal',
      'fr': 'Couple',
      'it': 'Coppia',
      'de': 'Paar',
    },
    'para_dedicar': {
      'es': 'Para dedicar',
      'en': 'To dedicate',
      'pt': 'Para dedicar',
      'fr': 'À dédier',
      'it': 'Da dedicare',
      'de': 'Zum Widmen',
    },
    'pasion': {
      'es': 'Pasión',
      'en': 'Passion',
      'pt': 'Paixão',
      'fr': 'Passion',
      'it': 'Passione',
      'de': 'Leidenschaft',
    },
    'buenos_dias_amor': {
      'es': 'Buenos días amor',
      'en': 'Good morning love',
      'pt': 'Bom dia amor',
      'fr': 'Bonjour mon amour',
      'it': 'Buongiorno amore',
      'de': 'Guten Morgen Liebe',
    },
    'buenas_noches_amor': {
      'es': 'Buenas noches amor',
      'en': 'Goodnight love',
      'pt': 'Boa noite amor',
      'fr': 'Bonne nuit mon amour',
      'it': 'Buonanotte amore',
      'de': 'Gute Nacht Liebe',
    },
    'momentos_especiales': {
      'es': 'Momentos especiales',
      'en': 'Special moments',
      'pt': 'Momentos especiais',
      'fr': 'Moments spéciaux',
      'it': 'Momenti speciali',
      'de': 'Besondere Momente',
    },
    'favoritos': {
      'es': 'Mis favoritas',
      'en': 'My favorites',
      'pt': 'Meus favoritos',
      'fr': 'Mes favoris',
      'it': 'I miei preferiti',
      'de': 'Meine Favoriten',
    },
  };

  static String label(String categoryId, Locale locale) {
    final lang = locale.languageCode;
    final category = _labels[categoryId];
    if (category == null) return categoryId;
    return category[lang] ?? category['es'] ?? categoryId;
  }

  static String labelFromLanguageCode(String categoryId, LanguageCode lang) {
    return label(categoryId, lang.locale);
  }

  static String labelEs(String categoryId) {
    return label(categoryId, const Locale('es'));
  }

  static const Map<String, String> _predefinedCollectionCategory = {
    'col-favoritas': 'favoritos',
    'col-para-dedicar': 'para_dedicar',
    'col-momentos': 'momentos_especiales',
    'col-amor': 'amor',
    'col-pasion': 'pasion',
  };

  static const Map<String, String> _predefinedCollectionEmoji = {
    'col-favoritas': '\u2764\uFE0F',
    'col-para-dedicar': '\uD83D\uDC95',
    'col-momentos': '\u2728',
    'col-amor': '\uD83C\uDF39',
    'col-pasion': '\uD83D\uDD25',
  };

  static String collectionDisplayName(
      String collectionId, String fallbackName, Locale locale) {
    final categoryKey = _predefinedCollectionCategory[collectionId];
    if (categoryKey == null) return fallbackName;
    final emoji = _predefinedCollectionEmoji[collectionId] ?? '';
    final translated = label(categoryKey, locale);
    return '$emoji $translated';
  }
}
