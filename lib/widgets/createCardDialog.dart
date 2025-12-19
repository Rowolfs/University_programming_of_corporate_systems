import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:tier_list_app/models/tierItem.dart';
import 'package:tier_list_app/widgets/actionModal.dart';

class CreateCardDialog extends StatefulWidget {
  final void Function(TierItem item) onSave;
  const CreateCardDialog({super.key, required this.onSave});

  @override
  State<CreateCardDialog> createState() => _CreateCardDialogState();
}

class _CreateCardDialogState extends State<CreateCardDialog> {
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final priceCtrl = TextEditingController();

  TierItemImageType? imageType;
  String? imageRef;

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

  // пока заглушка: по тапу ставим любой asset
  Future<void> _pickImage() async {
    setState(() {
      imageType = TierItemImageType.asset;
      imageRef = 'assets/images/tierlist.png';
    });
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

  @override
  Widget build(BuildContext context) {
    return ActionModal(
      label: 'Сохранить',
      onPressed: () {
        if (imageType == null || imageRef == null) return;
        if (titleCtrl.text.trim().isEmpty) return;

        final item = TierItem(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          imageType: imageType!,
          imageRef: imageRef!,
          title: titleCtrl.text.trim(),
          description: descCtrl.text.trim(),
          priceMinor: _parsePriceMinor(priceCtrl.text),
        );

        widget.onSave(item);
        Navigator.of(context).pop();
      },
      children: [
        SizedBox(height: 26.h),

        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: 150.w,
            height: 150.w,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(14.r),
            ),
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,
            child: _preview(),
          ),
        ),



        SizedBox(
          width: 300.w,
          child: TextField(
            controller: titleCtrl,
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
        SizedBox(height: 25.h,),
        Container(
          width: 300.w,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: TextField(
            controller: descCtrl,
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



        SizedBox(
          width: 300.w,
          child: TextField(
            controller: priceCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
            decoration: const InputDecoration(
              hintText: 'Цена (например 1.99) — можно пусто',
              hintStyle: TextStyle(color: Colors.white38),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
