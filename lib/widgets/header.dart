import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/settings_provider.dart';

class Header extends StatelessWidget {
  final String? activeTabTitle;
  final String? subtitle;

  const Header({
    super.key,
    this.activeTabTitle,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settingsProvider = context.watch<SettingsProvider>();
    final settings = settingsProvider.settings;

    if (activeTabTitle == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  activeTabTitle!,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                onPressed: () {
                  settingsProvider.setDarkMode(!settings.darkMode);
                },
              ),
            ],
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white54 : Colors.black45,
                fontWeight: FontWeight.w400,
              ),
            ),
        ],
      ),
    );
  }
}
