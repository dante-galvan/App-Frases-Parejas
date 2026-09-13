import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frases_amor_flutter/l10n/app_localizations.dart';
import '../models/phrase.dart';
import '../state/phrases_provider.dart';
import '../state/history_provider.dart';
import '../theme/app_colors.dart';
import '../utils/category_translations.dart';
import 'phrase_actions.dart';

class PhraseDetailModal extends StatefulWidget {
  final Phrase phrase;

  const PhraseDetailModal({super.key, required this.phrase});

  @override
  State<PhraseDetailModal> createState() => _PhraseDetailModalState();
}

class _PhraseDetailModalState extends State<PhraseDetailModal> {
  late List<Phrase> _relatedPhrases;

  @override
  void initState() {
    super.initState();
    final allPhrases = context.read<PhrasesProvider>().phrases;
    final sameCategory = allPhrases
        .where((p) =>
            p.categoryId == widget.phrase.categoryId &&
            p.id != widget.phrase.id)
        .toList();
    final rng = Random();
    sameCategory.shuffle(rng);
    _relatedPhrases = sameCategory.take(12).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final historyProvider = context.read<HistoryProvider>();
    final l10n = AppLocalizations.of(context)!;

    historyProvider.add(widget.phrase.id);

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark
                ? RomanticColors.darkSurface
                : RomanticColors.lightSurface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 6),
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 9 / 16,
                          child: Image.asset(
                            'Imagenes/${widget.phrase.image}',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: RomanticColors.darkSurfaceAlt,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: 160,
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
                          height: 400,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.9),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 80,
                          left: 20,
                          right: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                CategoryTranslations.label(
                                        widget.phrase.categoryId,
                                        Localizations.localeOf(context))
                                    .toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white
                                      .withValues(alpha: 0.75),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                context
                                    .read<PhrasesProvider>()
                                    .getText(widget.phrase,
                                        Localizations.localeOf(context)),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children:
                                    widget.phrase.tags.map((tag) {
                                  return Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white
                                          .withValues(alpha: 0.15),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '#$tag',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 11,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 8,
                          right: 16,
                          child: GestureDetector(
                            onTap: () =>
                                Navigator.of(context).pop(),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black
                                    .withValues(alpha: 0.35),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: PhraseActions(
                            phrase: widget.phrase,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            l10n.masFrases,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 180,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  _relatedPhrases.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 10),
                              itemBuilder: (context, i) {
                                final p =
                                    _relatedPhrases[i];
                                return SizedBox(
                                  width: 130,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pop();
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled:
                                            true,
                                        backgroundColor:
                                            Colors
                                                .transparent,
                                        builder: (_) =>
                                            PhraseDetailModal(
                                                phrase: p),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius
                                              .circular(12),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.asset(
                                            'Imagenes/${p.image}',
                                            fit: BoxFit
                                                .cover,
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child:
                                                Container(
                                              padding:
                                                  const EdgeInsets
                                                      .all(
                                                      8),
                                              decoration:
                                                  BoxDecoration(
                                                gradient:
                                                    LinearGradient(
                                                  begin: Alignment
                                                      .topCenter,
                                                  end: Alignment
                                                      .bottomCenter,
                                                  colors: [
                                                    Colors
                                                        .transparent,
                                                    Colors
                                                        .black
                                                        .withValues(
                                                            alpha:
                                                                0.75),
                                                  ],
                                                ),
                                              ),
                                              child: Text(
                                                context
                                                    .read<
                                                        PhrasesProvider>()
                                                    .getText(
                                                        p,
                                                        Localizations
                                                            .localeOf(
                                                                context)),
                                                style:
                                                    const TextStyle(
                                                  color: Colors
                                                      .white,
                                                  fontSize:
                                                      10,
                                                  fontStyle:
                                                      FontStyle
                                                          .italic,
                                                ),
                                                maxLines: 3,
                                                overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
