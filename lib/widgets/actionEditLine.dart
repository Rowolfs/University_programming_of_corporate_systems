import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_corner/smooth_corner.dart';


class ActionEditLine extends StatefulWidget {
  const ActionEditLine({super.key, required this.onChanged, required this.onSubmitted, required this.label});
  final VoidCallback onChanged;
  final VoidCallback onSubmitted;
  final String label;

  @override
  State<ActionEditLine> createState() => _ActionEditLineState();
}

class _ActionEditLineState extends State<ActionEditLine> {
  late VoidCallback onChanged;
  @override
  Widget build(BuildContext context) {
    return SmoothContainer(
      width: 306.w,
      height: 46.h,
      smoothness: 1,
      borderRadius: BorderRadiusGeometry.circular(8.r),
      child: TextField(
        style: GoogleFonts.unbounded(  // цвет плейсхолдера
            fontSize: 13.sp,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        decoration: InputDecoration(
          hintText: widget.label,
          hintStyle: GoogleFonts.unbounded(  // цвет плейсхолдера
            fontSize: 13.sp,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          filled: true,
          fillColor: const Color(0xFF2C2C2C),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) => widget.onChanged(),
        onSubmitted: (value) => widget.onSubmitted,
      ),
    );
  }
}