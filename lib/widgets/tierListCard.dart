import 'package:flutter/material.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tier_list_app/widgets/heading.dart';

class TierListCard extends StatelessWidget {
  const TierListCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SmoothContainer(
      smoothness: 1,
      borderRadius: BorderRadiusGeometry.circular(17.r),
      width: 120.w,
      height: 100.h,
      color: Color(0xFF101010),
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 12.h),
            Container( margin: EdgeInsets.all(10),
            child: Image.asset("assets/images/tierlist.png", fit: BoxFit.contain),
            ),
            
            SizedBox(height: 10.h),
            Row(children: [
              SizedBox(width: 5.w),
              SvgPicture.asset("assets/icons/user.svg", width: 25.w,height: 25.h,),
              SizedBox(width: 5.w),
              Heading(text: "Название тирлиста", fontSize: 10.sp,),

            ],)
          ],
        ),
      ),
    );
  }
}