import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frases_amor_flutter/l10n/app_localizations.dart';
import '../state/favorites_provider.dart';
import '../state/settings_provider.dart';
import 'inicio_view.dart';
import 'explorar_view.dart';
import 'favoritos_view.dart';
import 'perfil_view.dart';
import '../widgets/header.dart';
import '../widgets/onboarding_modal.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;
  bool _onboardingShown = false;
  String? _exploreCategory;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsProvider>();
    if (!settings.isLoading && !settings.settings.hasCompletedOnboarding) {
      _onboardingShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showOnboarding();
      });
    } else if (settings.settings.hasCompletedOnboarding) {
      _onboardingShown = true;
    }
  }

  void _onCategoryTap(String category) {
    setState(() {
      _exploreCategory = category;
      _currentIndex = 1;
    });
  }

  void _showOnboarding() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      builder: (_) => const OnboardingModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoritesCount = context.watch<FavoritesProvider>().savedIds.length;
    final settings = context.watch<SettingsProvider>();
    final l10n = AppLocalizations.of(context)!;

    if (!_onboardingShown &&
        !settings.isLoading &&
        !settings.settings.hasCompletedOnboarding) {
      _onboardingShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showOnboarding();
      });
    }

    final titles = [null, l10n.explorar, l10n.favoritos, l10n.ajustes];
    final subtitles = [
      null,
      l10n.descubrePorTemas,
      l10n.frasesGuardadas(favoritesCount),
      l10n.preferenciasCentro,
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Header(
              activeTabTitle: titles[_currentIndex],
              subtitle: subtitles[_currentIndex],
            ),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  InicioView(onCategoryTap: _onCategoryTap),
                  ExplorarView(initialCategory: _exploreCategory),
                  const FavoritosView(),
                  const PerfilView(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: l10n.inicio,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.explore_outlined),
            activeIcon: const Icon(Icons.explore),
            label: l10n.explorar,
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: favoritesCount > 0,
              label: Text('$favoritesCount'),
              child: const Icon(Icons.favorite_outline),
            ),
            activeIcon: Badge(
              isLabelVisible: favoritesCount > 0,
              label: Text('$favoritesCount'),
              child: const Icon(Icons.favorite),
            ),
            label: l10n.favoritos,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings),
            label: l10n.ajustes,
          ),
        ],
      ),
    );
  }
}
