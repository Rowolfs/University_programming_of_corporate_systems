import 'package:flutter/material.dart';
import 'package:tier_list_app/pages/homePage.dart';
import 'package:tier_list_app/widgets/actionModal.dart';
import 'package:tier_list_app/widgets/actionEditLine.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tier_list_app/widgets/actionHeading.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});
  

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return isLandscape ?  SignInPageVertical() : SignInPageVertical();
  }
}


class SignInPageHorizontal extends StatelessWidget {
  const SignInPageHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class SignInPageVertical extends StatefulWidget {
  const SignInPageVertical({super.key});

  @override
  State<SignInPageVertical> createState() => _SignInPageVerticalState();
}

class _SignInPageVerticalState extends State<SignInPageVertical> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset('assets/images/start_wallpaper.png', fit: BoxFit.cover,), 
      ActionModal(label: "Войти", onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())),  
      children: [
        SizedBox(height: 38.h),
        ActionHeading(text: "Добро пожаловать"),
        SizedBox(height: 45.h),
        ActionEditLine(label: "Логин"),
        SizedBox(height: 20.h),
        ActionEditLine(label: "Пароль",keyboardType: TextInputType.visiblePassword, obscureText: _obscureText,
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
        ),
        SizedBox(height: 40.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          
          GestureDetector(onTap: (null), child: Image.asset("assets/icons/google.png",width: 40.w,height: 40.h)),
          SizedBox(width: 20.w),
          GestureDetector(onTap: (null), child: Image.asset("assets/icons/vk.png",width: 40.w,height: 40.h)),
          SizedBox(width: 20.w),
          GestureDetector(onTap: (null), child: Image.asset("assets/icons/yandex.png",width: 40.w,height: 40.h))
 
        ],)
      ])
    ]);
  }

  }
