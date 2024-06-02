import 'package:equatable/equatable.dart';
import 'package:room_item_tracker/models/room_item.dart';

/// Base class for room items list states.
sealed class RoomItemsListState extends Equatable {}

/// Initial blank state.
final class RoomItemsListInitial extends RoomItemsListState {
  @override
  List<Object> get props => [];
}

/// Currently loading items.
final class RoomItemsListLoading extends RoomItemsListState {
  @override
  List<Object> get props => [];
}

/// Successfully loaded room item list data.
final class RoomItemsListLoadedData extends RoomItemsListState {
  /// The loaded items
  final List<RoomItem> items;

  @override
  List<Object> get props => [items];

  RoomItemsListLoadedData({required this.items});
}
