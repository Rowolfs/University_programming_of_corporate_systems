import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_corner/smooth_corner.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed; // <-- было VoidCallback

  const ActionButton({
    super.key,
    required this.label,
    this.onPressed, // <-- было required
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, // <-- теперь можно null
      style: ElevatedButton.styleFrom(
        fixedSize: Size(306.w, 55.h),
        backgroundColor: const Color(0xFFFF7B64),
        shape: SmoothRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10.r),
          smoothness: 1,
        ),
        elevation: 4,
      ),
      child: Text(
        label,
        style: GoogleFonts.unbounded(
          fontSize: 13.sp,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
