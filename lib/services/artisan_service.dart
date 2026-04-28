import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/artisan.dart';
import '../config/supabase_config.dart';

class ArtisanService {
  final SupabaseClient _supabase;

  ArtisanService(this._supabase);

  /// Converts a stored image path/URL to a proper Supabase public URL
  String _getPublicImageUrl(String imageUrl) {
    if (imageUrl.isEmpty) return '';
    if (imageUrl.startsWith('http')) {
      return imageUrl; // Already a full URL
    }
    // Handle case where photo_url might be a storage path
    // Check if it already contains the bucket name
    if (imageUrl.contains('artisan-photos')) {
      return '$supabaseUrl/storage/v1/object/public/$imageUrl';
    }
    // If it's just a filename or relative path, construct the full public URL
    return '$supabaseUrl/storage/v1/object/public/artisan-photos/$imageUrl';
  }

  Future<List<Artisan>> fetchArtisans() async {
    try {
      final response = await _supabase.from('artisans').select();
      return (response as List).map((e) {
        final artisan = Artisan.fromJson(e);
        // Ensure photoUrl is a full public URL
        return Artisan(
          id: artisan.id,
          name: artisan.name,
          community: artisan.community,
          region: artisan.region,
          story: artisan.story,
          photoUrl: artisan.photoUrl.isNotEmpty
              ? _getPublicImageUrl(artisan.photoUrl)
              : '',
          createdAt: artisan.createdAt,
        );
      }).toList();
    } catch (e) {
      print('Error fetching artisans: $e');
      rethrow;
    }
  }

  Future<Artisan?> fetchArtisanById(String id) async {
    try {
      final response =
          await _supabase.from('artisans').select().eq('id', id).single();
      final artisan = Artisan.fromJson(response);
      // Ensure photoUrl is a full public URL
      return Artisan(
        id: artisan.id,
        name: artisan.name,
        community: artisan.community,
        region: artisan.region,
        story: artisan.story,
        photoUrl: artisan.photoUrl.isNotEmpty
            ? _getPublicImageUrl(artisan.photoUrl)
            : '',
        createdAt: artisan.createdAt,
      );
    } catch (e) {
      print('Error fetching artisan: $e');
      return null;
    }
  }

  Future<Artisan> createArtisan(Artisan artisan) async {
    try {
      final response = await _supabase
          .from('artisans')
          .insert(artisan.toJson())
          .select()
          .single();
      return Artisan.fromJson(response);
    } catch (e) {
      print('Error creating artisan: $e');
      rethrow;
    }
  }

  Future<void> updateArtisan(String id, Artisan artisan) async {
    try {
      await _supabase.from('artisans').update(artisan.toJson()).eq('id', id);
    } catch (e) {
      print('Error updating artisan: $e');
      rethrow;
    }
  }

  Future<void> deleteArtisan(String id) async {
    try {
      await _supabase.from('artisans').delete().eq('id', id);
    } catch (e) {
      print('Error deleting artisan: $e');
      rethrow;
    }
  }
}
