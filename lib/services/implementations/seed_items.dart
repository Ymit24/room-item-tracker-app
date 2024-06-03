import 'package:room_item_tracker/models/room_item.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:room_item_tracker/services/seed_items.dart';

class AssetBundleSeedItemsService extends SeedItemsService {
  @override
  Future<List<RoomItem>> getSeedItems() async {
    final items = <RoomItem>[];
    var itemId = 0;
    try {
      final lines = await rootBundle.loadString('assets/data/seedItems.csv');
      for (var line in lines.split("\n")) {
        items.add(RoomItem(id: itemId++, name: line));
      }
    } catch (e) {
      print(e);
    }
    return items;
  }
}
