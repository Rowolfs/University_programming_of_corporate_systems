import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_corner/smooth_corner.dart';

class TierList extends StatefulWidget {
  TierList({super.key, double? width, double? height})
    : width = width ?? 390.w,
      height = height ?? 469.h;
  final double width;
  final double height;
  @override
  State<TierList> createState() => _TierListState();
}

class _TierListState extends State<TierList> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row()

      ],




    );
  }
}


class TierListRow extends StatefulWidget {
  const TierListRow({super.key});

  @override
  State<TierListRow> createState() => _TierListRowState();
}

class _TierListRowState extends State<TierListRow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SmoothContainer(
              color: Color(0xFFFF7F7F),
            ),
            Container()
          ],
        )
      ],
    );
  }
}