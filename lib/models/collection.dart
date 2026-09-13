class CollectionItem {
  final String id;
  final String name;
  final String? description;
  final List<String> phraseIds;
  final String createdAt;
  final String? coverPhraseId;

  const CollectionItem({
    required this.id,
    required this.name,
    this.description,
    required this.phraseIds,
    required this.createdAt,
    this.coverPhraseId,
  });

  CollectionItem copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? phraseIds,
    String? createdAt,
    String? coverPhraseId,
  }) {
    return CollectionItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      phraseIds: phraseIds ?? this.phraseIds,
      createdAt: createdAt ?? this.createdAt,
      coverPhraseId: coverPhraseId ?? this.coverPhraseId,
    );
  }

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
        'name': name,
        'description': description,
        'phraseIds': phraseIds,
        'createdAt': createdAt,
        'coverPhraseId': coverPhraseId,
      };
}
