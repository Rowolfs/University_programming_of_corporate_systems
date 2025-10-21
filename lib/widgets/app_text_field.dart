import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.hint,
    this.obscure = false,
    this.keyboardType,
    this.prefix,
    this.suffix,
  });

  final String hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? prefix;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 335.w,          // ширина из макета
      height: 52.37.h,          // высота из макета (~52.37)
      child: TextField(
        obscureText: obscure,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: 16.sp),
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,                 // placeholder
          hintStyle: GoogleFonts.poppins(color: const Color(0xFFB7B7B7), fontSize: 16.sp),
          filled: true,
          fillColor: const Color(0xFFF8F8F8), // НЕпрозрачный серый
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,  // ≈ 19.76 из Figma
            vertical: 16.h,    // ≈ 15.81 из Figma
          ),
          prefixIcon: prefix,  // опционально
          suffixIcon: suffix,  // опционально (глазик и т.п.)

          // Пилл-форма без видимой рамки
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(60.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(60.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(60.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
