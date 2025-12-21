import 'supabase_client.dart';

class TierlistsService {
  static const _table = 'tierlists';

  Future<Map<String, dynamic>> createTierlist({
    required String title,
    String? previewUrl,
  }) async {
    final user = supabase.auth.currentUser;
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
        .select();

    return Map<String, dynamic>.from((data as List).first as Map);
  }

  Future<List<Map<String, dynamic>>> fetchPage({
    required int page,
    int pageSize = 20,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Not authorized');
    }

    final from = page * pageSize;
    final to = from + pageSize - 1;

    final data = await supabase
        .from(_table)
        .select('''
          id,
          title,
          owner_id,
          preview_url,
          created_at,
          owner:profiles(
            avatar_url,
            username,
            full_name
          )
        ''')
        .eq('owner_id', user.id) // только мои [web:170]
        .order('created_at', ascending: false)
        .range(from, to);

    return (data as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  Future<List<Map<String, dynamic>>> searchByTitle({
    required String query,
    int limit = 50,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Not authorized');
    }

    final q = query.trim();
    if (q.isEmpty) return [];

    final data = await supabase
        .from(_table)
        .select('''
          id,
          title,
          owner_id,
          preview_url,
          created_at,
          owner:profiles(
            avatar_url,
            username,
            full_name
          )
        ''')
        .eq('owner_id', user.id) // только мои [web:170]
        .ilike('title', '%$q%')
        .order('created_at', ascending: false)
        .limit(limit);

    return (data as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }
}
