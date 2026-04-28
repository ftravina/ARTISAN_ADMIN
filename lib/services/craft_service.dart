import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import '../models/craft.dart';
import '../config/supabase_config.dart';

class CraftService {
  final SupabaseClient _supabase;

  CraftService(this._supabase);

  /// Converts a stored image path/URL to a proper Supabase public URL
  String _getPublicImageUrl(String imageUrl) {
    if (imageUrl.isEmpty) return '';
    // URLs in database should already be complete Supabase public URLs
    if (imageUrl.startsWith('http')) {
      return imageUrl; // Already a full URL from database
    }
    // Fallback: If for some reason it's just a filename
    if (imageUrl.contains('craft-images')) {
      return '$supabaseUrl/storage/v1/object/public/$imageUrl';
    }
    return '$supabaseUrl/storage/v1/object/public/craft-images/$imageUrl';
  }

  Future<List<Craft>> fetchCrafts() async {
    try {
      final response = await _supabase.from('crafts').select();
      return (response as List).map((e) {
        final craft = Craft.fromJson(e);
        // Ensure imageUrl is a full public URL
        return Craft(
          id: craft.id,
          artisanId: craft.artisanId,
          name: craft.name,
          material: craft.material,
          price: craft.price,
          description: craft.description,
          imageUrl: craft.imageUrl.isNotEmpty
              ? _getPublicImageUrl(craft.imageUrl)
              : '',
          status: craft.status,
          createdAt: craft.createdAt,
          imageUrls: craft.imageUrls,
        );
      }).toList();
    } catch (e) {
      print('Error fetching crafts: $e');
      rethrow;
    }
  }

  Future<Craft?> fetchCraftById(String id) async {
    try {
      final response =
          await _supabase.from('crafts').select().eq('id', id).single();
      final craft = Craft.fromJson(response);
      // Ensure imageUrl is a full public URL
      return Craft(
        id: craft.id,
        artisanId: craft.artisanId,
        name: craft.name,
        material: craft.material,
        price: craft.price,
        description: craft.description,
        imageUrl:
            craft.imageUrl.isNotEmpty ? _getPublicImageUrl(craft.imageUrl) : '',
        status: craft.status,
        createdAt: craft.createdAt,
        imageUrls: craft.imageUrls,
      );
    } catch (e) {
      print('Error fetching craft: $e');
      return null;
    }
  }

  Future<List<String>> uploadImages(
      List<Uint8List> fileBytes, List<String> fileNames) async {
    List<String> urls = [];

    for (int i = 0; i < fileBytes.length; i++) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = 'crafts/${timestamp}_${fileNames[i]}';

      try {
        await _supabase.storage.from('craft-images').uploadBinary(
              path,
              fileBytes[i],
            );

        final publicUrl =
            _supabase.storage.from('craft-images').getPublicUrl(path);
        urls.add(publicUrl);
      } catch (e) {
        print('Error uploading image: $e');
      }
    }

    return urls;
  }

  Future<Craft> createCraft(Craft craft) async {
    try {
      final response = await _supabase
          .from('crafts')
          .insert(craft.toJson())
          .select()
          .single();
      return Craft.fromJson(response);
    } catch (e) {
      print('Error creating craft: $e');
      rethrow;
    }
  }

  Future<void> updateCraft(String id, Craft craft) async {
    try {
      await _supabase.from('crafts').update(craft.toJson()).eq('id', id);
    } catch (e) {
      print('Error updating craft: $e');
      rethrow;
    }
  }

  Future<void> updateCraftStatus(String id, String status) async {
    try {
      await _supabase.from('crafts').update({'status': status}).eq('id', id);
    } catch (e) {
      print('Error updating craft status: $e');
      rethrow;
    }
  }

  Future<void> deleteCraft(String id) async {
    try {
      await _supabase.from('crafts').delete().eq('id', id);
    } catch (e) {
      print('Error deleting craft: $e');
      rethrow;
    }
  }
}
