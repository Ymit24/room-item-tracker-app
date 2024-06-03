import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:room_item_tracker/bloc/rooms/rooms_events.dart';
import 'package:room_item_tracker/bloc/rooms/rooms_state.dart';
import 'package:room_item_tracker/models/room.dart';
import 'package:room_item_tracker/models/seed_models.dart';
import 'package:room_item_tracker/services/storage.dart';
import 'package:room_item_tracker/utils/injection.dart';

/// Bloc for Room list
class RoomListBloc extends Bloc<RoomListEvent, RoomListState> {
  final _storageService = locator.get<RoomStorageService>();

  RoomListBloc() : super(RoomListInitial()) {
    on<RoomListLoadEvent>(onLoad);
    on<RoomListToggleRoomStatusEvent>(onToggleRoomStatus);
    on<RoomListAddItemToRoomEvent>(onAddItemToRoom);
    on<RoomListRemoveItemFromRoomEvent>(onRemoveItemFromRoom);
    on<RoomListClearRoomEvent>(onClearRoom);
    on<RoomListClearAllRoomsEvent>(onClearAllRooms);
    on<RoomListRemoveItemFromAllRoomsEvent>(onRemoveItemFromAllRooms);
  }

  /// Load the list of rooms from the storage service.
  Future<void> onLoad(
      RoomListLoadEvent event, Emitter<RoomListState> emit) async {
    final result = await _storageService.readRooms();
    if (result.isEmpty) {
      emit(RoomListLoadedData(rooms: seedRooms));
    } else {
      emit(RoomListLoadedData(rooms: List.from(result)));
    }
  }

  /// Toggle the status of a room, save to storage, and emit loaded.
  Future<void> onToggleRoomStatus(
      RoomListToggleRoomStatusEvent event, Emitter<RoomListState> emit) async {
    if (state is RoomListLoadedData) {
      final loadedDataState = state as RoomListLoadedData;
      final updatedRoomList = [
        for (final room in loadedDataState.rooms)
          if (room.id == event.roomId)
            room.copyWith(status: room.status.nextToggleState())
          else
            room
      ];
      await _storageService.writeRooms(loadedDataState.rooms);
      emit(RoomListLoadedData(rooms: updatedRoomList));
    }
  }

  /// Add an item to the room, save to storage, and emit loaded.
  Future<void> onAddItemToRoom(
      RoomListAddItemToRoomEvent event, Emitter<RoomListState> emit) async {
    print('adding an item to a room! $state');
    if (state is RoomListLoadedData) {
      final loadedDataState = state as RoomListLoadedData;
      final updatedRoomList = [
        for (final room in loadedDataState.rooms)
          if (room.id == event.roomId)
            room.copyWith(presentItems: [...room.presentItems, event.item])
          else
            room
      ];

      emit(RoomListLoadedData(rooms: updatedRoomList));
      await _storageService.writeRooms(updatedRoomList);
    }
  }

  /// Remove an item to the room, save to storage, and emit loaded.
  Future<void> onRemoveItemFromRoom(RoomListRemoveItemFromRoomEvent event,
      Emitter<RoomListState> emit) async {
    print('Removing item from room! State: $state');
    if (state is RoomListLoadedData) {
      final loadedRooms = (state as RoomListLoadedData).rooms;
      final updatedRoomList = [
        for (final room in loadedRooms)
          if (room.id != event.roomId)
            room
          else
            room.copyWith(presentItems: [
              for (final it in room.presentItems)
                if (it != event.item) it
            ])
      ];

      print("UpdatedRoomList: $updatedRoomList");

      emit(RoomListLoadedData(rooms: updatedRoomList));
      await _storageService.writeRooms(updatedRoomList);
    }
  }

  /// Clear a room, save to storage, and emit loaded.
  Future<void> onClearRoom(
      RoomListClearRoomEvent event, Emitter<RoomListState> emit) async {
    if (state is RoomListLoadedData) {
      final loadedDataState = state as RoomListLoadedData;
      final updatedRoomList = [
        for (final room in loadedDataState.rooms)
          if (room.id == event.roomId) room.copyWith(presentItems: []) else room
      ];

      await _storageService.writeRooms(loadedDataState.rooms);
      emit(RoomListLoadedData(rooms: updatedRoomList));
    }
  }

  /// Clear all rooms, save to storage, and emit loaded.
  Future<void> onClearAllRooms(
      RoomListClearAllRoomsEvent event, Emitter<RoomListState> emit) async {
    if (state is RoomListLoadedData) {
      final loadedDataState = state as RoomListLoadedData;
      final updatedRoomList = [
        for (final room in loadedDataState.rooms)
          room.copyWith(presentItems: [], status: RoomStatus.Unknown)
      ];

      await _storageService.writeRooms(loadedDataState.rooms);
      emit(RoomListLoadedData(rooms: updatedRoomList));
    }
  }

  /// Remove an item from all rooms, save to storage, and emit loaded.
  Future<void> onRemoveItemFromAllRooms(
      RoomListRemoveItemFromAllRoomsEvent event,
      Emitter<RoomListState> emit) async {
    if (state is RoomListLoadedData) {
      final loadedRooms = (state as RoomListLoadedData).rooms;
      final updatedRoomList = <Room>[
        for (final room in loadedRooms)
          if (room.presentItems.contains(event.item))
            room.copyWith(presentItems: [
              for (final it in room.presentItems)
                if (it != event.item) it
            ])
          else
            room
      ];

      await _storageService.writeRooms(updatedRoomList);
      emit(RoomListLoadedData(rooms: updatedRoomList));
    }
  }
}
