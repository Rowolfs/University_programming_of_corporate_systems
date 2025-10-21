import 'package:flutter/material.dart';
import 'package:design_mapping/pages/register.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Устанавливаем размер окна
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(375, 812), // нужный размер окна
      center: true,
      title: 'Design Mapping',
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const DesignMapping(),
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white,
          ),
        );
      },
    );
  }
}

class DesignMapping extends StatelessWidget {
  const DesignMapping({super.key});

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      body: Login(),
    );
  }
}

