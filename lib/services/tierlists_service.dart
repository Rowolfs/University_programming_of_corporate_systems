import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';

class TierlistsService {
  static const _table = 'tierlists';


  Future<Map<String, dynamic>> createTierlist({
    required String title,
    String? previewUrl,
  }) async {
    final user = supabase.auth.currentUser; // текущий пользователь [web:246]
    if (user == null) {
      throw Exception('Not authorized');
    }

    final data = await supabase
        .from(_table)
        .insert({
          'title': title,
          'owner_id': user.id,
          'preview_url': previewUrl,
        })
        .select(); // вернуть вставленную строку [web:241]

    return (data as List).first as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> fetchPage({
    required int page,
    int pageSize = 20,
  }) async {
    final from = page * pageSize;
    final to = from + pageSize - 1; // range() inclusive [web:86]

    return await supabase
        .from(_table)
        .select('id, title, owner_id, preview_url, created_at')
        .order('created_at', ascending: false)
        .range(from, to);
  }
}
