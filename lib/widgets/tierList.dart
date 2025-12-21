import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:storage_client/storage_client.dart';

import 'package:tier_list_app/models/tierItem.dart';
import 'package:tier_list_app/pages/homePage.dart';
import 'package:tier_list_app/widgets/actionButton.dart';
import 'package:tier_list_app/widgets/tierListRow.dart';
import 'package:tier_list_app/widgets/tierListItemPoolBar.dart';
import 'package:tier_list_app/widgets/createCardDialog.dart';
import 'package:tier_list_app/services/supabase_client.dart';

class TierList extends StatefulWidget {
  final String tierlistId;

  const TierList({
    super.key,
    required this.tierlistId,
    double? width,
    double? height,
  })  : width = width ?? 390,
        height = height ?? 469;

  final double width;
  final double height;

  @override
  State<TierList> createState() => _TierListState();
}

class _TierListState extends State<TierList> {
  /// ДАННЫЕ ТИРОВ
  final List<Map<String, dynamic>> _tiersData = const [
    {'char': 'S', 'color': Color(0xFFFF7F7F)},
    {'char': 'A', 'color': Color(0xFFFFBF7F)},
    {'char': 'B', 'color': Color(0xFFFFDF7F)},
    {'char': 'C', 'color': Color(0xFFFFFF7F)},
    {'char': 'D', 'color': Color(0xFFBFFF7F)},
  ];

  /// ЭЛЕМЕНТЫ ПО ТИРАМ
  Map<String, List<TierItem>> tierItems = {};

  /// НИЖНИЙ ПУЛ (селектор)
  List<TierItem> poolItems = [];

  bool _loading = false;
  String? _error;

  // ---- tables ----
  static const _tierlistsTable = 'tierlists';
  static const _itemsTable = 'tierlist_items';

  // ---- title ----
  final _titleCtrl = TextEditingController();
  bool _titleLoading = false;

  // ---- preview ----
  final _picker = ImagePicker();
  bool _previewUploading = false;
  String? _previewUrl;
  String? _previewPath;

  // ---- save ----
  bool _dirty = false;
  bool _saving = false;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();

    tierItems = {
      'S': <TierItem>[],
      'A': <TierItem>[],
      'B': <TierItem>[],
      'C': <TierItem>[],
      'D': <TierItem>[],
    };
    poolItems = <TierItem>[];

    _loadTierlistTitle();
    _loadTierlistItems();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  bool get _isEmpty =>
      tierItems.values.every((e) => e.isEmpty) && poolItems.isEmpty;

  void _markDirty() {
    if (_dirty) return;
    setState(() => _dirty = true);
  }

  /// Гарантирует, что один id находится только в одном месте:
  /// либо в одном из tier, либо в pool (pool очищаем от тех, кто есть в tier).
  void _dedupeState() {
    // 1) внутри каждого тира: удаляем дубли по id, сохраняя порядок
    for (final key in tierItems.keys) {
      final seen = <String>{};
      tierItems[key]!.retainWhere((x) => seen.add(x.id));
    }

    // 2) pool: удаляем дубли по id
    final poolSeen = <String>{};
    poolItems.retainWhere((x) => poolSeen.add(x.id));

    // 3) pool: убираем элементы, которые уже есть в tier
    final inTiers = <String>{};
    for (final list in tierItems.values) {
      for (final it in list) {
        inTiers.add(it.id);
      }
    }
    poolItems.removeWhere((x) => inTiers.contains(x.id));
  }

  Future<void> _loadTierlistTitle() async {
    setState(() => _titleLoading = true);

    try {
      final row = await supabase
          .from(_tierlistsTable)
          .select('title, preview_url, preview_path')
          .eq('id', widget.tierlistId)
          .maybeSingle();

      if (!mounted) return;

      _titleCtrl.text = (row?['title'] ?? 'Новый тирлист').toString();

      final pUrl = (row?['preview_url'] ?? '').toString().trim();
      _previewUrl = pUrl.isEmpty ? null : pUrl;

      final pPath = (row?['preview_path'] ?? '').toString().trim();
      _previewPath = pPath.isEmpty ? null : pPath;
    } catch (e) {
      debugPrint('TierList title load error: $e');
    } finally {
      if (mounted) setState(() => _titleLoading = false);
    }
  }

  void _onTitleChanged(String value) {
    _markDirty();
  }

  Future<void> _pickAndUploadPreview() async {
    if (_previewUploading || _saving || _deleting) return;

    final user = supabase.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Нужно войти в аккаунт'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1200,
    );
    if (picked == null) return;

    setState(() => _previewUploading = true);

