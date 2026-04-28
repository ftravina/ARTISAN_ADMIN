import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/craft.dart';
import '../config/supabase_config.dart';

class CraftProvider extends ChangeNotifier {
  final SupabaseClient supabase;

  List<Craft> _crafts = [];
  bool _isLoading = false;
  String? _error;

  List<Craft> get crafts => _crafts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  CraftProvider(this.supabase);

  /// Converts a stored image path to a proper Supabase public URL
  String _getPublicImageUrl(String imageUrl) {
    if (imageUrl.isEmpty) return '';
    if (imageUrl.startsWith('http')) return imageUrl;
    return '$supabaseUrl/storage/v1/object/public/craft-images/$imageUrl';
  }

  Future<void> fetchCrafts({String? status}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      var query = supabase.from('crafts').select();

      if (status != null) {
        query = query.eq('status', status);
      }

      final response = await query.order('created_at', ascending: false);

      _crafts = (response as List).map((json) {
        final craft = Craft.fromJson(json);
        return Craft(
          id: craft.id,
          artisanId: craft.artisanId,
          name: craft.name,
          material: craft.material,
          price: craft.price,
          description: craft.description,
          imageUrl: _getPublicImageUrl(craft.imageUrl),
          status: craft.status,
          createdAt: craft.createdAt,
          imageUrls: craft.imageUrls,
        );
      }).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createCraft({
    required String artisanId,
    required String name,
    required String material,
    required double price,
    required String description,
    required String imageUrl,
  }) async {
    try {
      final response = await supabase.from('crafts').insert({
        'artisan_id': artisanId,
        'name': name,
        'material': material,
        'price': price,
        'description': description,
        'image_urls': imageUrl.isNotEmpty ? [imageUrl] : [],
        'status': 'available', // ✅ FIXED
      }).select();

      final rawCraft = Craft.fromJson(response[0]);
      final newCraft = Craft(
        id: rawCraft.id,
        artisanId: rawCraft.artisanId,
        name: rawCraft.name,
        material: rawCraft.material,
        price: rawCraft.price,
        description: rawCraft.description,
        imageUrl: _getPublicImageUrl(rawCraft.imageUrl),
        status: rawCraft.status,
        createdAt: rawCraft.createdAt,
        imageUrls: rawCraft.imageUrls,
      );

      _crafts.insert(0, newCraft);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<void> updateCraft({
    required String id,
    required String name,
    required String material,
    required double price,
    required String description,
    required String imageUrl,
    required String status,
  }) async {
    try {
      await supabase.from('crafts').update({
        'name': name,
        'material': material,
        'price': price,
        'description': description,
        'image_urls': imageUrl.isNotEmpty ? [imageUrl] : [],
        'status': status,
      }).eq('id', id);

      final index = _crafts.indexWhere((c) => c.id == id);
      if (index != -1) {
        _crafts[index] = Craft(
          id: id,
          artisanId: _crafts[index].artisanId,
          name: name,
          material: material,
          price: price,
          description: description,
          imageUrl: _getPublicImageUrl(imageUrl),
          status: status,
          createdAt: _crafts[index].createdAt,
        );
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<void> approveCraft(String id) async {
    try {
      await supabase.from('crafts').update({
        'status': 'available', // ✅ FIXED
      }).eq('id', id);

      final index = _crafts.indexWhere((c) => c.id == id);
      if (index != -1) {
        _crafts[index] = Craft(
          id: _crafts[index].id,
          artisanId: _crafts[index].artisanId,
          name: _crafts[index].name,
          material: _crafts[index].material,
          price: _crafts[index].price,
          description: _crafts[index].description,
          imageUrl: _crafts[index].imageUrl,
          status: 'available', // ✅ FIXED
          createdAt: _crafts[index].createdAt,
        );
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<void> deleteCraft(String id) async {
    try {
      await supabase.from('crafts').delete().eq('id', id);
      _crafts.removeWhere((c) => c.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }
}
