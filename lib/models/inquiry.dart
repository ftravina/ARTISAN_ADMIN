class Inquiry {
  final String id;
  final String userId;
  final String craftId;
  final String message;
  final DateTime createdAt;

  Inquiry({
    required this.id,
    required this.userId,
    required this.craftId,
    required this.message,
    required this.createdAt,
  });

  factory Inquiry.fromJson(Map<String, dynamic> json) {
    return Inquiry(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      craftId: json['craft_id'] as String,
      message: json['message'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'craft_id': craftId,
      'message': message,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
