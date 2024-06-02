import 'package:room_item_tracker/models/room_item.dart';

/// Base class for room items list states.
sealed class RoomItemsListState {}

/// Initial blank state.
final class RoomItemsListInitial extends RoomItemsListState {}

/// Currently loading items.
final class RoomItemsListLoading extends RoomItemsListState {}

/// Successfully loaded room item list data.
final class RoomItemsListLoadedData extends RoomItemsListState {
  /// The loaded items
  final List<RoomItem> items;

  RoomItemsListLoadedData({required this.items});
}
