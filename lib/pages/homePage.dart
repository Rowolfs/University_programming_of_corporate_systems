import 'package:flutter/material.dart';
import 'package:tier_list_app/widgets/actionNavigationBar.dart';
import 'package:tier_list_app/widgets/actionAppBar.dart';
import 'package:tier_list_app/widgets/tierListCard.dart';
import 'package:tier_list_app/services/tierlists_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _service = TierlistsService();
  final _scrollCtrl = ScrollController();

  final List<Map<String, dynamic>> _items = [];

  static const int _pageSize = 20;
  static const double _thresholdPx = 300.0;

  int _page = 0;
  bool _loading = false;
  bool _hasMore = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFirstPage();

    _scrollCtrl.addListener(() {
      if (!_scrollCtrl.hasClients) return;
      final max = _scrollCtrl.position.maxScrollExtent;
      final cur = _scrollCtrl.position.pixels;

      if (max - cur <= _thresholdPx) {
        _loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadFirstPage() async {
    setState(() {
      _items.clear();
      _page = 0;
      _hasMore = true;
      _error = null;
    });
    await _loadNextPage();
  }

  Future<void> _loadNextPage() async {
    if (_loading || !_hasMore) return;

    setState(() => _loading = true);

    try {
      final data = await _service.fetchPage(page: _page, pageSize: _pageSize);

      if (!mounted) return;
      setState(() {
        _items.addAll(data);
        _page += 1;
        if (data.length < _pageSize) _hasMore = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Не удалось загрузить тирлисты');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
          appBar: const ActionAppBar(),
          bottomNavigationBar: const ActionNavigationBar(),
          body: RefreshIndicator(
            onRefresh: _loadFirstPage,
            child: _error != null && _items.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 140),
                      Center(
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  )
                : GridView.builder(
                    controller: _scrollCtrl,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.215,
                    ),
                    itemCount: _items.length + (_loading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= _items.length) {
                        return const Center(child: CircularProgressIndicator());
                      }

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
        ),
      ],
    );
  }
}
