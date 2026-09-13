import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ActionBtn(
            icon: isSaved
                ? Icons.favorite_rounded
                : Icons.favorite_outline_rounded,
            color: isSaved ? RomanticColors.romantic400 : Colors.white,
            onTap: () {
              HapticFeedback.lightImpact();
              favoritesProvider.toggle(phrase.id);
              context.read<ToastProvider>().show(
                    isSaved
                        ? l10n.eliminadaDeFavoritos
                        : l10n.guardadaEnFavoritos,
                    type: isSaved ? ToastType.info : ToastType.success,
                  );
            },
          ),
          _ActionBtn(
            icon: Icons.near_me_rounded,
            onTap: () async {
              HapticFeedback.lightImpact();
              final toast = context.read<ToastProvider>();
              toast.showInfo(l10n.preparandoParaCompartir);
              final translatedText = context
                  .read<PhrasesProvider>()
                  .getText(phrase, Localizations.localeOf(context));
              await exportAndShare(phrase, context, text: translatedText);
            },
          ),
          _ActionBtn(
            icon: Icons.arrow_downward_rounded,
            onTap: () async {
              HapticFeedback.lightImpact();
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
          _ActionBtn(
            icon: Icons.folder_open_rounded,
            onTap: () {
              HapticFeedback.lightImpact();
              _showAddToCollection(context);
            },
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

class _ActionBtn extends StatefulWidget {
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    this.color,
    required this.onTap,
  });

  @override
  State<_ActionBtn> createState() => _ActionBtnState();
}

class _ActionBtnState extends State<_ActionBtn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.color ?? Colors.white;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(9),
          child: Icon(
            widget.icon,
            color: effectiveColor,
            size: 22,
          ),
        ),
      ),
    );
  }
}
