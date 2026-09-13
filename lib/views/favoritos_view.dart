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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : RomanticColors.romantic50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.favorite_outline,
                  size: 48,
                  color: isDark
                      ? RomanticColors.romantic300
                      : RomanticColors.romantic600,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.sinFavoritos,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.tocaCorazon,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.62,
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
              icon: const Icon(Icons.add_rounded, size: 20),
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
              ? _EmptyCollectionsState(isDark: isDark)
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  itemCount: collections.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final col = collections[i];
                    return _CollectionCard(
                      collection: col,
                      allPhrases: allPhrases,
                      isDark: isDark,
                      onTap: () => _showCollectionDetail(context, col),
                      onEdit: () =>
                          _showEditCollectionDialog(context, col),
                      onDelete: () =>
                          _confirmDeleteCollection(context, col),
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
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (_, scrollController) => Consumer<CollectionsProvider>(
          builder: (context, collectionsProv, _) {
            final updatedCol = collectionsProv.collections.firstWhere(
              (c) => c.id == col.id,
              orElse: () => col,
            );
            return Container(
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
                      l10n.frasesEnColeccion(updatedCol.name),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Expanded(
                    child: updatedCol.phraseIds.isEmpty
                        ? _EmptyCollectionDetail(isDark: isDark)
                        : ListView.separated(
                            controller: scrollController,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: updatedCol.phraseIds.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, i) {
                              final phraseId = updatedCol.phraseIds[i];
                              final phrase =
                                  phrasesProvider.getById(phraseId);
                              if (phrase == null) {
                                return const SizedBox.shrink();
                              }

                              return Container(
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white
                                          .withValues(alpha: 0.05)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isDark
                                        ? Colors.white
                                            .withValues(alpha: 0.08)
                                        : Colors.black
                                            .withValues(alpha: 0.06),
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: SizedBox(
                                      width: 48,
                                      height: 48,
                                      child: Image.asset(
                                        'Imagenes/${phrase.image}',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    phrasesProvider.getText(phrase,
                                        Localizations.localeOf(context)),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.red,
                                        size: 22),
                                    onPressed: () => collectionsProv
                                        .togglePhraseInCollection(
                                            updatedCol.id, phrase.id),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EmptyCollectionsState extends StatelessWidget {
  final bool isDark;

  const _EmptyCollectionsState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : RomanticColors.romantic50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_stories_rounded,
                size: 48,
                color: isDark
                    ? RomanticColors.romantic300
                    : RomanticColors.romantic600,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.sinColecciones,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.creaColeccion,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCollectionDetail extends StatelessWidget {
  final bool isDark;

  const _EmptyCollectionDetail({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : RomanticColors.romantic50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.format_quote_rounded,
                size: 36,
                color: isDark
                    ? RomanticColors.romantic300
                    : RomanticColors.romantic600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.sinFavoritos,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.tocaCorazon,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                color: isDark ? Colors.white38 : Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final CollectionItem collection;
  final List<Phrase> allPhrases;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CollectionCard({
    required this.collection,
    required this.allPhrases,
    required this.isDark,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final coverPhrase = collection.coverPhraseId != null
        ? allPhrases
            .where((p) => p.id == collection.coverPhraseId)
            .firstOrNull
        : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color:
              isDark ? RomanticColors.darkSurfaceAlt : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (coverPhrase != null)
                Positioned.fill(
                  child: Image.asset(
                    'Imagenes/${coverPhrase.image}',
                    fit: BoxFit.cover,
                  ),
                )
              else
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          RomanticColors.romantic800,
                          RomanticColors.romantic600,
                        ],
                      ),
                    ),
                  ),
                ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black.withValues(alpha: 0.75),
                        Colors.black.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 0,
                bottom: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      coverPhrase != null
                          ? Icons.format_quote_rounded
                          : Icons.auto_stories_rounded,
                      color: Colors.white.withValues(alpha: 0.9),
                      size: 28,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      collection.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${collection.phraseIds.length} ${l10n.frases}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 8,
                top: 0,
                bottom: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _CircleIconBtn(
                      icon: Icons.edit_outlined,
                      onTap: onEdit,
                    ),
                    const SizedBox(height: 6),
                    _CircleIconBtn(
                      icon: Icons.delete_outline,
                      onTap: onDelete,
                      isDestructive: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDestructive;

  const _CircleIconBtn({
    required this.icon,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive
              ? Colors.red.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color: isDestructive
              ? Colors.red.withValues(alpha: 0.9)
              : Colors.white.withValues(alpha: 0.9),
        ),
      ),
    );
  }
}
