import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frases_amor_flutter/l10n/app_localizations.dart';
import '../models/phrase.dart';
import '../models/toast.dart';
import '../state/phrases_provider.dart';
import '../state/favorites_provider.dart';
import '../state/history_provider.dart';
import '../state/collections_provider.dart';
import '../state/toast_provider.dart';
import '../theme/app_colors.dart';
import '../utils/image_exporter.dart';

class PhraseDetailModal extends StatelessWidget {
  final Phrase phrase;

  const PhraseDetailModal({super.key, required this.phrase});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final favoritesProvider = context.watch<FavoritesProvider>();
    final historyProvider = context.read<HistoryProvider>();
    final phrasesProvider = context.read<PhrasesProvider>();
    final isSaved = favoritesProvider.isSaved(phrase.id);
    final l10n = AppLocalizations.of(context)!;

    historyProvider.add(phrase.id);

    final allPhrases = phrasesProvider.phrases;

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? RomanticColors.darkSurface : RomanticColors.lightSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                            'Imagenes/${phrase.image}',
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
                          height: 350,
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
                          bottom: 32,
                          left: 20,
                          right: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                phrase.category.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.75),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                phrase.text,
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
                                children: phrase.tags.map((tag) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(20),
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
                          child: Row(
                            children: [
                              _CircleButton(
                                icon: isSaved
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
                                color: isSaved
                                    ? RomanticColors.romantic400
                                    : Colors.white,
                                onTap: () {
                                  favoritesProvider.toggle(phrase.id);
                                  context.read<ToastProvider>().show(
                                        isSaved
                                            ? l10n.eliminadaDeFavoritos
                                            : l10n.guardadaEnFavoritos,
                                        type: isSaved
                                            ? ToastType.info
                                            : ToastType.success,
                                      );
                                },
                              ),
                              const SizedBox(width: 8),
                              _CircleButton(
                                icon: Icons.share,
                                onTap: () async {
                                  await exportAndShare(phrase, context);
                                },
                              ),
                              const SizedBox(width: 8),
                              _CircleButton(
                                icon: Icons.download,
                                onTap: () async {
                                  final toast = context.read<ToastProvider>();
                                  toast.showInfo(l10n.generandoImagen);
                                  final ok = await exportPhraseImage(phrase);
                                  if (ok) {
                                    toast.showSuccess(l10n.guardadaEnGaleria);
                                  } else {
                                    toast.showError(l10n.noPudoGuardar);
                                  }
                                },
                              ),
                              const SizedBox(width: 8),
                              _CircleButton(
                                icon: Icons.bookmark_add_outlined,
                                onTap: () => _showAddToCollection(context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                              itemCount: allPhrases.length.clamp(0, 10),
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 10),
                              itemBuilder: (context, i) {
                                final p = allPhrases[i];
                                if (p.id == phrase.id) return const SizedBox();
                                return SizedBox(
                                  width: 130,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (_) =>
                                            PhraseDetailModal(phrase: p),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.asset(
                                            'Imagenes/${p.image}',
                                            fit: BoxFit.cover,
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.transparent,
                                                    Colors.black
                                                        .withValues(alpha: 0.75),
                                                  ],
                                                ),
                                              ),
                                              child: Text(
                                                p.text,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
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
                      style:
                          const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        Navigator.pop(context);
                        _showCreateCollection(context);
                      },
                    ),
                  ],
                ),
              ),
              ...collectionsProvider.collections.map((col) {
                final isIn =
                    col.phraseIds.contains(phrase.id);
                return ListTile(
                    leading: Icon(
                      isIn ? Icons.check_circle : Icons.collections_bookmark_outlined,
                      color: isIn ? RomanticColors.romantic600 : null,
                    ),
                  title: Text(col.name),
                  subtitle: Text('${col.phraseIds.length} ${l10n.frases}'),
                  onTap: () {
                    collectionsProvider.togglePhraseInCollection(col.id, phrase.id);
                    toast.show(
                      isIn ? l10n.eliminadaDeColeccion : l10n.agregadaAColeccion,
                      type: ToastType.success,
                    );
                    Navigator.pop(context);
                  },
                );
              }),
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

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color ?? Colors.white, size: 20),
      ),
    );
  }
}
