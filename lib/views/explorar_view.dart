import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frases_amor_flutter/l10n/app_localizations.dart';
import '../state/phrases_provider.dart';
import '../state/favorites_provider.dart';
import '../models/phrase.dart';
import '../theme/app_colors.dart';
import '../widgets/phrase_card.dart';
import '../widgets/phrase_detail_modal.dart';

class ExplorarView extends StatefulWidget {
  final String? initialCategory;

  const ExplorarView({super.key, this.initialCategory});

  @override
  State<ExplorarView> createState() => _ExplorarViewState();
}

class _ExplorarViewState extends State<ExplorarView> {
  String? _selectedCategory;
  String _selectedTone = 'todas';

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
  }

  @override
  void didUpdateWidget(ExplorarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCategory != oldWidget.initialCategory) {
      setState(() {
        _selectedCategory = widget.initialCategory;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final phrasesProvider = context.watch<PhrasesProvider>();
    final favoritesProvider = context.watch<FavoritesProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    if (phrasesProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (phrasesProvider.error != null) {
      return Center(
        child: Text(
          l10n.noHayFrases,
          style: TextStyle(
            color: isDark ? Colors.white38 : Colors.black38,
          ),
        ),
      );
    }

    final categories = phrasesProvider.categories;

    final tones = [l10n.todas, 'Románticas', 'Tiernas', 'Intensas', 'Coquetas', 'Poéticas', 'Divertidas', 'Profundas'];

    List<Phrase> filtered = phrasesProvider.phrases;
    if (_selectedCategory != null) {
      filtered = filtered.where((p) => p.category == _selectedCategory).toList();
    }
    if (_selectedTone != l10n.todas) {
      filtered = filtered.where((p) => p.tone == _selectedTone).toList();
    }

    return Column(
      children: [
        SizedBox(
          height: 40,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              if (i == 0) {
                final selected = _selectedCategory == null;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = null;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? RomanticColors.romantic700
                          : isDark
                              ? RomanticColors.darkSurfaceAlt
                              : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? RomanticColors.romantic600
                            : isDark
                                ? Colors.white12
                                : Colors.black12,
                      ),
                    ),
                    child: Text(
                      l10n.todosLosTonos,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: selected
                            ? Colors.white
                            : isDark
                                ? Colors.white70
                                : Colors.black87,
                      ),
                    ),
                  ),
                );
              }
              final cat = categories[i - 1];
              final selected = _selectedCategory == cat;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = selected ? null : cat;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected
                        ? RomanticColors.romantic700
                        : isDark
                            ? RomanticColors.darkSurfaceAlt
                            : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected
                          ? RomanticColors.romantic600
                          : isDark
                              ? Colors.white12
                              : Colors.black12,
                    ),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: selected
                          ? Colors.white
                          : isDark
                              ? Colors.white70
                              : Colors.black87,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 34,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: tones.length,
            separatorBuilder: (_, __) => const SizedBox(width: 6),
            itemBuilder: (context, i) {
              final tone = tones[i];
              final selected = _selectedTone == tone;
              return GestureDetector(
                onTap: () => setState(() => _selectedTone = tone),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: selected
                        ? RomanticColors.romantic900.withValues(alpha: 0.8)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selected
                          ? RomanticColors.romantic600
                          : isDark
                              ? Colors.white24
                              : Colors.black26,
                    ),
                  ),
                  child: Text(
                    tone == l10n.todas ? l10n.todosLosTonos : tone,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: selected
                          ? Colors.white
                          : isDark
                              ? Colors.white54
                              : Colors.black54,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text(
                    l10n.noHayFrases,
                    style: TextStyle(
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final phrase = filtered[i];
                    return PhraseCard(
                      phrase: phrase,
                      isSaved: favoritesProvider.isSaved(phrase.id),
                      onTap: () => _openDetail(context, phrase),
                      onSave: () => favoritesProvider.toggle(phrase.id),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _openDetail(BuildContext context, Phrase phrase) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PhraseDetailModal(phrase: phrase),
    );
  }
}
