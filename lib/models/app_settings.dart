import 'dart:ui';

enum LanguageCode { es, en, pt, fr, it, de }

extension LanguageCodeX on LanguageCode {
  String get label {
    switch (this) {
      case LanguageCode.es:
        return 'Español';
      case LanguageCode.en:
        return 'English';
      case LanguageCode.pt:
        return 'Português';
      case LanguageCode.fr:
        return 'Français';
      case LanguageCode.it:
        return 'Italiano';
      case LanguageCode.de:
        return 'Deutsch';
    }
  }

  Locale get locale {
    switch (this) {
      case LanguageCode.es:
        return const Locale('es');
      case LanguageCode.en:
        return const Locale('en');
      case LanguageCode.pt:
        return const Locale('pt');
      case LanguageCode.fr:
        return const Locale('fr');
      case LanguageCode.it:
        return const Locale('it');
      case LanguageCode.de:
        return const Locale('de');
    }
  }
}

Locale languageCodeToLocale(LanguageCode code) {
  switch (code) {
    case LanguageCode.es:
      return const Locale('es');
    case LanguageCode.en:
      return const Locale('en');
    case LanguageCode.pt:
      return const Locale('pt');
    case LanguageCode.fr:
      return const Locale('fr');
    case LanguageCode.it:
      return const Locale('it');
    case LanguageCode.de:
      return const Locale('de');
  }
}

class AppSettings {
  final bool darkMode;
  final LanguageCode language;
  final bool dailyNotification;
  final bool newPhrasesNotification;
  final bool recommendationsNotification;
  final List<String> interests;
  final bool hasCompletedOnboarding;

  const AppSettings({
    required this.darkMode,
    required this.language,
    required this.dailyNotification,
    required this.newPhrasesNotification,
    required this.recommendationsNotification,
    required this.interests,
    required this.hasCompletedOnboarding,
  });

  factory AppSettings.defaults() => const AppSettings(
        darkMode: true,
        language: LanguageCode.en,
        dailyNotification: true,
        newPhrasesNotification: true,
        recommendationsNotification: false,
        interests: ['amor', 'para_dedicar', 'pareja'],
        hasCompletedOnboarding: false,
      );

  AppSettings copyWith({
    bool? darkMode,
    LanguageCode? language,
    bool? dailyNotification,
    bool? newPhrasesNotification,
    bool? recommendationsNotification,
    List<String>? interests,
    bool? hasCompletedOnboarding,
  }) {
    return AppSettings(
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
      dailyNotification: dailyNotification ?? this.dailyNotification,
      newPhrasesNotification:
          newPhrasesNotification ?? this.newPhrasesNotification,
      recommendationsNotification:
          recommendationsNotification ?? this.recommendationsNotification,
      interests: interests ?? this.interests,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    final lang = json['language'] as String? ?? 'en';
    return AppSettings(
      darkMode: json['darkMode'] as bool? ?? true,
      language: LanguageCode.values.firstWhere(
        (e) => e.name == lang,
        orElse: () => LanguageCode.en,
      ),
      dailyNotification: json['dailyNotification'] as bool? ?? true,
      newPhrasesNotification: json['newPhrasesNotification'] as bool? ?? true,
      recommendationsNotification:
          json['recommendationsNotification'] as bool? ?? false,
      interests: (json['interests'] as List?)?.cast<String>() ??
          const ['amor', 'para_dedicar', 'pareja'],
      hasCompletedOnboarding:
          json['hasCompletedOnboarding'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'darkMode': darkMode,
        'language': language.name,
        'dailyNotification': dailyNotification,
        'newPhrasesNotification': newPhrasesNotification,
        'recommendationsNotification': recommendationsNotification,
        'interests': interests,
        'hasCompletedOnboarding': hasCompletedOnboarding,
      };
}
