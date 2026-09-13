import '../utils/phrase_translations.dart';

class CollectionItem {
  final String id;
  final String sourceName;
  final String? description;
  final List<String> phraseIds;
  final String createdAt;
  final String? coverPhraseId;

  const CollectionItem({required this.id, required String name, this.description, required this.phraseIds, required this.createdAt, this.coverPhraseId}) : sourceName = name;

  String get name {
    final lang = PhraseTranslations.language;
    if (id == 'col-1' && sourceName == 'Para ella') return {'es':'Para ella','en':'For her','pt':'Para ela','fr':'Pour elle','it':'Per lei','de':'Für sie'}[lang] ?? sourceName;
    if (id == 'col-2' && sourceName == 'Mis favoritas') return {'es':'Mis favoritas','en':'My favorites','pt':'Minhas favoritas','fr':'Mes favorites','it':'Le mie preferite','de':'Meine Favoriten'}[lang] ?? sourceName;
    if (id == 'col-3' && (sourceName == 'Buenos días y noches' || sourceName == 'Buenos dias y noches')) return {'es':'Buenos días y noches','en':'Good mornings & nights','pt':'Bons dias e noites','fr':'Bons matins et nuits','it':'Buongiorno e buonanotte','de':'Guten Morgen & gute Nacht'}[lang] ?? sourceName;
    return sourceName;
  }

  CollectionItem copyWith({String? id, String? name, String? description, List<String>? phraseIds, String? createdAt, String? coverPhraseId}) => CollectionItem(
    id: id ?? this.id,
    name: name ?? sourceName,
    description: description ?? this.description,
    phraseIds: phraseIds ?? this.phraseIds,
    createdAt: createdAt ?? this.createdAt,
    coverPhraseId: coverPhraseId ?? this.coverPhraseId,
  );

  factory CollectionItem.fromJson(Map<String, dynamic> json) => CollectionItem(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String?,
    phraseIds: (json['phraseIds'] as List?)?.cast<String>() ?? const [],
    createdAt: json['createdAt'] as String? ?? '',
    coverPhraseId: json['coverPhraseId'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': sourceName,
    'description': description,
    'phraseIds': phraseIds,
    'createdAt': createdAt,
    'coverPhraseId': coverPhraseId,
  };
}
