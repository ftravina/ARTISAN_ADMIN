import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/inquiry.dart';

class InquiryProvider extends ChangeNotifier {
  final SupabaseClient supabase;

  List<Inquiry> _inquiries = [];
  bool _isLoading = false;
  String? _error;

  List<Inquiry> get inquiries => _inquiries;
  bool get isLoading => _isLoading;
  String? get error => _error;

  InquiryProvider(this.supabase);

  Future<void> fetchInquiries() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await supabase
          .from('inquiries')
          .select()
          .order('created_at', ascending: false);

      _inquiries = (response as List)
          .map((json) => Inquiry.fromJson(json))
          .toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteInquiry(String id) async {
    try {
      await supabase.from('inquiries').delete().eq('id', id);
      _inquiries.removeWhere((i) => i.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }
}
