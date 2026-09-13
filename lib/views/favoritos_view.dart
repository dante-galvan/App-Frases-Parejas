import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frases_amor_flutter/l10n/app_localizations.dart';
import '../state/phrases_provider.dart';
import '../state/favorites_provider.dart';
import '../state/collections_provider.dart';
import '../models/phrase.dart';
import '../models/collection.dart';
import '../theme/app_colors.dart';
import '../widgets/phrase_card.dart';
import '../widgets/phrase_detail_modal.dart';

class FavoritosView extends StatefulWidget {
  const FavoritosView({super.key});

  @override
  State<FavoritosView> createState() => _FavoritosViewState();
}

class _FavoritosViewState extends State<FavoritosView> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final favorites = context.watch<FavoritesProvider>();
    final phrases = context.watch<PhrasesProvider>();
    final collections = context.watch<CollectionsProvider>();
    final l10n = AppLocalizations.of(context)!;
    final saved = phrases.phrases.where((p) => favorites.savedIds.contains(p.id)).toList();

    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        child: TabBar(
          controller: _tabController,
          indicatorColor: RomanticColors.romantic600,
          labelColor: isDark ? Colors.white : const Color(0xFF1A1A1A),
          unselectedLabelColor: isDark ? Colors.white54 : Colors.black45,
          dividerColor: Colors.transparent,
          tabs: [
            Tab(text: l10n.favoritosCount(saved.length)),
            Tab(text: l10n.coleccionesCount(collections.collections.length)),
          ],
        ),
      ),
      Expanded(child: TabBarView(
        controller: _tabController,
        children: [
          _FavoritesTab(phrases: saved, isDark: isDark),
          _CollectionsTab(collections: collections.collections, allPhrases: phrases.phrases, isDark: isDark),
        ],
      )),
    ]);
  }
}

class _FavoritesTab extends StatelessWidget {
  final List<Phrase> phrases;
  final bool isDark;
  const _FavoritesTab({required this.phrases, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoritesProvider>();
    final l10n = AppLocalizations.of(context)!;
    if (phrases.isEmpty) {
      return Center(child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.favorite_outline_rounded, size: 64, color: isDark ? Colors.white24 : Colors.black26),
          const SizedBox(height: 16),
          Text(l10n.sinFavoritos, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: isDark ? Colors.white70 : Colors.black60)),
          const SizedBox(height: 8),
          Text(l10n.tocaCorazon, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: isDark ? Colors.white38 : Colors.black45)),
        ]),
      ));
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.68, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemCount: phrases.length,
      itemBuilder: (context, i) {
        final phrase = phrases[i];
        return PhraseCard(
          phrase: phrase,
          isSaved: true,
          onTap: () => _openDetail(context, phrase),
          onSave: () => provider.toggle(phrase.id),
        );
      },
    );
  }

  void _openDetail(BuildContext context, Phrase phrase) {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (_) => PhraseDetailModal(phrase: phrase));
  }
}

class _CollectionsTab extends StatelessWidget {
  final List<CollectionItem> collections;
  final List<Phrase> allPhrases;
  final bool isDark;
  const _CollectionsTab({required this.collections, required this.allPhrases, required this.isDark});

