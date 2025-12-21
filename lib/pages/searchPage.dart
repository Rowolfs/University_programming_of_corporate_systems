import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tier_list_app/services/tierlists_service.dart';
import 'package:tier_list_app/widgets/actionNavigationBar.dart';
import 'package:tier_list_app/widgets/tierListCard.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _service = TierlistsService();
  final _searchCtrl = TextEditingController();

  Timer? _debounce;
  bool _loading = false;
  String? _error;

  final List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    // можно оставить пусто, чтобы без запроса при открытии
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _runSearch(String text) async {
    final q = text.trim();

    // Очистка результата при пустой строке
    if (q.isEmpty) {
      setState(() {
        _items.clear();
        _error = null;
        _loading = false;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final data = await _service.searchByTitle(query: q, limit: 60);
      if (!mounted) return;

      setState(() {
        _items
          ..clear()
          ..addAll(data);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _runSearch(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width >= 700 ? 3 : 2;

    return Stack(
      children: [
        const Positioned.fill(
          child: Image(
            image: AssetImage('assets/images/start_wallpaper.png'),
            fit: BoxFit.cover,
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF141E30),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          bottomNavigationBar: const ActionNavigationBar(),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: _onChanged,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Поиск по названию тирлиста...',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      suffixIcon: _searchCtrl.text.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.close, color: Colors.white70),
                              onPressed: () {
                                _searchCtrl.clear();
                                _runSearch('');
                                setState(() {}); // чтобы скрыть крестик
                              },
                            ),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.35),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.10)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.10)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.20)),
                      ),
                    ),
                  ),
                ),

                if (_loading) const LinearProgressIndicator(minHeight: 2),

                Expanded(
                  child: _error != null
                      ? ListView(
                          children: [
                            const SizedBox(height: 80),
                            Center(
                              child: Text(
                                _error!,
                                style: const TextStyle(color: Colors.redAccent),
                              ),
                            ),
                          ],
                        )
                      : (_items.isEmpty && _searchCtrl.text.trim().isNotEmpty && !_loading)
                          ? ListView(
                              children: const [
                                SizedBox(height: 80),
                                Center(
                                  child: Text(
                                    'Ничего не найдено',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ),
                              ],
                            )
                          : GridView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(16),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1.215,
                              ),
                              itemCount: _items.length,
                              itemBuilder: (context, index) {
                                final item = _items[index];
                                return TierListCard(
                                  id: item['id'].toString(),
                                  title: (item['title'] ?? 'Без названия').toString(),
                                  previewUrl: item['preview_url']?.toString(),
                                  ownerId: item['owner_id']?.toString(),
                                  ownerAvatarUrl: item['owner']?['avatar_url']?.toString(),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
