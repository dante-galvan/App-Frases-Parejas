import 'dart:math';
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
import '../utils/category_translations.dart';

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
    final sameCategory = allPhrases.where((p) => p.categoryId == widget.phrase.categoryId && p.id != widget.phrase.id).toList();
    sameCategory.shuffle(Random());
    _relatedPhrases = sameCategory.take(12).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final favoritesProvider = context.watch<FavoritesProvider>();
    final historyProvider = context.read<HistoryProvider>();
    final isSaved = favoritesProvider.isSaved(widget.phrase.id);
    final l10n = AppLocalizations.of(context)!;
    final material = MaterialLocalizations.of(context);
    historyProvider.add(widget.phrase.id);

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(color: isDark ? RomanticColors.darkSurface : RomanticColors.lightSurface, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(children: [
          Padding(padding: const EdgeInsets.only(top: 10, bottom: 6), child: Container(width: 36, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
          Expanded(child: ListView(controller: scrollController, children: [
            Stack(children: [
              AspectRatio(aspectRatio: 9 / 16, child: Image.asset('Imagenes/${widget.phrase.image}', fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: RomanticColors.darkSurfaceAlt))),
              Positioned(top: 0, left: 0, right: 0, height: 160, child: DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withValues(alpha: 0.55), Colors.transparent])))),
              Positioned(bottom: 0, left: 0, right: 0, height: 350, child: DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withValues(alpha: 0.88)])))),
              Positioned(bottom: 32, left: 20, right: 20, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(CategoryTranslations.label(widget.phrase.categoryId, Localizations.localeOf(context)).toUpperCase(), style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 2)),
                const SizedBox(height: 10),
                Text(widget.phrase.text, style: const TextStyle(color: Colors.white, fontSize: 22, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500, height: 1.35)),
              ])),
              Positioned(top: MediaQuery.of(context).padding.top + 8, left: 12, right: 12, child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
                _ActionButton(icon: isSaved ? Icons.favorite_rounded : Icons.favorite_outline_rounded, label: isSaved ? l10n.eliminadaDeFavoritos : l10n.guardar, active: isSaved, onTap: () {
                  favoritesProvider.toggle(widget.phrase.id);
                  context.read<ToastProvider>().show(isSaved ? l10n.eliminadaDeFavoritos : l10n.guardadaEnFavoritos, type: isSaved ? ToastType.info : ToastType.success);
                }),
                const SizedBox(width: 8),
                _ActionButton(icon: Icons.share_rounded, label: material.shareButtonLabel, onTap: () async { await exportAndShare(widget.phrase, context); }),
                const SizedBox(width: 8),
                _ActionButton(icon: Icons.download_rounded, label: material.saveButtonLabel, onTap: () async {
                  final toast = context.read<ToastProvider>();
                  toast.showInfo(l10n.generandoImagen);
                  final ok = await exportPhraseImage(widget.phrase);
                  if (ok) toast.showSuccess(l10n.guardadaEnGaleria); else toast.showError(l10n.noPudoGuardar);
                }),
                const SizedBox(width: 8),
                _ActionButton(icon: Icons.bookmark_add_rounded, label: l10n.agregar, onTap: () => _showAddToCollection(context)),
              ]))),
            ]),
            Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l10n.masFrases, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF1A1A1A))),
              const SizedBox(height: 12),
              SizedBox(height: 180, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: _relatedPhrases.length, separatorBuilder: (_, __) => const SizedBox(width: 10), itemBuilder: (context, i) {
                final p = _relatedPhrases[i];
                return SizedBox(width: 130, child: GestureDetector(onTap: () { Navigator.of(context).pop(); showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (_) => PhraseDetailModal(phrase: p)); }, child: ClipRRect(borderRadius: BorderRadius.circular(12), child: Stack(fit: StackFit.expand, children: [
                  Image.asset('Imagenes/${p.image}', fit: BoxFit.cover),
                  Positioned(bottom: 0, left: 0, right: 0, child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withValues(alpha: 0.75)])), child: Text(p.text, style: const TextStyle(color: Colors.white, fontSize: 10, fontStyle: FontStyle.italic), maxLines: 3, overflow: TextOverflow.ellipsis))),
                ]))));
              })),
            ])),
          ])),
        ]),
      ),
    );
  }

  void _showAddToCollection(BuildContext context) {
    final collectionsProvider = context.read<CollectionsProvider>();
    final toast = context.read<ToastProvider>();
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(context: context, backgroundColor: Colors.transparent, builder: (_) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return Container(
        decoration: BoxDecoration(color: isDark ? RomanticColors.darkSurface : RomanticColors.lightSurface, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
        child: SafeArea(child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(padding: const EdgeInsets.fromLTRB(18, 18, 10, 10), child: Row(children: [Expanded(child: Text(l10n.agregarAColeccion, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800))), IconButton(onPressed: () { Navigator.pop(context); _showCreateCollection(context); }, icon: const Icon(Icons.add_circle_rounded))])),
          ...collectionsProvider.collections.map((col) {
            final isIn = col.phraseIds.contains(widget.phrase.id);
            return ListTile(
              leading: Icon(isIn ? Icons.check_circle_rounded : Icons.collections_bookmark_outlined, color: isIn ? RomanticColors.romantic600 : null),
              title: Text(col.name),
              subtitle: Text('${col.phraseIds.length} ${l10n.frases}'),
              onTap: () { collectionsProvider.togglePhraseInCollection(col.id, widget.phrase.id); toast.show(isIn ? l10n.eliminadaDeColeccion : l10n.agregadaAColeccion, type: ToastType.success); Navigator.pop(context); },
            );
          }),
          const SizedBox(height: 12),
        ])),
      );
    });
  }

  void _showCreateCollection(BuildContext context) {
    final controller = TextEditingController();
    final collectionsProvider = context.read<CollectionsProvider>();
    final toast = context.read<ToastProvider>();
    final l10n = AppLocalizations.of(context)!;
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text(l10n.nuevaColeccion),
      content: TextField(controller: controller, autofocus: true, decoration: InputDecoration(hintText: l10n.nombreColeccion, border: const OutlineInputBorder())),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancelar)), TextButton(onPressed: () { if (controller.text.trim().isNotEmpty) { collectionsProvider.createCollection(controller.text, phraseId: widget.phrase.id); toast.showSuccess(l10n.coleccionCreada); Navigator.pop(context); } }, child: Text(l10n.crear))],
    ));
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.label, this.active = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.black.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: active ? RomanticColors.romantic400 : Colors.white, size: 20), const SizedBox(width: 6), Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700))],
          ),
        ),
      ),
    );
  }
}
