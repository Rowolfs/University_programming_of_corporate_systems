import 'package:flutter/material.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:tier_list_app/pages/greetingsPage.dart';
import 'package:tier_list_app/pages/homePage.dart';
import 'package:tier_list_app/pages/searchPage.dart';
import 'package:tier_list_app/pages/tierListPage.dart';
import 'package:tier_list_app/services/tierlists_service.dart';

class ActionNavigationBar extends StatelessWidget {
  const ActionNavigationBar({super.key});

  Future<void> _createEmptyTierlistAndOpen(BuildContext context) async {
    try {
      final service = TierlistsService();

      // Создаём пустой тирлист с дефолтным названием.
      // В редакторе на странице пользователь поменяет title.
      final row = await service.createTierlist(title: 'Новый тирлист');
      // Важно: createTierlist должен возвращать строку (insert().select()) [web:241][web:226]
      final id = row['id'].toString();

      if (!context.mounted) return;

      // Можно pushReplacement, чтобы не копить страницы,
      // но обычно для "создал и открыл" норм и push.
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TierListPage(tierlistId: id)),
      );
    } catch (e) {
      debugPrint('Create tierlist error: $e');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось создать тирлист'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

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
        onTap: (index) async {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              ); // replace чтобы не копить страницы [web:261]
              break;

            case 1:
              await _createEmptyTierlistAndOpen(context);
              break;

            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SearchPage()),
              ); // replace чтобы не копить страницы [web:261]
              break;
          }
        },
      ),
    );
  }
}
