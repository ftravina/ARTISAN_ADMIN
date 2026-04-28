class CraftImage {
  final String id;
  final String craftId;
  final String imageUrl;
  final int orderIndex;
  final DateTime createdAt;

  CraftImage({
    required this.id,
    required this.craftId,
    required this.imageUrl,
    required this.orderIndex,
    required this.createdAt,
  });

  factory CraftImage.fromJson(Map<String, dynamic> json) {
    return CraftImage(
      id: json['id'] as String,
      craftId: json['craft_id'] as String,
      imageUrl: json['image_url'] as String? ?? '',
      orderIndex: json['order_index'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'craft_id': craftId,
      'image_url': imageUrl,
      'order_index': orderIndex,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
