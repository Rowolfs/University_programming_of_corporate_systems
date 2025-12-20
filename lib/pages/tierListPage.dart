import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tier_list_app/widgets/actionAppBar.dart';
import 'package:tier_list_app/widgets/actionNavigationBar.dart';
import 'package:tier_list_app/widgets/tierList.dart';

class TierListPage extends StatelessWidget {
  final String tierlistId;

  const TierListPage({
    super.key,
    required this.tierlistId,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// ФОН — картинка
        const Positioned.fill(
          child: Image(
            image: AssetImage('assets/images/start_wallpaper.png'),
            fit: BoxFit.cover,
          ),
        ),

        /// ФОН — градиент
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF141E30),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        /// ОСНОВНОЙ Scaffold (как в HomePage)
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const ActionAppBar(),
          bottomNavigationBar: const ActionNavigationBar(),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: TierList(
                tierlistId: tierlistId,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