    try {
      final Uint8List bytes = await picked.readAsBytes();

      final extRaw = picked.name.contains('.')
          ? picked.name.split('.').last.toLowerCase()
          : 'jpg';
      final ext = (extRaw == 'png' || extRaw == 'jpg' || extRaw == 'jpeg' || extRaw == 'webp')
          ? extRaw
          : 'jpg';

      final bucket = supabase.storage.from('tierlist_previews');
      final path = '${user.id}/${widget.tierlistId}/preview.$ext';

      await bucket.uploadBinary(
        path,
        bytes,
        fileOptions: FileOptions(
          upsert: true,
          cacheControl: '3600',
          contentType: ext == 'png' ? 'image/png' : 'image/jpeg',
        ),
      );

      final url = bucket.getPublicUrl(path);

      await supabase.from(_tierlistsTable).update({
        'preview_url': url,
        'preview_path': path,
      }).eq('id', widget.tierlistId);

      if (!mounted) return;
      setState(() {
        _previewUrl = url;
        _previewPath = path;
        _dirty = true;
      });
    } catch (e) {
      debugPrint('TierList preview upload error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось загрузить превью'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _previewUploading = false);
    }
  }

  Future<void> _loadTierlistItems() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final rows = await supabase
          .from(_itemsTable)
          .select('id, tierlist_id, tier, title, description, image_url, position')
          .eq('tierlist_id', widget.tierlistId)
          .order('tier', ascending: true)
          .order('position', ascending: true);

      if (!mounted) return;

      final nextTierItems = {
        'S': <TierItem>[],
        'A': <TierItem>[],
        'B': <TierItem>[],
        'C': <TierItem>[],
        'D': <TierItem>[],
      };
      final nextPool = <TierItem>[];

      for (final r in (rows as List)) {
        final map = (r as Map<String, dynamic>);
        final imageUrl = (map['image_url'] ?? '').toString().trim();

        final item = imageUrl.isEmpty
            ? TierItem.asset(
                id: map['id'].toString(),
                imageRef: 'assets/images/tierlist.png',
                title: (map['title'] ?? 'Без названия').toString(),
                description: (map['description'] ?? '').toString(),
                priceMinor: null,
              )
            : TierItem.network(
                id: map['id'].toString(),
                imageRef: imageUrl,
                title: (map['title'] ?? 'Без названия').toString(),
                description: (map['description'] ?? '').toString(),
                priceMinor: null,
              );

        // pool в БД = tier == null
        final tier = map['tier']?.toString();

        if (tier == null || tier.isEmpty || tier == ItemPoolBar.poolTierKey) {
          nextPool.add(item);
        } else if (nextTierItems.containsKey(tier)) {
          nextTierItems[tier]!.add(item);
        } else {
          nextPool.add(item);
        }
      }

      tierItems = nextTierItems;
      poolItems = nextPool;
      _dedupeState();

      setState(() {
        _dirty = false;
      });
    } catch (e) {
      debugPrint('TierList load error: $e');
      if (!mounted) return;
      setState(() => _error = 'Не удалось загрузить элементы тирлиста');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Сохранить title + все tier/position
  Future<void> _saveAll() async {
    if (_saving || _deleting) return;

    final title = _titleCtrl.text.trim();
    if (!_dirty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Нет изменений'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final user = supabase.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Нужно войти в аккаунт'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      _dedupeState();

      if (title.isNotEmpty) {
        await supabase
            .from(_tierlistsTable)
            .update({'title': title})
            .eq('id', widget.tierlistId);
      }

      final updates = <Map<String, dynamic>>[];

      void addList(List<TierItem> list, String? tierKeyOrNull) {
        for (var i = 0; i < list.length; i++) {
          final item = list[i];

          final imageRef = (item.imageRef).toString();
          final isNetwork =
              imageRef.startsWith('http://') || imageRef.startsWith('https://');

          updates.add({
            'id': item.id,
            'tierlist_id': widget.tierlistId,
            'owner_id': user.id,
            'tier': tierKeyOrNull, // pool = null
            'position': i,
            'title': item.title,
            'description': item.description,
            'image_url': isNetwork ? imageRef : null,
          });
        }
      }

      addList(poolItems, null);
      for (final entry in tierItems.entries) {
        addList(entry.value, entry.key);
      }

      if (updates.isNotEmpty) {
        await supabase.from(_itemsTable).upsert(
              updates,
              onConflict: 'id',
            );
      }

      if (!mounted) return;
      setState(() => _dirty = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Сохранено'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      debugPrint('TierList save error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ошибка сохранения'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _deleteTierlist() async {
    if (_saving || _deleting) return;


    setState(() => _deleting = true);

    try {
      await supabase.from(_itemsTable).delete().eq('tierlist_id', widget.tierlistId);
      await supabase.from(_tierlistsTable).delete().eq('id', widget.tierlistId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Тирлист удалён'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomePage()),
      (Route<dynamic> route) => false,
    );
    } catch (e) {
      debugPrint('TierList delete error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось удалить тирлист'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  /// ПЕРЕМЕЩЕНИЕ ЭЛЕМЕНТА МЕЖДУ ТИРАМИ / ИЗ ПУЛА В ТИР
  void moveItem(TierItem item, String fromTier, String toTier) {
    if (fromTier == toTier) return;

    setState(() {
      if (fromTier == ItemPoolBar.poolTierKey) {
        poolItems.removeWhere((e) => e.id == item.id);
      } else {
        tierItems[fromTier]!.removeWhere((e) => e.id == item.id);
      }

      if (toTier == ItemPoolBar.poolTierKey) {
        poolItems.add(item);
      } else {
        tierItems[toTier]!.add(item);
      }

      _dedupeState();
      _dirty = true;
    });
  }

  Future<void> openCreateCardDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (_) => CreateCardDialog(
        tierlistId: widget.tierlistId,
        onSave: (item) async {
          try {
            final user = supabase.auth.currentUser;
            if (user == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Нужно войти в аккаунт'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              return;
            }

            final imageRef = (item.imageRef).toString();
            final isNetwork =
                imageRef.startsWith('http://') || imageRef.startsWith('https://');

            final inserted = await supabase
                .from(_itemsTable)
                .insert({
                  'tierlist_id': widget.tierlistId,
                  'owner_id': user.id,
                  'tier': null, // pool
                  'position': poolItems.length,
                  'title': item.title,
                  'description': item.description,
                  'image_url': isNetwork ? imageRef : null,
                })
                .select('id, title, description, image_url')
                .single();

            final imageUrl = (inserted['image_url'] ?? '').toString().trim();

            final created = imageUrl.isEmpty
                ? TierItem.asset(
                    id: inserted['id'].toString(),
                    imageRef: 'assets/images/tierlist.png',
                    title: (inserted['title'] ?? 'Без названия').toString(),
                    description: (inserted['description'] ?? '').toString(),
                    priceMinor: null,
                  )
                : TierItem.network(
                    id: inserted['id'].toString(),
                    imageRef: imageUrl,
                    title: (inserted['title'] ?? 'Без названия').toString(),
                    description: (inserted['description'] ?? '').toString(),
                    priceMinor: null,
                  );

            if (!mounted) return;
            setState(() {
              poolItems.removeWhere((e) => e.id == created.id);
              for (final key in tierItems.keys) {
                tierItems[key]!.removeWhere((e) => e.id == created.id);
              }

              poolItems.add(created);
              _dedupeState();
              _dirty = true;
            });
          } catch (e) {
            debugPrint('TierList insert item error: $e');
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Не удалось добавить карточку'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      ),
    );
  }

  void onAddNew() => openCreateCardDialog();

  Widget _titleHeader() {
    final disabled =
        _titleLoading || _saving || _deleting || _previewUploading;

    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 8.h),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _titleCtrl,
              enabled: !disabled,
              onChanged: _onTitleChanged,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                hintText: 'Название тирлиста',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF1A1A1A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          InkWell(
            onTap: disabled ? null : _pickAndUploadPreview,
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white.withAlpha(35)),
                image: _previewUrl == null
                    ? null
                    : DecorationImage(
                        image: NetworkImage(_previewUrl!),
                        fit: BoxFit.cover,
                      ),
              ),
              child: _previewUploading
                  ? const Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : (_previewUrl == null
                      ? const Icon(Icons.image, color: Colors.white70)
                      : null),
            ),
          ),
        ],
      ),
    );
  }

  Widget _saveBar() {
    final disabled = _saving || _deleting;

    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 12.h),
      child: Row(
        children: [
          Expanded(
            child: ActionButton(
              onPressed: disabled ? null : _saveAll,
              label: _saving ? 'Сохранение…' : (_dirty ? 'Сохранить' : 'Сохранено'),
            ),
          ),
          SizedBox(width: 10.w),
          SizedBox(
            width: 130.w,
            child: ActionButton(
              onPressed: disabled ? null : _deleteTierlist,
              label: _deleting ? 'Удаление…' : 'Удалить',
            ),
          ),
        ],
      ),
    );
  }

  Widget _content(BuildContext context) {
    if (_loading && _isEmpty) {
      return SizedBox(
        height: 240.h,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null && _isEmpty) {
      return SizedBox(
        height: 240.h,
        child: Center(
          child: Text(
            _error!,
            style: const TextStyle(color: Colors.redAccent),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (!_loading && _error == null && _isEmpty) {
      return Column(
        children: [
          SizedBox(height: 16.h),
          const Text(
            'Тирлист пустой.\nНажми “+”, чтобы добавить первый элемент.',
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          ActionButton(
            onPressed: onAddNew,
            label: 'Добавить',
          ),
          SizedBox(height: 12.h),
        ],
      );
    }

    return Column(
      children: [
        ..._tiersData.map((tier) {
          final String tierChar = tier['char'] as String;
          final Color tierColor = tier['color'] as Color;

          return Padding(
            padding: EdgeInsets.only(bottom: 2.h),
            child: TierListRow(
              tierChar: tierChar,
              tierColor: tierColor,
              items: tierItems[tierChar] ?? const [],
              onAccept: (item, fromTier) => moveItem(item, fromTier, tierChar),
            ),
          );
        }),
        SizedBox(height: 14.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: ItemPoolBar(
            items: poolItems,
            onAddNew: onAddNew,
            onAcceptFromTier: (item, fromTier) {
              moveItem(item, fromTier, ItemPoolBar.poolTierKey);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width.w,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          _titleHeader(), // <-- название + превью в одной строке
          _content(context),
          _saveBar(),
        ],
      ),
    );
  }
}
