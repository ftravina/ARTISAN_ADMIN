class Artisan {
  final String id;
  final String name;
  final String community;
  final String region;
  final String story;
  final String photoUrl;
  final DateTime createdAt;

  Artisan({
    required this.id,
    required this.name,
    required this.community,
    required this.region,
    required this.story,
    required this.photoUrl,
    required this.createdAt,
  });

  factory Artisan.fromJson(Map<String, dynamic> json) {
    return Artisan(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Unknown',
      community: json['community'] as String? ?? '',
      region: json['region'] as String? ?? '',
      story: json['story'] as String? ?? '',
      photoUrl: json['photo_url'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'community': community,
      'region': region,
      'story': story,
      'photo_url': photoUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
