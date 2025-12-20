import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tier_list_app/models/dragTierItem.dart';
import 'package:tier_list_app/models/tierItem.dart';

class ItemPoolBar extends StatelessWidget {
  const ItemPoolBar({
    super.key,
    required this.items,
    required this.onAddNew,
    required this.onAcceptFromTier,
  });

  final List<TierItem> items;
  final VoidCallback onAddNew;

  final void Function(TierItem item, String fromTier) onAcceptFromTier;

  static const String poolTierKey = '_POOL';

  @override
  Widget build(BuildContext context) {
    return DragTarget<DragTierItem>(
      onWillAcceptWithDetails: (details) => details.data.fromTier != poolTierKey,
      onAcceptWithDetails: (details) =>
          onAcceptFromTier(details.data.item, details.data.fromTier),
      builder: (context, candidateData, rejectedData) {
        final isHover = candidateData.isNotEmpty;

        return Container(
          height: 86.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isHover ? const Color(0xFF2A2A2A) : const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isHover ? Colors.white54 : Colors.white24,
            ),
          ),
          child: Row(
            children: [
              _AddNewTile(onTap: onAddNew),
              SizedBox(width: 10.w),
              Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  separatorBuilder: (_, __) => SizedBox(width: 10.w),
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return Draggable<DragTierItem>(
                      data: DragTierItem(item: item, fromTier: poolTierKey),
                      feedback: _PoolItem(item: item, dragging: true),
                      childWhenDragging:
                          Opacity(opacity: 0.35, child: _PoolItem(item: item)),
                      child: _PoolItem(item: item),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddNewTile extends StatelessWidget {
  const _AddNewTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        width: 56.w,
        height: 56.w,
        decoration: BoxDecoration(
          color: const Color(0xFF303030),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.white24),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _PoolItem extends StatelessWidget {
  const _PoolItem({required this.item, this.dragging = false});

  final TierItem item;
  final bool dragging;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        color: const Color(0xFF202020),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.white24),
        boxShadow: dragging
            ? [const BoxShadow(color: Colors.black45, blurRadius: 10)]
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
  switch (item.imageType) {
    case TierItemImageType.asset:
      return Image.asset(item.imageRef, fit: BoxFit.cover);

    case TierItemImageType.file:
      return Image.file(File(item.imageRef), fit: BoxFit.cover);

    case TierItemImageType.network:
      return Image.network(
        item.imageRef,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Pool image load failed: $error');
          return Image.asset('assets/images/tierlist.png', fit: BoxFit.cover);
        },
      );
  }
}
}
