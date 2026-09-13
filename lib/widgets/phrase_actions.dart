import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frases_amor_flutter/l10n/app_localizations.dart';
import '../models/phrase.dart';
import '../models/toast.dart';
import '../state/phrases_provider.dart';
import '../state/favorites_provider.dart';
import '../state/collections_provider.dart';
import '../state/toast_provider.dart';
import '../theme/app_colors.dart';
import '../utils/image_exporter.dart';

class PhraseActions extends StatelessWidget {
  final Phrase phrase;
  final bool showLabels;
  final bool isInsideDetail;

  const PhraseActions({
    super.key,
    required this.phrase,
    this.showLabels = true,
    this.isInsideDetail = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final favoritesProvider = context.watch<FavoritesProvider>();
    final isSaved = favoritesProvider.isSaved(phrase.id);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ActionItem(
            icon: isSaved ? Icons.favorite : Icons.favorite_outline,
            label: l10n.favorito,
            color: isSaved ? RomanticColors.romantic400 : Colors.white,
            isActive: isSaved,
            onTap: () {
              favoritesProvider.toggle(phrase.id);
              context.read<ToastProvider>().show(
                    isSaved
                        ? l10n.eliminadaDeFavoritos
                        : l10n.guardadaEnFavoritos,
                    type: isSaved ? ToastType.info : ToastType.success,
                  );
            },
          ),
          _ActionItem(
            icon: Icons.share_outlined,
            label: l10n.compartir,
            color: Colors.white,
            onTap: () async {
              final toast = context.read<ToastProvider>();
              toast.showInfo(l10n.preparandoParaCompartir);
              final translatedText = context
                  .read<PhrasesProvider>()
                  .getText(phrase, Localizations.localeOf(context));
              await exportAndShare(phrase, context, text: translatedText);
            },
          ),
          _ActionItem(
            icon: Icons.download_outlined,
            label: l10n.descargar,
            color: Colors.white,
            onTap: () async {
              final toast = context.read<ToastProvider>();
              toast.showInfo(l10n.generandoImagen);
              final translatedText = context
                  .read<PhrasesProvider>()
                  .getText(phrase, Localizations.localeOf(context));
              final ok = await exportPhraseImage(phrase, translatedText);
              if (ok) {
                toast.showSuccess(l10n.imagenGuardada);
              } else {
                toast.showError(l10n.noPudoGuardar);
              }
            },
          ),
          _ActionItem(
            icon: Icons.playlist_add,
            label: l10n.coleccion,
            color: Colors.white,
            onTap: () => _showAddToCollection(context),
          ),
        ],
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
                      subtitle: Text(
                          '${col.phraseIds.length} ${l10n.frases}'),
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

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.color,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isActive
                  ? RomanticColors.romantic600.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
