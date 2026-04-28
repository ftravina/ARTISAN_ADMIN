import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/artisan.dart';

class ArtisanProvider extends ChangeNotifier {
  final SupabaseClient supabase;

  List<Artisan> _artisans = [];
  bool _isLoading = false;
  String? _error;

  List<Artisan> get artisans => _artisans;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ArtisanProvider(this.supabase);

  Future<void> fetchArtisans() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await supabase
          .from('artisans')
          .select()
          .order('created_at', ascending: false);

      _artisans =
          (response as List).map((json) => Artisan.fromJson(json)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createArtisan({
    required String name,
    required String community,
    required String region,
    required String story,
    required String photoUrl,
  }) async {
    try {
      await supabase.from('artisans').insert({
        'name': name,
        'community': community,
        'region': region,
        'story': story,
        'photo_url': photoUrl,
      });

      // ✅ ALWAYS REFRESH FROM DATABASE
      await fetchArtisans();
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<void> updateArtisan({
    required String id,
    required String name,
    required String community,
    required String region,
    required String story,
    required String photoUrl,
  }) async {
    try {
      await supabase.from('artisans').update({
        'name': name,
        'community': community,
        'region': region,
        'story': story,
        'photo_url': photoUrl,
      }).eq('id', id);

      // ✅ REFRESH AFTER UPDATE
      await fetchArtisans();
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<void> deleteArtisan(String id) async {
    try {
      await supabase.from('artisans').delete().eq('id', id);

      // ✅ REFRESH AFTER DELETE
      await fetchArtisans();
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }
}
