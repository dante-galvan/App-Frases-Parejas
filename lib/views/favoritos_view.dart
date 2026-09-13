import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frases_amor_flutter/l10n/app_localizations.dart';
import '../state/phrases_provider.dart';
import '../state/favorites_provider.dart';
import '../state/collections_provider.dart';
import '../state/toast_provider.dart';
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

class _FavoritosViewState extends State<FavoritosView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
    final favoritesProvider = context.watch<FavoritesProvider>();
    final phrasesProvider = context.watch<PhrasesProvider>();
    final collectionsProvider = context.watch<CollectionsProvider>();
    final l10n = AppLocalizations.of(context)!;

    final savedPhrases = phrasesProvider.phrases
        .where((p) => favoritesProvider.savedIds.contains(p.id))
        .toList();

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          indicatorColor: RomanticColors.romantic600,
          labelColor: isDark ? Colors.white : const Color(0xFF1A1A1A),
          unselectedLabelColor: isDark ? Colors.white54 : Colors.black45,
          dividerColor: Colors.transparent,
          tabs: [
            Tab(text: l10n.favoritosCount(savedPhrases.length)),
            Tab(text: l10n.coleccionesCount(collectionsProvider.collections.length)),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _FavoritesTab(phrases: savedPhrases, isDark: isDark),
              _CollectionsTab(
                collections: collectionsProvider.collections,
                allPhrases: phrasesProvider.phrases,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FavoritesTab extends StatelessWidget {
  final List<Phrase> phrases;
  final bool isDark;

  const _FavoritesTab({required this.phrases, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final l10n = AppLocalizations.of(context)!;

    if (phrases.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_outline,
                size: 64, color: isDark ? Colors.white24 : Colors.black26),
            const SizedBox(height: 16),
            Text(
              l10n.sinFavoritos,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.tocaCorazon,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white38 : Colors.black38,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: phrases.length,
      itemBuilder: (context, i) {
        final phrase = phrases[i];
        return PhraseCard(
          phrase: phrase,
          isSaved: true,
          onTap: () => _openDetail(context, phrase),
          onSave: () => favoritesProvider.toggle(phrase.id),
        );
      },
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

class _CollectionsTab extends StatelessWidget {
  final List<CollectionItem> collections;
  final List<Phrase> allPhrases;
  final bool isDark;

  const _CollectionsTab({
    required this.collections,
    required this.allPhrases,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showCreateCollectionDialog(context),
              icon: const Icon(Icons.add, size: 20),
              label: Text(l10n.nuevaColeccion),
              style: OutlinedButton.styleFrom(
                foregroundColor: RomanticColors.romantic600,
                side: const BorderSide(color: RomanticColors.romantic600),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        Expanded(
          child: collections.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.collections_outlined,
                          size: 64,
                          color: isDark ? Colors.white24 : Colors.black26),
                      const SizedBox(height: 16),
                      Text(
                        l10n.sinColecciones,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.creaColeccion,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: collections.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final col = collections[i];
                    final coverPhrase = col.coverPhraseId != null
                        ? allPhrases
                            .where((p) => p.id == col.coverPhraseId)
                            .firstOrNull
                        : null;

                    return GestureDetector(
                      onTap: () => _showCollectionDetail(context, col),
                      child: Container(
                        height: 110,
                        decoration: BoxDecoration(
                          color: isDark
                              ? RomanticColors.darkSurfaceAlt
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? Colors.white12 : Colors.black12,
                          ),
                        ),
                        child: Row(
                          children: [
                            if (coverPhrase != null)
                              ClipRRect(
                                borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(15)),
                                child: SizedBox(
                                  width: 110,
                                  height: 110,
                                  child: Image.asset(
                                    'Imagenes/${coverPhrase.image}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            else
                              Container(
                                width: 110,
                                decoration: BoxDecoration(
                                  color: RomanticColors.romantic900,
                                  borderRadius: const BorderRadius.horizontal(
                                      left: Radius.circular(15)),
                                ),
                                child: const Icon(Icons.favorite,
                                    color: Colors.white30, size: 36),
                              ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      col.name,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF1A1A1A),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${col.phraseIds.length} ${l10n.frases}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark
                                            ? Colors.white54
                                            : Colors.black45,
                                      ),
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        TextButton(
                                          onPressed: () =>
                                              _showCollectionDetail(
                                                  context, col),
                                          style: TextButton.styleFrom(
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 4),
                                            minimumSize: Size.zero,
                                            tapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                          ),
                                          child: Text(l10n.ver,
                                              style:
                                                  const TextStyle(fontSize: 12)),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              _showEditCollectionDialog(
                                                  context, col),
                                          style: TextButton.styleFrom(
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 4),
                                            minimumSize: Size.zero,
                                            tapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                          ),
                                          child: Text(l10n.editar,
                                              style:
                                                  const TextStyle(fontSize: 12)),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              _confirmDeleteCollection(
                                                  context, col),
                                          style: TextButton.styleFrom(
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 4),
                                            minimumSize: Size.zero,
                                            tapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                          ),
                                          child: Text(l10n.eliminar,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: isDark
                                                      ? Colors.white54
                                                      : Colors.black45)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showCreateCollectionDialog(BuildContext context) {
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

  void _showEditCollectionDialog(BuildContext context, CollectionItem col) {
    final controller = TextEditingController(text: col.name);
    final collectionsProvider = context.read<CollectionsProvider>();
    final toast = context.read<ToastProvider>();
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.editarNombre),
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
                collectionsProvider.renameCollection(
                  col.id,
                  controller.text.trim(),
                );
                toast.showSuccess(l10n.coleccionCreada);
                Navigator.pop(context);
              }
            },
            child: Text(l10n.guardar),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteCollection(BuildContext context, CollectionItem col) {
    final collectionsProvider = context.read<CollectionsProvider>();
    final toast = context.read<ToastProvider>();
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.confirmarEliminar),
        content: Text(l10n.eliminarColeccionMensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancelar),
          ),
          TextButton(
            onPressed: () {
              collectionsProvider.deleteCollection(col.id);
              toast.showSuccess(l10n.eliminadaDeColeccion);
              Navigator.pop(context);
            },
            child: Text(l10n.eliminarColeccion,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showCollectionDetail(BuildContext context, CollectionItem col) {
    final phrasesProvider = context.read<PhrasesProvider>();
    final collectionsProvider = context.read<CollectionsProvider>();
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? RomanticColors.darkSurface
                : RomanticColors.lightSurface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.frasesEnColeccion(col.name),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                child: col.phraseIds.isEmpty
                    ? Center(
                        child: Text(
                          l10n.sinFavoritos,
                          style: TextStyle(
                            color: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? Colors.white54
                                : Colors.black45,
                          ),
                        ),
                      )
                    : ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: col.phraseIds.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final phraseId = col.phraseIds[i];
                          final phrase = phrasesProvider.getById(phraseId);
                          if (phrase == null) return const SizedBox.shrink();

                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: Image.asset(
                                  'Imagenes/${phrase.image}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(
                              phrasesProvider.getText(
                                  phrase, Localizations.localeOf(context)),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.remove_circle_outline,
                                  color: Colors.red),
                              onPressed: () =>
                                  collectionsProvider.togglePhraseInCollection(
                                      col.id, phrase.id),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
