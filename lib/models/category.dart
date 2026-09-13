class CategoryItem {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String coverImage;
  final int count;

  const CategoryItem({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.coverImage,
    required this.count,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) => CategoryItem(
        id: json['id'] as String,
        name: json['name'] as String,
        slug: json['slug'] as String,
        description: json['description'] as String? ?? '',
        coverImage: json['coverImage'] as String? ?? '',
        count: json['count'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
        'description': description,
        'coverImage': coverImage,
        'count': count,
      };
}
