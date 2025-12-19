import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ActionAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0, 
      automaticallyImplyLeading: false,
      titleSpacing: 20.w,
      title: SvgPicture.asset(
        'assets/vectors/Tierly.svg',
        height: 24,
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20.w),
          child: SvgPicture.asset(
            'assets/icons/user.svg',
            height: 35.h,
          ),
        ),
      ],
    );
  }
}
