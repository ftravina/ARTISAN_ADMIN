import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/inquiry.dart';

class InquiryService {
  final SupabaseClient _supabase;

  InquiryService(this._supabase);

  Future<List<Inquiry>> fetchInquiries() async {
    try {
      final response = await _supabase
          .from('inquiries')
          .select('*, crafts(name, price, image_urls), users(email)');
      return (response as List).map((e) => Inquiry.fromJson(e)).toList();
    } catch (e) {
      print('Error fetching inquiries: $e');
      rethrow;
    }
  }
}
