class Craft {
  final String id;
  final String artisanId;
  final String name;
  final String material;
  final double price;
  final String description;
  final String imageUrl;
  final String status;
  final DateTime createdAt;
  final List<String>? imageUrls;

  Craft({
    required this.id,
    required this.artisanId,
    required this.name,
    required this.material,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.status,
    required this.createdAt,
    this.imageUrls,
  });

  factory Craft.fromJson(Map<String, dynamic> json) {
    // will get the image_urls array from database
    final imageUrlsList = json['image_urls'] as List?;
    final firstImageUrl = (imageUrlsList != null && imageUrlsList.isNotEmpty)
        ? imageUrlsList.first.toString()
        : '';

    return Craft(
      id: json['id'] as String,
      artisanId: json['artisan_id'] as String,
      name: json['name'] as String? ?? 'Unknown',
      material: json['material'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      imageUrl: firstImageUrl,
      status: json['status'] as String? ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      imageUrls: imageUrlsList != null
          ? List<String>.from(imageUrlsList.map((e) => e.toString()))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'artisan_id': artisanId,
      'name': name,
      'material': material,
      'price': price,
      'description': description,
      'image_urls': imageUrl.isNotEmpty ? [imageUrl] : [], // Store as array
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
