import 'package:get_it/get_it.dart';
import 'package:room_item_tracker/services/implementations/hive.dart';
import 'package:room_item_tracker/services/implementations/seed_items.dart';
import 'package:room_item_tracker/services/seed_items.dart';
import 'package:room_item_tracker/services/storage.dart';

final locator = GetIt.instance;

void setupServiceLocators() {
  locator.registerSingleton<RoomStorageService>(HiveBasedStorageService());
  locator.registerSingleton<SeedItemsService>(AssetBundleSeedItemsService());
}
