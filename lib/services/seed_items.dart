import 'package:room_item_tracker/models/room_item.dart';

abstract class SeedItemsService {
  Future<List<RoomItem>> getSeedItems();
}
