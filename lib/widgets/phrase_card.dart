import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frases_amor_flutter/l10n/app_localizations.dart';
import '../models/phrase.dart';
import '../models/toast.dart';
import '../state/phrases_provider.dart';
import '../state/collections_provider.dart';
import '../state/toast_provider.dart';
import '../theme/app_colors.dart';
import '../utils/category_translations.dart';
import '../utils/image_exporter.dart';

class PhraseCard extends StatelessWidget {
  final Phrase phrase;
  final bool isSaved;
  final VoidCallback onTap;
  final VoidCallback onSave;

  const PhraseCard({
    super.key,
    required this.phrase,
    required this.isSaved,
    required this.onTap,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'Imagenes/${phrase.image}',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: RomanticColors.darkSurfaceAlt,
                  child: const Icon(Icons.image, color: Colors.white24),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 70,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.4),
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
                height: 160,
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
              if (phrase.isFeaturedToday || phrase.isTrending || phrase.isNew)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: phrase.isFeaturedToday
                          ? RomanticColors.romantic700
                          : phrase.isTrending
                              ? Colors.black54
                              : RomanticColors.romantic500,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      phrase.isFeaturedToday
                          ? l10n.destacada
                          : phrase.isTrending
                              ? l10n.trending
                              : l10n.nueva,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSaved ? Icons.favorite : Icons.favorite_outline,
                    color:
                        isSaved ? RomanticColors.romantic400 : Colors.white70,
                    size: 12,
                  ),
                ),
              ),
              Positioned(
                bottom: 54,
                left: 10,
                right: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      CategoryTranslations.label(
                          phrase.categoryId, Localizations.localeOf(context)),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context
                          .read<PhrasesProvider>()
                          .getText(phrase, Localizations.localeOf(context)),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ActionCircleButton(
                        icon: isSaved
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        isActive: isSaved,
                        activeColor: RomanticColors.romantic400,
                        onTap: onSave,
                      ),
                      _ActionCircleButton(
                        icon: Icons.share_rounded,
                        onTap: () async {
                          final toast = context.read<ToastProvider>();
                          toast.showInfo(l10n.preparandoParaCompartir);
                          final text = context
                              .read<PhrasesProvider>()
                              .getText(
                                  phrase, Localizations.localeOf(context));
                          await exportAndShare(phrase, context, text: text);
                        },
                      ),
                      _ActionCircleButton(
                        icon: Icons.download_rounded,
                        onTap: () async {
                          final toast = context.read<ToastProvider>();
                          toast.showInfo(l10n.generandoImagen);
                          final text = context
                              .read<PhrasesProvider>()
                              .getText(
                                  phrase, Localizations.localeOf(context));
                          final ok =
                              await exportPhraseImage(phrase, text);
                          if (ok) {
                            toast.showSuccess(l10n.imagenGuardada);
                          } else {
                            toast.showError(l10n.noPudoGuardar);
                          }
                        },
                      ),
                      _ActionCircleButton(
                        icon: Icons.bookmark_add_rounded,
                        onTap: () => _showAddToCollection(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddToCollection(BuildContext context) {
    final collectionsProvider = context.read<CollectionsProvider>();
    final toast = context.read<ToastProvider>();
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? RomanticColors.darkSurface
                : RomanticColors.lightSurface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.agregarAColeccion,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showCreateCollection(context);
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(l10n.nuevaColeccion),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: collectionsProvider.collections.length,
                  itemBuilder: (context, index) {
                    final col = collectionsProvider.collections[index];
                    final isIn = col.phraseIds.contains(phrase.id);
                    return ListTile(
                      leading: Icon(
                        isIn
                            ? Icons.check_circle
                            : Icons.add_circle_outline,
                        color: isIn ? RomanticColors.romantic600 : null,
                      ),
                      title: Text(col.name),
                      subtitle:
                          Text('${col.phraseIds.length} ${l10n.frases}'),
                      onTap: () {
                        collectionsProvider.togglePhraseInCollection(
                            col.id, phrase.id);
                        toast.show(
                          isIn
                              ? l10n.eliminadaDeColeccion
                              : l10n.agregadaAColeccion,
                          type: ToastType.success,
                        );
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showCreateCollection(BuildContext context) {
    final controller = TextEditingController();
    final collectionsProvider = context.read<CollectionsProvider>();
    final toast = context.read<ToastProvider>();
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.nuevaColeccion),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: l10n.nombreColeccion,
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancelar),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                collectionsProvider.createCollection(
                  controller.text.trim(),
                  phraseId: phrase.id,
                );
                toast.showSuccess(l10n.coleccionCreada);
                Navigator.pop(context);
              }
            },
            child: Text(l10n.crear),
          ),
        ],
      ),
    );
  }
}

class _ActionCircleButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final Color? activeColor;
  final VoidCallback onTap;

  const _ActionCircleButton({
    required this.icon,
    this.isActive = false,
    this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive && activeColor != null ? activeColor! : Colors.white;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.22),
              Colors.white.withValues(alpha: 0.08),
            ],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: 17,
        ),
      ),
    );
  }
}
