import 'package:bloc/bloc.dart';
import 'package:room_item_tracker/bloc/room_items/room_items_events.dart';
import 'package:room_item_tracker/bloc/room_items/room_items_state.dart';
import 'package:room_item_tracker/models/room_item.dart';
import 'package:room_item_tracker/services/seed_items.dart';
import 'package:room_item_tracker/services/storage.dart';
import 'package:room_item_tracker/utils/injection.dart';

class RoomItemsListBloc extends Bloc<RoomItemsListEvent, RoomItemsListState> {
  final _storageService = locator.get<RoomStorageService>();
  final _seedItemsService = locator.get<SeedItemsService>();

  RoomItemsListBloc() : super(RoomItemsListInitial()) {
    on<RoomItemsListLoadEvent>(onLoad);
    on<RoomItemsListAddCustomRoomItemEvent>(onAddCustomRoomItem);
    on<RoomItemsListRemoveItemEvent>(onRemoveItem);
    on<RoomItemsListResetWithSeedItemsEvent>(onReseedItems);
  }

  /// Load items from storage
  Future<void> onLoad(
      RoomItemsListLoadEvent event, Emitter<RoomItemsListState> emit) async {
    emit(RoomItemsListLoading());
    final result = await _storageService.readItems();
    final List<RoomItem> loadedItems = result.isEmpty
        ? List.from(await _seedItemsService.getSeedItems())
        : List.from(result);

    emit(RoomItemsListLoadedData(items: loadedItems));
  }

  /// Add a custom item, save to storage, and emit loaded
  Future<void> onAddCustomRoomItem(RoomItemsListAddCustomRoomItemEvent event,
      Emitter<RoomItemsListState> emit) async {
    if (state is RoomItemsListLoadedData) {
      final loadedDataState = state as RoomItemsListLoadedData;
      final nextItemId = loadedDataState.items
          .fold(0, (max, e) => e.id > max ? e.id + 1 : max);
      final updatedItemList = [
        ...loadedDataState.items,
        event.item.copyWith(id: nextItemId)
      ];

      await _storageService.writeItems(updatedItemList);
      emit(RoomItemsListLoadedData(items: updatedItemList));
    }
  }

  /// Remove an item from the list, save to storage, and emit loaded
  Future<void> onRemoveItem(RoomItemsListRemoveItemEvent event,
      Emitter<RoomItemsListState> emit) async {
    if (state is RoomItemsListLoadedData) {
      final loadedDataState = state as RoomItemsListLoadedData;
      final updatedItemList = [
        for (final it in loadedDataState.items)
          if (it != event.item) it
      ];

      await _storageService.writeItems(updatedItemList);
      emit(RoomItemsListLoadedData(items: updatedItemList));
    }
  }

  /// Reset item list to seeded items, save to storage, and emit loaded
  Future<void> onReseedItems(RoomItemsListResetWithSeedItemsEvent event,
      Emitter<RoomItemsListState> emit) async {
    if (state is RoomItemsListLoadedData) {
      final seedItems = await _seedItemsService.getSeedItems();

      print('done reseeding items');
      await _storageService.writeItems(seedItems);
      emit(RoomItemsListLoadedData(items: seedItems));
    }
  }
}
