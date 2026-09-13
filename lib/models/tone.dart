class ToneItem {
  final String id;
  final String name;
  final String slug;
  final String? badgeColor;

  const ToneItem({
    required this.id,
    required this.name,
    required this.slug,
    this.badgeColor,
  });

  factory ToneItem.fromJson(Map<String, dynamic> json) => ToneItem(
        id: json['id'] as String,
        name: json['name'] as String,
        slug: json['slug'] as String,
        badgeColor: json['badgeColor'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
        'badgeColor': badgeColor,
      };
}
