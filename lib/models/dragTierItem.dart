import 'package:tier_list_app/models/tierItem.dart';

class DragTierItem {
  final TierItem item;
  final String fromTier;

  const DragTierItem({
    required this.item,
    required this.fromTier,
  });
}
