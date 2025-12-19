enum TierItemImageType { asset, file, network }

class TierItem {
  final String id;

  // Картинка
  final TierItemImageType imageType;
  final String imageRef; // путь к asset / путь к файлу / URL

  // Метаданные
  final String title;
  final String description;

  /// null = бесплатно; иначе в "копейках/центах" (199 = 1.99)
  final int? priceMinor;

  const TierItem({
    required this.id,
    required this.imageType,
    required this.imageRef,
    required this.title,
    required this.description,
    this.priceMinor,
  });

  const TierItem.asset({
    required this.id,
    required this.imageRef,
    required this.title,
    required this.description,
    this.priceMinor,
  }) : imageType = TierItemImageType.asset;

  const TierItem.file({
    required this.id,
    required this.imageRef,
    required this.title,
    required this.description,
    this.priceMinor,
  }) : imageType = TierItemImageType.file;

  const TierItem.network({
    required this.id,
    required this.imageRef,
    required this.title,
    required this.description,
    this.priceMinor,
  }) : imageType = TierItemImageType.network;
}
