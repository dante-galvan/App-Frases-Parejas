import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'state/phrases_provider.dart';
import 'state/settings_provider.dart';
import 'state/favorites_provider.dart';
import 'state/history_provider.dart';
import 'state/collections_provider.dart';
import 'state/toast_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  ));
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final settingsProvider = SettingsProvider();
  await settingsProvider.load();
  final phrasesProvider = PhrasesProvider(
    initialLanguage: settingsProvider.settings.language,
  );
  settingsProvider.addListener(() {
    phrasesProvider.setLanguage(settingsProvider.settings.language);
  });

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: phrasesProvider),
      ChangeNotifierProvider.value(value: settingsProvider),
      ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ChangeNotifierProvider(create: (_) => CollectionsProvider()),
      ChangeNotifierProvider(create: (_) => ToastProvider()),
    ],
    child: const FrasesApp(),
  ));
}
