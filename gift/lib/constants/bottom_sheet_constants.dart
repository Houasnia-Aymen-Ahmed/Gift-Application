import '../models/settings_list.dart';
import 'constants.dart';

class GiftImage {
  static const String giftCard = "assets/icon/gift-card.png";
  static const String butterfly = "assets/icon/butterfly.png";
  static const String squareHeart = "assets/icon/square-heart.png";
}

class GiftOption {
  final String id;
  final String label;
  final String asset;
  const GiftOption({
    required this.id,
    required this.label,
    required this.asset,
  });
}

class GiftCatalog {
  static const List<GiftOption> options = [
    GiftOption(id: 'heart', label: 'Heart', asset: GiftImage.squareHeart),
    GiftOption(
        id: 'butterfly', label: 'Butterfly', asset: GiftImage.butterfly),
    GiftOption(id: 'card', label: 'Gift Card', asset: GiftImage.giftCard),
  ];

  static GiftOption byId(String id) => options.firstWhere(
        (option) => option.id == id,
        orElse: () => options.first,
      );
}

class OtherConstants {
  static List<SettingList> items = itemsFromConstants;
}