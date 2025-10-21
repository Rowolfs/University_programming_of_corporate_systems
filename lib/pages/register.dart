import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:design_mapping/widgets/app_text_field.dart';
import 'package:design_mapping/widgets/apply_button.dart';
import 'package:design_mapping/pages/login.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [

          Positioned( 
            child: IgnorePointer(
              child: SizedBox(
                child: SvgPicture.asset(
                  'assets/images/register_bubbles.svg',
                  fit: BoxFit.contain,
                  alignment: Alignment.topLeft,
                ),
              ),
            ),
          ),


          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container( padding: EdgeInsets.only(left: 30.w, top: 122.h),
                    child: Text(
                    "Create\nAccount",
                    style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w700,
                      fontSize: 50.sp,
                      height: 1.08.sp,
                    ),
                  ),
                ),

Container(
  margin: EdgeInsets.only(left: 20.w, right: 20.w,  top: 176.h ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppTextField(
        hint: 'Email',
        keyboardType: TextInputType.emailAddress,
      ),
      SizedBox(height: 12.h),

      AppTextField(
        hint: 'Password',
        obscure: true,
        suffix: Icon(Icons.visibility_off, size: 20.sp, color: const Color(0xFF6B5DB0)),
      ),
      SizedBox(height: 12.h),

      AppTextField(
        hint: 'Your number',
        keyboardType: TextInputType.phone,
        // пример с флажком и вертикальным разделителем слева
        prefix: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 12.w),
            // тут поставь свой флаг/иконку
            ClipRRect(
              borderRadius: BorderRadius.circular(3.95.r),
              child: Image.asset(
              'assets/images/russian_flag.png',
              width: 18.w,
              height: 18.h,
              fit: BoxFit.contain,
              
            ),
            ),
            SizedBox(width: 8.w),
            Container(width: 1, height: 20.h, color: const Color(0xFFDBDBDB)),
            SizedBox(width: 8.w),
          ],
        ),
      ),
    ],
  ),
),
    Padding(
    padding: EdgeInsets.only(top: 28.h, left: 20.w, right: 20.w),
    child: DoneButton( label: "Done",
      onPressed: () { Navigator.push(context,MaterialPageRoute(builder: (context) => Login()));
      },
    ),
  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

