import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frases_amor_flutter/l10n/app_localizations.dart';
import '../state/settings_provider.dart';
import '../state/favorites_provider.dart';
import '../state/collections_provider.dart';
import '../models/app_settings.dart';
import '../theme/app_colors.dart';
import '../widgets/history_modal.dart';
import '../widgets/onboarding_modal.dart';
import '../utils/category_translations.dart';

class PerfilView extends StatelessWidget {
  const PerfilView({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final settings = settingsProvider.settings;
    final favoritesCount =
        context.watch<FavoritesProvider>().savedIds.length;
    final collectionsCount =
        context.watch<CollectionsProvider>().collections.length;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _StatCard(
            isDark: isDark,
            children: [
              _StatItem(
                icon: Icons.favorite,
                label: l10n.favoritos,
                value: '$favoritesCount ${l10n.frases}',
              ),
              Container(
                  width: 1,
                  height: 40,
                      color: isDark ? Colors.white12 : Colors.black12),
              _StatItem(
                icon: Icons.collections,
                label: l10n.colecciones,
                value: '$collectionsCount creadas',
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SectionTitle(title: l10n.apariencia, isDark: isDark),
          const SizedBox(height: 10),
          _SettingsTile(
            isDark: isDark,
            icon: isDark ? Icons.light_mode : Icons.dark_mode,
            title: l10n.modoOscuro,
            subtitle: isDark ? l10n.activado : l10n.desactivado,
            trailing: Switch(
              value: settings.darkMode,
              onChanged: (v) => settingsProvider.setDarkMode(v),
              activeColor: RomanticColors.romantic600,
            ),
          ),
          const SizedBox(height: 24),
          _SectionTitle(title: l10n.idioma, isDark: isDark),
          const SizedBox(height: 10),
          _SettingsTile(
            isDark: isDark,
            icon: Icons.language,
            title: l10n.idiomaApp,
            subtitle: settings.language.label,
            onTap: () => _showLanguagePicker(context, settingsProvider),
          ),
          const SizedBox(height: 24),
          _SectionTitle(title: l10n.intereses, isDark: isDark),
          const SizedBox(height: 10),
          _SettingsTile(
            isDark: isDark,
            icon: Icons.tune,
            title: l10n.temasInteres,
            subtitle: settings.interests.join(', '),
            onTap: () => _showInterestsEditor(context, settingsProvider),
          ),
          const SizedBox(height: 24),
          _SectionTitle(title: l10n.datos, isDark: isDark),
          const SizedBox(height: 10),
          _SettingsTile(
            isDark: isDark,
            icon: Icons.history,
            title: l10n.historialFrases,
            subtitle: l10n.historialFrasesSubtitle,
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const HistoryModal(),
            ),
          ),
          const SizedBox(height: 8),
          _SettingsTile(
            isDark: isDark,
            icon: Icons.refresh,
            title: l10n.reiniciarOnboarding,
            subtitle: l10n.reiniciarOnboardingSubtitle,
            onTap: () {
              settingsProvider.setHasCompletedOnboarding(false);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                enableDrag: false,
                isDismissible: false,
                builder: (_) => const OnboardingModal(),
              );
            },
          ),
          const SizedBox(height: 30),
          Center(
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        RomanticColors.romantic700,
                        RomanticColors.romantic500,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.favorite, color: Colors.white, size: 28),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.appTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.version,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white30 : Colors.black38,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  void _showLanguagePicker(
      BuildContext context, SettingsProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? RomanticColors.darkSurface
              : RomanticColors.lightSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.seleccionarIdioma,
                  style:
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ),
            ...LanguageCode.values.map((lang) => ListTile(
                  title: Text(lang.label),
                  trailing: provider.settings.language == lang
                      ? const Icon(Icons.check,
                          color: RomanticColors.romantic600)
                      : null,
                  onTap: () {
                    provider.setLanguage(lang);
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showInterestsEditor(
      BuildContext context, SettingsProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    final allInterests = [
      'amor',
      'enamoramiento',
      'pareja',
      'para_dedicar',
      'pasion',
      'buenos_dias_amor',
      'buenas_noches_amor',
    ];
    final selected = Set<String>.from(provider.settings.interests);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (_, setState) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: isDark
                  ? RomanticColors.darkSurface
                  : RomanticColors.lightSurface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.editarIntereses,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700)),
                      TextButton(
                        onPressed: () {
                          provider.setInterests(selected.toList());
                          Navigator.pop(context);
                        },
                        child: Text(l10n.guardar),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: allInterests.map((interest) {
                      final isSelected = selected.contains(interest);
                      return CheckboxListTile(
                        value: isSelected,
                        title: Text(CategoryTranslations.label(interest, Localizations.localeOf(context))),
                        activeColor: RomanticColors.romantic600,
                        onChanged: (v) {
                          setState(() {
                            if (v == true) {
                              selected.add(interest);
                            } else {
                              selected.remove(interest);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final bool isDark;
  final List<Widget> children;

  const _StatCard({required this.isDark, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? RomanticColors.darkSurfaceAlt : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark ? Colors.white12 : Colors.black12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children,
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Icon(icon,
            color: RomanticColors.romantic500,
            size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.white54 : Colors.black45,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final bool isDark;

  const _SectionTitle({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: isDark ? Colors.white54 : Colors.black45,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.isDark,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? RomanticColors.darkSurfaceAlt : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: isDark ? Colors.white12 : Colors.black12),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: RomanticColors.romantic500,
                size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
            if (onTap != null && trailing == null)
              Icon(Icons.chevron_right,
                  color: isDark ? Colors.white38 : Colors.black38, size: 20),
          ],
        ),
      ),
    );
  }
}
