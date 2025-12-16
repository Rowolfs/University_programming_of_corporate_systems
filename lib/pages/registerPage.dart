import 'package:flutter/material.dart';
import 'package:tier_list_app/widgets/modal.dart';
import 'package:tier_list_app/widgets/actionEditLine.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tier_list_app/widgets/heading.dart';
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});
  

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return isLandscape ?  RegisterPageVertical() : RegisterPageVertical();
  }
}


class RegisterPageHorizontal extends StatelessWidget {
  const RegisterPageHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class RegisterPageVertical extends StatelessWidget {
  const RegisterPageVertical({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset('assets/images/start_wallpaper.png', fit: BoxFit.cover,), 
      Modal(label: "Зарегистрироваться", onPressed: VoidCallbackAction.new,  
      children: [
        SizedBox(height: 38.h),
        Heading(text: "Добро пожаловать"),
        SizedBox(height: 45.h),
        ActionEditLine(label: "Логин",onChanged: VoidCallbackAction.new, onSubmitted: VoidCallbackAction.new),
        SizedBox(height: 20.h),
        ActionEditLine(label: "Пароль",onChanged: VoidCallbackAction.new, onSubmitted: VoidCallbackAction.new),
        SizedBox(height: 20.h,),
        ActionEditLine(label: "Повторный пароль",onChanged: VoidCallbackAction.new, onSubmitted: VoidCallbackAction.new),
        SizedBox(height: 40.h,),
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
