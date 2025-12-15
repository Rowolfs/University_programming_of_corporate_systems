import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const ActionButton({super.key, required this.label, required this.onPressed});
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(306.w, 55.h),
        backgroundColor: Color(0xFFFF7B64),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10.r)
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