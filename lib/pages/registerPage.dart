import 'package:flutter/material.dart';
import 'package:tier_list_app/pages/homePage.dart';
import 'package:tier_list_app/widgets/actionModal.dart';
import 'package:tier_list_app/widgets/actionEditLine.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tier_list_app/widgets/actionHeading.dart';
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

class RegisterPageVertical extends StatefulWidget {
  const RegisterPageVertical({super.key});

  @override
  State<RegisterPageVertical> createState() => _RegisterPageVerticalState();
}

class _RegisterPageVerticalState extends State<RegisterPageVertical> {
  @override
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset('assets/images/start_wallpaper.png', fit: BoxFit.cover,), 
      ActionModal(label: "Зарегистрироваться", onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())),  
      children: [
        SizedBox(height: 38.h),
        ActionHeading(text: "Добро пожаловать"),
        SizedBox(height: 45.h),
        ActionEditLine(label: "Логин",onChanged: VoidCallbackAction.new, onSubmitted: VoidCallbackAction.new),
        SizedBox(height: 20.h),
        ActionEditLine(label: "Пароль", obscureText: _obscureText1,
          suffixIcon: IconButton(onPressed: (){
            setState(() {
              _obscureText1 = !_obscureText1; 
            });
          }, icon: _obscureText1 ? Icon(Icons.visibility_off) : Icon(Icons.visibility) ),
        ),
        SizedBox(height: 20.h,),
        ActionEditLine(label: "Пароль", obscureText: _obscureText2,
          suffixIcon: IconButton(onPressed: (){
            setState(() {
              _obscureText2 = !_obscureText2; 
            });
          }, icon: _obscureText2 ? Icon(Icons.visibility_off) : Icon(Icons.visibility) ),
        ),
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



