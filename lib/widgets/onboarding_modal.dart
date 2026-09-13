import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frases_amor_flutter/l10n/app_localizations.dart';
import '../state/settings_provider.dart';
import '../state/toast_provider.dart';
import '../theme/app_colors.dart';

class OnboardingModal extends StatefulWidget {
  const OnboardingModal({super.key});

  @override
  State<OnboardingModal> createState() => _OnboardingModalState();
}

class _OnboardingModalState extends State<OnboardingModal> {
  final List<String> _allInterests = [
    'Amor',
    'Enamoramiento',
    'Pareja',
    'Para dedicar',
    'Pasión',
    'Buenos días amor',
    'Buenas noches amor',
  ];

  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = {'Amor', 'Pareja', 'Para dedicar'};
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: isDark ? RomanticColors.darkSurface : RomanticColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.bienvenido,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.seleccionaTemas,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.white60 : Colors.black45,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _allInterests.length,
                itemBuilder: (context, i) {
                  final interest = _allInterests[i];
                  final selected = _selected.contains(interest);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selected) {
                          _selected.remove(interest);
                        } else {
                          _selected.add(interest);
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: selected
                            ? RomanticColors.romantic700
                            : isDark
                                ? RomanticColors.darkSurfaceAlt
                                : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected
                              ? RomanticColors.romantic600
                              : isDark
                                  ? Colors.white12
                                  : Colors.black12,
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        interest,
                        style: TextStyle(
                          color: selected
                              ? Colors.white
                              : isDark
                                  ? Colors.white70
                                  : Colors.black87,
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<SettingsProvider>().updateSettings(
                          context
                              .read<SettingsProvider>()
                              .settings
                              .copyWith(
                                interests: _selected.toList(),
                                hasCompletedOnboarding: true,
                              ),
                        );
                    context
                        .read<ToastProvider>()
                        .showSuccess(l10n.bienvenidoMensaje);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RomanticColors.romantic700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    l10n.comenzarDescubrir,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
