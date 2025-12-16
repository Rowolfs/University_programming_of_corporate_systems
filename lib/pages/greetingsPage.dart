import "package:flutter/material.dart";
import 'package:tier_list_app/pages/signInPage.dart';
import "package:tier_list_app/widgets/actionButton.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tier_list_app/pages/RegisterPage.dart';


class GreetingsPage extends StatelessWidget {
  const GreetingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return isLandscape ? GreetingsPageHorizontal() : GreetingsPageVertical();
  }
}


class GreetingsPageVertical extends StatelessWidget {
  const GreetingsPageVertical({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(child: Column(
          children: [
              SizedBox(height: 138.h),
              SvgPicture.asset("assets/vectors/Tierly.svg",width: 266.w, height: 94.h,),
              SizedBox(height: 149.h),
              ActionButton(label: "Войти", onPressed:() => Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage())) ),
              SizedBox(height: 30.h),
              ActionButton(label: "Регистрация", onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => RegisterPage())),),
            ],
        ),)

      ],
    );
  }
}

class GreetingsPageHorizontal extends StatelessWidget {
  const GreetingsPageHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("THIS IS horizontal"));
  }
}