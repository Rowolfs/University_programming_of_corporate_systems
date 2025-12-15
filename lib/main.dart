import 'package:flutter/material.dart';
import 'package:tier_list_app/pages/tierListPage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 844)
      builder: (context,child){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tierlist',
        home: const TierListPage(),
        );
      }
    );
  }
}
