enum AspectRatioType { ratio9x16, ratio4x5, ratio1x1 }

extension AspectRatioTypeX on AspectRatioType {
  String get label {
    switch (this) {
      case AspectRatioType.ratio9x16:
        return '9:16';
      case AspectRatioType.ratio4x5:
        return '4:5';
      case AspectRatioType.ratio1x1:
        return '1:1';
    }
  }

  double get value {
    switch (this) {
      case AspectRatioType.ratio9x16:
        return 9 / 16;
      case AspectRatioType.ratio4x5:
        return 4 / 5;
      case AspectRatioType.ratio1x1:
        return 1.0;
    }
  }
}

class Phrase {
  final String id;
  final String text;
  final String image;
  final String category;
  final String categoryId;
  final String? subcategory;
  final String tone;
  final List<String> tags;
  final AspectRatioType ratio;
  final bool isFeaturedToday;
  final bool isTrending;
  final bool isNew;

  const Phrase({
    required this.id,
    required this.text,
    required this.image,
    required this.category,
    required this.categoryId,
    this.subcategory,
    this.tone = '',
    this.tags = const [],
    this.ratio = AspectRatioType.ratio9x16,
    this.isFeaturedToday = false,
    this.isTrending = false,
    this.isNew = false,
  });

  factory Phrase.fromJson(Map<String, dynamic> json) {
    final ratioStr = json['ratio'] as String? ?? '9:16';
    final ratio = AspectRatioType.values.firstWhere(
      (e) => e.label == ratioStr,
      orElse: () => AspectRatioType.ratio9x16,
    );
    return Phrase(
      id: json['id'] as String,
      text: json['text'] as String,
      image: json['image'] as String,
      category: json['category'] as String,
      categoryId: json['categoryId'] as String? ?? json['category'] as String,
      subcategory: json['subcategory'] as String?,
      tone: json['tone'] as String? ?? '',
      tags: (json['tags'] as List?)?.cast<String>() ?? const [],
      ratio: ratio,
      isFeaturedToday: json['isFeaturedToday'] as bool? ?? false,
      isTrending: json['isTrending'] as bool? ?? false,
      isNew: json['isNew'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'image': image,
        'category': category,
        'categoryId': categoryId,
        'subcategory': subcategory,
        'tone': tone,
        'tags': tags,
        'ratio': ratio.label,
        'isFeaturedToday': isFeaturedToday,
        'isTrending': isTrending,
        'isNew': isNew,
      };
}
