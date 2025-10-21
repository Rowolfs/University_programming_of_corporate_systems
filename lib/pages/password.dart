import 'package:flutter/material.dart';
import 'package:design_mapping/widgets/app_text_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:design_mapping/widgets/apply_button.dart';



class Password extends StatelessWidget {
  const Password({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( body: Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
      Positioned(child: IgnorePointer(
        child: SizedBox(
         child:  SvgPicture.asset(
            'assets/images/password_bubbles.svg',
            fit: BoxFit.contain,
            alignment: Alignment.topLeft,
          ),
        )
      )),

    SafeArea(
      child: Container(
         padding: EdgeInsets.only(top: 282.h),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             Text(
              "Hello!",
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w700,
                  fontSize: 28.sp,
                  height: 1.28.h,
                ),
              ),
              SizedBox(height: 30.h ,),
              Text(
                  "Type your password",
                    style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w300,
                      fontSize: 19.sp,
                      height: 1.08.h,
                    ),
                  ),
           ],
         ),
      ),
    ),

SafeArea(child: Container(
      margin: EdgeInsets.only(top: 509.h, left: 21.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(hint: 'Password'),
          SizedBox(height: 82.63.w),
          DoneButton(onPressed: () {}, label: "Start"),
          SizedBox(height: 14.h,),
          Padding(
            padding: EdgeInsets.only(left: 145.w),
            child: GestureDetector(
              child: Text("Cancel", 
              
                style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w300,
                fontSize: 15.sp,
                height: 1.73.h,
                
              ),
            ),
            onTap: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    ))
    

    ],
    ),
    );
  }
}