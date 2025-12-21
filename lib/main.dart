import 'package:flutter/material.dart';
import 'package:tier_list_app/pages/greetingsPage.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SB_URL']!,
    anonKey: dotenv.env['SB_ANON_KEY']!,
  );
  runApp(const TierlyApp());
}

class TierlyApp extends StatelessWidget {
  const TierlyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 844),
      builder: (context,child){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tierlist',
        home: const GreetingsPage(),
        );
      }
    );
  }
}
