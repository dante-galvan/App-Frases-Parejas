import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:frases_amor_flutter/l10n/app_localizations.dart';
import 'theme/app_theme.dart';
import 'state/settings_provider.dart';
import 'models/app_settings.dart';
import 'views/home_shell.dart';
import 'widgets/toast.dart';
import 'widgets/splash_screen.dart';

class FrasesApp extends StatefulWidget {
  const FrasesApp({super.key});

  @override
  State<FrasesApp> createState() => _FrasesAppState();
}

class _FrasesAppState extends State<FrasesApp> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final darkMode = settingsProvider.settings.darkMode;

    return MaterialApp(
      title: 'Frases de Amor para Parejas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      locale: languageCodeToLocale(settingsProvider.settings.language),
      supportedLocales: const [
        Locale('es'),
        Locale('en'),
        Locale('pt'),
        Locale('fr'),
        Locale('it'),
        Locale('de'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: _showSplash
          ? SplashScreen(
              onComplete: () => setState(() => _showSplash = false),
            )
          : const HomeShell(),
      builder: (context, child) {
        return Stack(
          children: [
            child ?? const SizedBox.shrink(),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ToastOverlay(),
            ),
          ],
        );
      },
    );
  }
}


