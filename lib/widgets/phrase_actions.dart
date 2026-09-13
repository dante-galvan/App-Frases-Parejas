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

  const PhraseActions({
    super.key,
    required this.phrase,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final favoritesProvider = context.watch<FavoritesProvider>();
    final isSaved = favoritesProvider.isSaved(phrase.id);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _DetailAction(
            icon: isSaved ? Icons.favorite : Icons.favorite_outline,
            label: l10n.favorito,
            color: isSaved ? RomanticColors.romantic400 : Colors.white,
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
          _DetailAction(
            icon: Icons.share_rounded,
            label: l10n.compartir,
            onTap: () async {
              final toast = context.read<ToastProvider>();
              toast.showInfo(l10n.preparandoParaCompartir);
              final translatedText = context
                  .read<PhrasesProvider>()
                  .getText(phrase, Localizations.localeOf(context));
              await exportAndShare(phrase, context, text: translatedText);
            },
          ),
          _DetailAction(
            icon: Icons.download_rounded,
            label: l10n.descargar,
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
          _DetailAction(
            icon: Icons.bookmark_add_rounded,
            label: l10n.coleccion,
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

class _DetailAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const _DetailAction({
    required this.icon,
    required this.label,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Colors.white;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: effectiveColor,
            size: 22,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: effectiveColor,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
