import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_corner/smooth_corner.dart';

import 'package:tier_list_app/models/dragTierItem.dart';
import 'package:tier_list_app/models/tierItem.dart';

class TierListRow extends StatelessWidget {
  final String tierChar;
  final Color tierColor;
  final List<TierItem> items;

  final void Function(TierItem item, String fromTier) onAccept;

  const TierListRow({
    super.key,
    required this.tierChar,
    required this.tierColor,
    required this.items,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<DragTierItem>(
      onAccept: (data) => onAccept(data.item, data.fromTier),
      builder: (context, candidateData, rejectedData) {
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTierLabel(),
              Expanded(child: _buildItemsArea()),
              _buildActions(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTierLabel() {
    return SmoothContainer(
      width: 80.w,
      smoothness: 0.6,
      color: tierColor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(4.r),
        bottomLeft: Radius.circular(4.r),
      ),
      child: Center(
        child: Text(
          tierChar,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildItemsArea() {
    return Container(
      color: const Color(0xFF1E1E1E),
      padding: EdgeInsets.all(4.w),
      child: Wrap(
        spacing: 4.w,
        runSpacing: 4.h,
        children: items.map((item) {
          return Draggable<DragTierItem>(
            data: DragTierItem(item: item, fromTier: tierChar),
            feedback: _buildItem(item, dragging: true),
            childWhenDragging: Opacity(opacity: 0.3, child: _buildItem(item)),
            child: _buildItem(item),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildItem(TierItem item, {bool dragging = false}) {
    final Widget image = switch (item.imageType) {
      TierItemImageType.asset => Image.asset(item.imageRef, fit: BoxFit.cover),
      TierItemImageType.file => Image.file(File(item.imageRef), fit: BoxFit.cover),
      TierItemImageType.network => Image.network(item.imageRef, fit: BoxFit.cover),
    };

    return Container(
      width: 50.w,
      height: 50.w,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        boxShadow: dragging
            ? const [BoxShadow(color: Colors.black45, blurRadius: 8)]
            : null,
      ),
      child: image,
    );
  }

  Widget _buildActions() {
    return Container(
      width: 40.w,
      color: const Color(0xFF0F0F0F),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIcon(Icons.settings),
          _buildIcon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon) {
    return Icon(icon, color: Colors.white54, size: 20.sp);
  }
}
