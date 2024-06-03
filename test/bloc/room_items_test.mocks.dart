// Mocks generated by Mockito 5.4.4 from annotations
// in room_item_tracker/test/bloc/room_items_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:room_item_tracker/models/room.dart' as _i4;
import 'package:room_item_tracker/models/room_item.dart' as _i5;
import 'package:room_item_tracker/services/seed_items.dart' as _i6;
import 'package:room_item_tracker/services/storage.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [RoomStorageService].
///
/// See the documentation for Mockito's code generation for more information.
class MockRoomStorageService extends _i1.Mock
    implements _i2.RoomStorageService {
  @override
  _i3.Future<void> writeRooms(List<_i4.Room>? rooms) => (super.noSuchMethod(
        Invocation.method(
          #writeRooms,
          [rooms],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> writeItems(List<_i5.RoomItem>? roomItems) =>
      (super.noSuchMethod(
        Invocation.method(
          #writeItems,
          [roomItems],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<List<_i5.RoomItem>> readItems() => (super.noSuchMethod(
        Invocation.method(
          #readItems,
          [],
        ),
        returnValue: _i3.Future<List<_i5.RoomItem>>.value(<_i5.RoomItem>[]),
        returnValueForMissingStub:
            _i3.Future<List<_i5.RoomItem>>.value(<_i5.RoomItem>[]),
      ) as _i3.Future<List<_i5.RoomItem>>);

  @override
  _i3.Future<List<_i4.Room>> readRooms() => (super.noSuchMethod(
        Invocation.method(
          #readRooms,
          [],
        ),
        returnValue: _i3.Future<List<_i4.Room>>.value(<_i4.Room>[]),
        returnValueForMissingStub:
            _i3.Future<List<_i4.Room>>.value(<_i4.Room>[]),
      ) as _i3.Future<List<_i4.Room>>);
}

/// A class which mocks [SeedItemsService].
///
/// See the documentation for Mockito's code generation for more information.
class MockSeedItemsService extends _i1.Mock implements _i6.SeedItemsService {
  @override
  _i3.Future<List<_i5.RoomItem>> getSeedItems() => (super.noSuchMethod(
        Invocation.method(
          #getSeedItems,
          [],
        ),
        returnValue: _i3.Future<List<_i5.RoomItem>>.value(<_i5.RoomItem>[]),
        returnValueForMissingStub:
            _i3.Future<List<_i5.RoomItem>>.value(<_i5.RoomItem>[]),
      ) as _i3.Future<List<_i5.RoomItem>>);
}