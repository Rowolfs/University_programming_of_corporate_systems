import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DoneButton extends StatelessWidget {
  const DoneButton({super.key, required this.onPressed, required this.label});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 335.w,   // ширина по макету
      height: 61.h,   // высота по макету
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,                              // без тени
          backgroundColor: const Color(0xFF0057FF),  // ярко-синий (#0057FF)
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r), // скругления по макету
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.nunitoSans(
            fontSize: 22.sp,          // ~17–18 px в макете
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
