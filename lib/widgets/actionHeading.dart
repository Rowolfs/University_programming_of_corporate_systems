import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ActionHeading extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  const ActionHeading({super.key, required this.text, this.color = Colors.white, this.fontSize = 24});

  
  @override
  Widget build(context) {
    return Text(text, style: GoogleFonts.unbounded(
          fontSize: fontSize,
          color: color,
          fontWeight: FontWeight.w600,
        ),);
  }
}