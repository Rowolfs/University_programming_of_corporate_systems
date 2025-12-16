import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Heading extends StatelessWidget {
  final String text;
  final Color color;
  const Heading({super.key, required this.text, this.color = Colors.white});

  
  @override
  Widget build(context) {
    return Text(text, style: GoogleFonts.unbounded(
          fontSize: 24.sp,
          color: color,
          fontWeight: FontWeight.w600,
        ),);
  }
}