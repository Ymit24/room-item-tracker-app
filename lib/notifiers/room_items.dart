import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:room_item_tracker/models/room_item.dart';
import 'package:room_item_tracker/services/storage.dart';
import 'package:room_item_tracker/utils/injection.dart';
import 'package:room_item_tracker/utils/seed_items.dart';

class RoomItemNotifier extends StateNotifier<List<RoomItem>> {
  final _storageService = locator.get<RoomStorageService>();
  RoomItemNotifier() : super([]);

  Future<void> loadFromFile() async {
    final result = await _storageService.readItems();

    if (result.isEmpty) {
      state = List.from(await readSeedItems());
    } else {
      state = List.from(result);
    }
  }

  void addCustomRoomItem(RoomItem item) {
    final nextItemId = state.fold(0, (max, e) => e.id > max ? e.id + 1 : max);
    state = [...state, item.copyWith(id: nextItemId)];
    _storageService.writeItems(state);
  }

  void removeItem(RoomItem item) {
    state = [
      for (final it in state)
        if (it != item) it
    ];
    _storageService.writeItems(state);
  }

  /// Reset the room state with the seed items.
  /// Performs a writeback to save the seed items immediately.
  Future<void> resetWithSeedItems() async {
    final seedItems = await readSeedItems();
    state = List.from(seedItems);
    _storageService.writeItems(state);
  }
}
