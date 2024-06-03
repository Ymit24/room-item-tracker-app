import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:room_item_tracker/bloc/room_items/room_items_bloc.dart';
import 'package:room_item_tracker/bloc/room_items/room_items_events.dart';
import 'package:room_item_tracker/bloc/room_items/room_items_state.dart';
import 'package:room_item_tracker/models/room_item.dart';
import 'package:room_item_tracker/services/seed_items.dart';
import 'package:room_item_tracker/services/storage.dart';

@GenerateNiceMocks(
    [MockSpec<RoomStorageService>(), MockSpec<SeedItemsService>()])
import 'room_items_test.mocks.dart';

void main() {
  final mockStorageService = MockRoomStorageService();
  final mockSeedItemService = MockSeedItemsService();
  final mockItemList = [RoomItem(id: 1, name: 'mock')];

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    GetIt.instance.registerSingleton<RoomStorageService>(mockStorageService);
    GetIt.instance.registerSingleton<SeedItemsService>(mockSeedItemService);
  });

  group('BlocTests', () {
    group('LoadEvent', () {
      blocTest<RoomItemsListBloc, RoomItemsListState>(
        'Handles load when items exist',
        build: () => RoomItemsListBloc(),
        setUp: () {
          when(mockStorageService.readItems())
              .thenAnswer((_) async => mockItemList);
        },
        act: (bloc) => bloc.add(RoomItemsListLoadEvent()),
        skip: 1,
        expect: () => [
         RoomItemsListLoadedData(
            items: mockItemList,
          )
        ],
      );
      blocTest<RoomItemsListBloc, RoomItemsListState>(
        'Handles load seed items when on items exist',
        build: () => RoomItemsListBloc(),
        setUp: () {
          when(mockStorageService.readItems()).thenAnswer((_) async => []);
          when(mockSeedItemService.getSeedItems()).thenAnswer(
            (_) async => [
              RoomItem(id: 1, name: 'mock'),
            ],
          );
        },
        act: (bloc) => bloc.add(RoomItemsListLoadEvent()),
        skip: 1,
        expect: () async => [
          RoomItemsListLoadedData(
            items: await mockSeedItemService.getSeedItems(),
          )
        ],
      );
    });
  });
}
