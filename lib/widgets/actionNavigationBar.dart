import 'package:flutter/material.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tier_list_app/pages/greetingsPage.dart';
import 'package:tier_list_app/pages/homePage.dart';

class ActionNavigationBar extends StatelessWidget {
  const ActionNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SmoothClipRRect(
      smoothness: 1,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(17.r),
        topRight: Radius.circular(17.r),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.black.withAlpha(180),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/icons/home.svg"),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/icons/plus.svg"),
            label: 'Plus',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/icons/search.svg"),
            label: 'Search',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HomePage(),
                ),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const GreetingsPage(),
                ),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const GreetingsPage(),
                ),
              );
              break;
          }
        },
      ),
    );
  }
}
