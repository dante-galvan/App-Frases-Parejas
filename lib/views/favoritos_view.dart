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
    final collectionsProvider = context.watch<CollectionsProvider>();
    final l10n = AppLocalizations.of(context)!;

    if (collections.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.collections_outlined,
                size: 64, color: isDark ? Colors.white24 : Colors.black26),
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
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: collections.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final col = collections[i];
        final coverPhrase = allPhrases
            .where((p) => col.phraseIds.contains(p.id))
            .toList();

        return Container(
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
              if (coverPhrase.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(15)),
                  child: SizedBox(
                    width: 110,
                    height: 110,
                    child: Image.asset(
                      'Imagenes/${coverPhrase.first.image}',
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
                          color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${col.phraseIds.length} ${l10n.frases}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white54 : Colors.black45,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              _showAddPhrasesDialog(context, col);
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(l10n.agregar,
                                style: const TextStyle(fontSize: 12)),
                          ),
                          TextButton(
                            onPressed: () =>
                                collectionsProvider.deleteCollection(col.id),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
        );
      },
    );
  }

  void _showAddPhrasesDialog(BuildContext context, CollectionItem col) {
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
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: phrasesProvider.phrases.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final phrase = phrasesProvider.phrases[i];
                    final isInCollection = col.phraseIds.contains(phrase.id);
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
                        phrase.text,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          isInCollection
                              ? Icons.check_circle
                              : Icons.add_circle_outline,
                          color: isInCollection
                              ? RomanticColors.romantic600
                              : null,
                        ),
                        onPressed: () => collectionsProvider
                            .togglePhraseInCollection(col.id, phrase.id),
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
