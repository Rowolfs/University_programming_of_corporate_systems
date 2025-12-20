import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:tier_list_app/models/tierItem.dart';
import 'package:tier_list_app/services/supabase_client.dart';
import 'package:tier_list_app/widgets/actionModal.dart';

class CreateCardDialog extends StatefulWidget {
  final String tierlistId;
  final void Function(TierItem item) onSave;

  const CreateCardDialog({
    super.key,
    required this.tierlistId,
    required this.onSave,
  });

  @override
  State<CreateCardDialog> createState() => _CreateCardDialogState();
}

class _CreateCardDialogState extends State<CreateCardDialog> {
  static const _bucket = 'images';

  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  TierItemImageType? imageType;
  String? imageRef; // локальный path (для preview) или network url (после upload)

  XFile? _picked; // чтобы знать extension/name
  bool _saving = false;

  @override
  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    priceCtrl.dispose();
    super.dispose();
  }

  int? _parsePriceMinor(String s) {
    final t = s.trim();
    if (t.isEmpty) return null;
    final v = double.tryParse(t.replaceAll(',', '.'));
    if (v == null) return null;
    return (v * 100).round();
  }

  Future<void> _pickImage() async {
    final XFile? xfile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (xfile == null) return;

    setState(() {
      _picked = xfile;
      imageType = TierItemImageType.file;
      imageRef = xfile.path;
    });
  }

  String _guessContentType(String pathOrName) {
    final lower = pathOrName.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
    return 'application/octet-stream';
  }

  String _extractExtension(String pathOrName) {
    final lower = pathOrName.toLowerCase();
    if (lower.endsWith('.png')) return '.png';
    if (lower.endsWith('.webp')) return '.webp';
    if (lower.endsWith('.jpg')) return '.jpg';
    if (lower.endsWith('.jpeg')) return '.jpeg';
    return '.jpg';
  }

  Future<String> _uploadPickedImage({
    required String itemId,
    required XFile xfile,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw StateError('Not authenticated');
    }

    final ext = _extractExtension(xfile.name.isNotEmpty ? xfile.name : xfile.path);
    final contentType = _guessContentType(xfile.name.isNotEmpty ? xfile.name : xfile.path);

    final path = '${user.id}/tierlists_items/${widget.tierlistId}/$itemId$ext';
    final file = File(xfile.path);

    await supabase.storage.from(_bucket).upload(
          path,
          file,
          fileOptions: FileOptions(
            contentType: contentType,
            upsert: true,
            cacheControl: '3600',
          ),
        ); // upload(path, file, fileOptions) [web:497]

    final publicUrl = supabase.storage.from(_bucket).getPublicUrl(path); // public bucket url [web:147]
    return publicUrl;
  }

  Widget _preview() {
    if (imageType == null || imageRef == null) {
      return const Icon(Icons.cloud_upload, color: Colors.white54, size: 54);
    }

    return switch (imageType!) {
      TierItemImageType.asset => Image.asset(imageRef!, fit: BoxFit.cover),
      TierItemImageType.file => Image.file(File(imageRef!), fit: BoxFit.cover),
      TierItemImageType.network => Image.network(imageRef!, fit: BoxFit.cover),
    };
  }

  Future<void> _onSavePressed() async {
    if (_saving) return;

    if (titleCtrl.text.trim().isEmpty) return;
    if (_picked == null || imageType != TierItemImageType.file || imageRef == null) return;

    setState(() => _saving = true);

    try {
      final itemId = DateTime.now().microsecondsSinceEpoch.toString();

      // 1) upload -> получаем public url
      final publicUrl = await _uploadPickedImage(itemId: itemId, xfile: _picked!);

      // 2) создаём TierItem уже с network url
      final item = TierItem(
        id: itemId,
        imageType: TierItemImageType.network,
        imageRef: publicUrl,
        title: titleCtrl.text.trim(),
        description: descCtrl.text.trim(),
        priceMinor: _parsePriceMinor(priceCtrl.text),
      );

      widget.onSave(item);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      debugPrint('CreateCardDialog upload/save error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось загрузить изображение'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ActionModal(
      label: _saving ? 'Загрузка…' : 'Сохранить',
      onPressed: () {
        // ActionModal, вероятно, ждёт sync callback — запускаем async без await
        _onSavePressed();
      },
      children: [
        SizedBox(height: 26.h),

        GestureDetector(
          onTap: _saving ? null : _pickImage,
          child: Container(
            width: 150.w,
            height: 150.w,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(14.r),
            ),
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Center(child: _preview()),
                if (_saving)
                  Container(
                    color: Colors.black.withAlpha(120),
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ),

        SizedBox(height: 18.h),

        SizedBox(
          width: 300.w,
          child: TextField(
            controller: titleCtrl,
            enabled: !_saving,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
            ),
            decoration: const InputDecoration(
              hintText: 'Твоя карточка',
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none,
            ),
          ),
        ),

        SizedBox(height: 25.h),

        Container(
          width: 300.w,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: TextField(
            controller: descCtrl,
            enabled: !_saving,
            maxLines: 3,
            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
            decoration: const InputDecoration(
              hintText: 'Описание…',
              hintStyle: TextStyle(color: Colors.white38),
              border: InputBorder.none,
              isCollapsed: true,
            ),
          ),
        ),

        SizedBox(height: 14.h),
        /*
        SizedBox(
          width: 300.w,
          child: TextField(
            controller: priceCtrl,
            enabled: !_saving,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
            decoration: const InputDecoration(
              hintText: 'Цена (например 1.99) — можно пусто',
              hintStyle: TextStyle(color: Colors.white38),
              border: InputBorder.none,
            ),
          ),
        ),
        */
      ],
    );
  }
}
