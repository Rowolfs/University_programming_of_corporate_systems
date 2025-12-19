import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tier_list_app/models/tierItem.dart';
import 'package:tier_list_app/widgets/tierListRow.dart';
import 'package:tier_list_app/widgets/tierListItemPoolBar.dart';
import 'package:tier_list_app/widgets/createCardDialog.dart';

class TierList extends StatefulWidget {
  const TierList({super.key, double? width, double? height})
      : width = width ?? 390,
        height = height ?? 469;

  final double width;
  final double height;

  @override
  State<TierList> createState() => _TierListState();
}

class _TierListState extends State<TierList> {
  /// ДАННЫЕ ТИРОВ
  final List<Map<String, dynamic>> _tiersData = const [
    {'char': 'S', 'color': Color(0xFFFF7F7F)},
    {'char': 'A', 'color': Color(0xFFFFBF7F)},
    {'char': 'B', 'color': Color(0xFFFFDF7F)},
    {'char': 'C', 'color': Color(0xFFFFFF7F)},
    {'char': 'D', 'color': Color(0xFFBFFF7F)},
  ];

  /// ЭЛЕМЕНТЫ ПО ТИРАМ
  Map<String, List<TierItem>> tierItems = {};

  /// НИЖНИЙ ПУЛ (селектор)
  List<TierItem> poolItems = [];

  @override
  void initState() {
    super.initState();

    tierItems = {
  'S': [],
  'A': [
      TierItem.asset(
      id: '1',
      imageRef: 'assets/images/tierlist.png',
      title: 'Твоя карточка',
      description: 'Описание...',
      priceMinor: null,
    ),
    TierItem.asset(
      id: '2',
      imageRef: 'assets/images/tierlist.png',
      title: 'Твоя карточка',
      description: 'Описание...',
      priceMinor: null,
    ),
  ],
  'B': [],
  'C': [],
  'D': [],
};

    poolItems = <TierItem>[
      TierItem.asset(
      id: '3',
      imageRef: 'assets/images/tierlist.png',
      title: 'Твоя карточка',
      description: 'Описание...',
      priceMinor: null,
    ),
    TierItem.asset(
      id: '4',
      imageRef: 'assets/images/tierlist.png',
      title: 'Твоя карточка',
      description: 'Описание...',
      priceMinor: null,
    ),
    ];
  }

  /// ПЕРЕМЕЩЕНИЕ ЭЛЕМЕНТА МЕЖДУ ТИРАМИ / ИЗ ПУЛА В ТИР
  void moveItem(TierItem item, String fromTier, String toTier) {
  if (fromTier == toTier) return;

  setState(() {
    // remove from source
    if (fromTier == ItemPoolBar.poolTierKey) {
      poolItems.remove(item);
    } else {
      tierItems[fromTier]!.remove(item);
    }

    // add to destination
    if (toTier == ItemPoolBar.poolTierKey) {
      poolItems.add(item);
    } else {
      tierItems[toTier]!.add(item);
    }
  });
}
  Future<void> openCreateCardDialog() async {
  await showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black54,
    builder: (_) => CreateCardDialog(
      onSave: (item) {
        setState(() {
          tierItems['A']!.add(item); // временно добавляем в A
        });
      },
    ),
  );
}


  void onAddNew() {
    setState(() {
      openCreateCardDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width.w,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          ..._tiersData.map((tier) {
            final String tierChar = tier['char'] as String;
            final Color tierColor = tier['color'] as Color;

            return Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: TierListRow(
                tierChar: tierChar,
                tierColor: tierColor,
                items: tierItems[tierChar] ?? const [],
                onAccept: (item, fromTier) => moveItem(item, fromTier, tierChar),
              ),
            );
          }),

          SizedBox(height: 14.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: ItemPoolBar(
              items: poolItems,
              onAddNew: onAddNew,
              onAcceptFromTier: (item, fromTier) {
                moveItem(item, fromTier, ItemPoolBar.poolTierKey);
              },
            ),
          ),
        ],
      ),
    );
  }
}
