import 'package:get_it/get_it.dart';
import 'package:room_item_tracker/services/implementations/fileio.dart';
import 'package:room_item_tracker/services/storage.dart';

final locator = GetIt.instance;

void setupServiceLocators() {
  locator.registerSingleton<RoomStorageService>(FileBasedRoomStorageService());
}