  String _collectionName(BuildContext context, CollectionItem col) {
    final locale = Localizations.localeOf(context).languageCode;
    switch (col.id) {
      case 'col-1':
        return {'es':'Para ella','en':'For her','pt':'Para ela','fr':'Pour elle','it':'Per lei','de':'Für sie'}[locale] ?? col.name;
      case 'col-2':
        return {'es':'Mis favoritas','en':'My favorites','pt':'Minhas favoritas','fr':'Mes favorites','it':'Le mie preferite','de':'Meine Favoriten'}[locale] ?? col.name;
      case 'col-3':
        return {'es':'Buenos días y noches','en':'Good mornings & nights','pt':'Bons dias e noites','fr':'Bons matins et nuits','it':'Buongiorno e buonanotte','de':'Guten Morgen & gute Nacht'}[locale] ?? col.name;
      default:
        return col.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CollectionsProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Stack(children: [
      collections.isEmpty
          ? Center(child: Text(l10n.sinColecciones))
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              itemCount: collections.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) => _collectionCard(context, provider, collections[i]),
            ),
      Positioned(
        right: 20,
        bottom: 20,
        child: FloatingActionButton.extended(
          onPressed: () => _showCreateCollection(context),
          icon: const Icon(Icons.add_rounded),
          label: Text(l10n.crear),
        ),
      ),
    ]);
  }

  Widget _collectionCard(BuildContext context, CollectionsProvider provider, CollectionItem col) {
    final l10n = AppLocalizations.of(context)!;
    final cover = allPhrases.where((p) => col.phraseIds.contains(p.id)).toList();
    final name = _collectionName(context, col);
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openCollection(context, col),
        child: SizedBox(height: 112, child: Row(children: [
          SizedBox(width: 112, height: 112, child: cover.isNotEmpty
              ? Image.asset('Imagenes/${cover.first.image}', fit: BoxFit.cover)
              : Container(color: RomanticColors.romantic900, child: const Icon(Icons.collections_bookmark_rounded, color: Colors.white54, size: 34))),
          Expanded(child: Padding(padding: const EdgeInsets.fromLTRB(14, 10, 8, 8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
              PopupMenuButton<String>(
                tooltip: l10n.ajustes,
                onSelected: (value) {
                  if (value == 'edit') _showRenameCollection(context, col);
                  if (value == 'delete') _confirmDelete(context, col);
                },
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'edit', child: ListTile(leading: const Icon(Icons.edit_outlined), title: Text(l10n.editarIntereses), contentPadding: EdgeInsets.zero)),
                  PopupMenuItem(value: 'delete', child: ListTile(leading: const Icon(Icons.delete_outline), title: Text(l10n.eliminar), contentPadding: EdgeInsets.zero)),
                ],
              ),
            ]),
            const SizedBox(height: 4),
            Text('${col.phraseIds.length} ${l10n.frases}', style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black45)),
            const Spacer(),
            Text(l10n.agregar, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: RomanticColors.romantic600)),
          ]))),
        ])),
      ),
    );
  }

  void _openCollection(BuildContext context, CollectionItem col) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.72,
        maxChildSize: 0.92,
        minChildSize: 0.45,
        builder: (context, controller) {
          final current = context.watch<CollectionsProvider>().collections.firstWhere((c) => c.id == col.id, orElse: () => col);
          final items = allPhrases.where((p) => current.phraseIds.contains(p.id)).toList();
          return Container(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
            child: Column(children: [
              Padding(padding: const EdgeInsets.fromLTRB(20, 18, 12, 12), child: Row(children: [
                Expanded(child: Text(_collectionName(context, current), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800))),
                IconButton(onPressed: () => _showAddPhrasesDialog(context, current), icon: const Icon(Icons.add_circle_outline_rounded), tooltip: AppLocalizations.of(context)!.agregar),
              ])),
              Expanded(child: items.isEmpty
                  ? Center(child: Text(AppLocalizations.of(context)!.noHayFrases))
                  : ListView.separated(controller: controller, padding: const EdgeInsets.all(16), itemCount: items.length, separatorBuilder: (_, __) => const SizedBox(height: 8), itemBuilder: (context, i) {
                      final phrase = items[i];
                      return ListTile(
                        leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset('Imagenes/${phrase.image}', width: 52, height: 52, fit: BoxFit.cover)),
                        title: Text(phrase.text, maxLines: 2, overflow: TextOverflow.ellipsis),
                        trailing: IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => context.read<CollectionsProvider>().togglePhraseInCollection(current.id, phrase.id)),
                        onTap: () { Navigator.pop(context); showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (_) => PhraseDetailModal(phrase: phrase)); },
                      );
                    }),
            ]),
          );
        },
      ),
    );
  }

  void _showAddPhrasesDialog(BuildContext context, CollectionItem col) {
    final provider = context.read<CollectionsProvider>();
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.75, maxChildSize: 0.95, minChildSize: 0.45,
      builder: (context, controller) => Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(children: [
          Padding(padding: const EdgeInsets.all(18), child: Text(AppLocalizations.of(context)!.agregarAColeccion, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800))),
          Expanded(child: ListView.separated(controller: controller, padding: const EdgeInsets.all(16), itemCount: allPhrases.length, separatorBuilder: (_, __) => const SizedBox(height: 6), itemBuilder: (context, i) {
            final phrase = allPhrases[i];
            final inCollection = col.phraseIds.contains(phrase.id);
            return ListTile(
              leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset('Imagenes/${phrase.image}', width: 50, height: 50, fit: BoxFit.cover)),
              title: Text(phrase.text, maxLines: 2, overflow: TextOverflow.ellipsis),
              trailing: Icon(inCollection ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded, color: inCollection ? RomanticColors.romantic600 : null),
              onTap: () => provider.togglePhraseInCollection(col.id, phrase.id),
            );
          })),
        ]),
      ),
    ));
  }

  void _showCreateCollection(BuildContext context) {
    final controller = TextEditingController();
    final provider = context.read<CollectionsProvider>();
    final l10n = AppLocalizations.of(context)!;
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text(l10n.nuevaColeccion),
      content: TextField(controller: controller, autofocus: true, decoration: InputDecoration(labelText: l10n.nombreColeccion, border: const OutlineInputBorder())),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancelar)), TextButton(onPressed: () { provider.createCollection(controller.text); Navigator.pop(context); }, child: Text(l10n.crear))],
    ));
  }

  void _showRenameCollection(BuildContext context, CollectionItem col) {
    final controller = TextEditingController(text: col.name);
    final provider = context.read<CollectionsProvider>();
    final l10n = AppLocalizations.of(context)!;
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text(l10n.nuevaColeccion),
      content: TextField(controller: controller, autofocus: true, decoration: InputDecoration(labelText: l10n.nombreColeccion, border: const OutlineInputBorder())),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancelar)), TextButton(onPressed: () { provider.renameCollection(col.id, controller.text); Navigator.pop(context); }, child: Text(l10n.guardar))],
    ));
  }

  void _confirmDelete(BuildContext context, CollectionItem col) {
    final provider = context.read<CollectionsProvider>();
    final l10n = AppLocalizations.of(context)!;
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text(l10n.eliminar),
      content: Text('${_collectionName(context, col)}?'),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancelar)), TextButton(onPressed: () { provider.deleteCollection(col.id); Navigator.pop(context); }, child: Text(l10n.eliminar))],
    ));
  }
}
