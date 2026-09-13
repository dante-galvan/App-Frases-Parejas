import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frases_amor_flutter/l10n/app_localizations.dart';
import '../state/phrases_provider.dart';
import '../state/favorites_provider.dart';
import '../models/phrase.dart';
import '../theme/app_colors.dart';
import '../widgets/phrase_card.dart';
import '../widgets/phrase_detail_modal.dart';

class InicioView extends StatelessWidget {
  final void Function(String category)? onCategoryTap;

  const InicioView({super.key, this.onCategoryTap});

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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline,
                  size: 48, color: isDark ? Colors.white38 : Colors.black38),
              const SizedBox(height: 16),
              Text(
                l10n.noHayFrases,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final phrases = phrasesProvider.phrases;
    final categories = phrasesProvider.categories;

    final featuredPhrase = phrasesProvider.featuredPhrases.isNotEmpty
        ? phrasesProvider.featuredPhrases.first
        : phrases.first;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _FeaturedSection(phrase: featuredPhrase),
          const SizedBox(height: 28),
          _SectionTitle(title: l10n.explorarPorCategoria, isDark: isDark),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) {
                final cat = categories[i];
                final count = phrasesProvider.countForCategory(cat);
                return _CategoryChip(
                  name: cat,
                  count: count,
                  isDark: isDark,
                  onTap: onCategoryTap != null
                      ? () => onCategoryTap!(cat)
                      : null,
                );
              },
            ),
          ),
          const SizedBox(height: 28),
          _SectionTitle(title: l10n.frasesTrending, isDark: isDark),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: phrasesProvider.trendingPhrases.length.clamp(0, 10),
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final phrase = phrasesProvider.trendingPhrases[i];
                return SizedBox(
                  width: 160,
                  child: PhraseCard(
                    phrase: phrase,
                    isSaved: favoritesProvider.isSaved(phrase.id),
                    onTap: () => _openDetail(context, phrase),
                    onSave: () => favoritesProvider.toggle(phrase.id),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 28),
          _SectionTitle(title: l10n.recienLlegadas, isDark: isDark),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: phrasesProvider.newPhrases.length.clamp(0, 10),
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final phrase = phrasesProvider.newPhrases[i];
                return SizedBox(
                  width: 160,
                  child: PhraseCard(
                    phrase: phrase,
                    isSaved: favoritesProvider.isSaved(phrase.id),
                    onTap: () => _openDetail(context, phrase),
                    onSave: () => favoritesProvider.toggle(phrase.id),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 28),
          _SectionTitle(title: l10n.todasLasFrases, isDark: isDark),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: phrases.length.clamp(0, 20),
            itemBuilder: (context, i) {
              final phrase = phrases[i];
              return PhraseCard(
                phrase: phrase,
                isSaved: favoritesProvider.isSaved(phrase.id),
                onTap: () => _openDetail(context, phrase),
                onSave: () => favoritesProvider.toggle(phrase.id),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
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

class _FeaturedSection extends StatelessWidget {
  final Phrase phrase;

  const _FeaturedSection({required this.phrase});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => PhraseDetailModal(phrase: phrase),
        );
      },
      child: Container(
        height: 480,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: RomanticColors.romantic900.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'Imagenes/${phrase.image}',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: RomanticColors.darkSurfaceAlt,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 200,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.55),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.88),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: RomanticColors.romantic700.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    l10n.fraseDelDia,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      phrase.category.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      phrase.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.touch_app,
                            color: Colors.white54, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          l10n.tocaParaVerMas,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.white : const Color(0xFF1A1A1A),
        letterSpacing: -0.3,
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String name;
  final int count;
  final bool isDark;
  final VoidCallback? onTap;

  const _CategoryChip({
    required this.name,
    required this.count,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? RomanticColors.darkSurfaceAlt : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.black12,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$count ${l10n.frases}',
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
