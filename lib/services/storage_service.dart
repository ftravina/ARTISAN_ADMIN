import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  static const String bucketName = 'craft-images';

  final SupabaseClient supabase;

  StorageService(this.supabase);

  Future<String> uploadCraftImage({
    required String craftId,
    required File imageFile,
    required int imageIndex,
  }) async {
    try {
      final fileName = '${craftId}_${imageIndex}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = '$craftId/$fileName';

      await supabase.storage.from(bucketName).upload(
        filePath,
        imageFile,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
      );

      final imageUrl = supabase.storage.from(bucketName).getPublicUrl(filePath);
      return imageUrl;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadArtisanPhoto({
    required String artisanId,
    required File imageFile,
  }) async {
    try {
      final fileName = '${artisanId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = 'artisans/$fileName';

      await supabase.storage.from(bucketName).upload(
        filePath,
        imageFile,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
      );

      final imageUrl = supabase.storage.from(bucketName).getPublicUrl(filePath);
      return imageUrl;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteImage(String imagePath) async {
    try {
      await supabase.storage.from(bucketName).remove([imagePath]);
    } catch (e) {
      rethrow;
    }
  }
}
