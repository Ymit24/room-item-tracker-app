import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class Room {
  final String name;
  bool status;
  final List<RoomItem> presentItems;

  Room({required this.name, required this.status, required this.presentItems});

  Room.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        status = json['status'],
        presentItems = (jsonDecode(json['presentItems']) as List)
            .map((raw) => RoomItem.fromJson(raw))
            .toList();

  Map<String, dynamic> toJson() => {
        'name': name,
        'status': status,
        'presentItems': jsonEncode(presentItems),
      };
}

class RoomItem {
  final String name;

  RoomItem({required this.name});

  RoomItem.fromJson(Map<String, dynamic> json) : name = json['name'];
  Map<String, dynamic> toJson() => {'name': name};

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is RoomItem && name == other.name;

  @override
  int get hashCode => name.hashCode;
}

final List<RoomItem> roomItems = <RoomItem>[];
final List<Room> rooms = <Room>[];

final List<Room> seedRooms = <Room>[
  Room(name: "Room 1", presentItems: <RoomItem>[], status: false),
  Room(name: "Room 2", presentItems: <RoomItem>[], status: false),
  Room(name: "Room 2a", presentItems: <RoomItem>[], status: false),
  Room(name: "Room 3", presentItems: <RoomItem>[], status: false),
  Room(name: "Room 3a", presentItems: <RoomItem>[], status: false),
  Room(name: "Robot Room", presentItems: <RoomItem>[], status: false),
  Room(name: "Room 4", presentItems: <RoomItem>[], status: false),
  Room(name: "Room 5", presentItems: <RoomItem>[], status: false),
  Room(name: "Room 6", presentItems: <RoomItem>[], status: false),
  Room(name: "Room 7", presentItems: <RoomItem>[], status: false),
  Room(name: "Room 8", presentItems: <RoomItem>[], status: false),
  Room(name: "Vascular Suite", presentItems: <RoomItem>[], status: false),
  Room(name: "Room 9", presentItems: <RoomItem>[], status: false),
  Room(name: "Room 10", presentItems: <RoomItem>[], status: false),
  Room(name: "Room 11", presentItems: <RoomItem>[], status: false),
  Room(name: "Room 12", presentItems: <RoomItem>[], status: false),
  Room(name: "Room 14", presentItems: <RoomItem>[], status: false),
  Room(name: "Room 15", presentItems: <RoomItem>[], status: false),
  Room(name: "Room 16", presentItems: <RoomItem>[], status: false),
  Room(name: "Room 17", presentItems: <RoomItem>[], status: false),
  Room(name: "Room 18", presentItems: <RoomItem>[], status: false),
  Room(name: "Room 19", presentItems: <RoomItem>[], status: false),
  Room(name: "Room 20", presentItems: <RoomItem>[], status: false),
  Room(
      name: "Neuro Interventional Radiology",
      presentItems: <RoomItem>[],
      status: false),
  Room(name: "Cardiac Cath Lab", presentItems: <RoomItem>[], status: false),
  Room(name: "Burn Surgery Suite", presentItems: <RoomItem>[], status: false),
];

final List<RoomItem> seedItems = <RoomItem>[
  RoomItem(name: "ABG"),
  RoomItem(name: "14G"),
  RoomItem(name: "16G"),
  RoomItem(name: "18G"),
  RoomItem(name: "20G"),
  RoomItem(name: "22G"),
  RoomItem(name: "24G"),
  RoomItem(name: "25G"),
  RoomItem(name: "3cc"),
  RoomItem(name: "5cc"),
  RoomItem(name: "10cc"),
  RoomItem(name: "20cc"),
  RoomItem(name: "26cc"),
  RoomItem(name: "Art"),
  RoomItem(name: "Large TD"),
  RoomItem(name: "Small TD"),
  RoomItem(name: "Vamp"),
  RoomItem(name: "1L ISO"),
  RoomItem(name: "2L ISO"),
  RoomItem(name: "3L ISO"),
  RoomItem(name: "4L ISO"),
  RoomItem(name: "5L ISO"),
  RoomItem(name: "1L NS"),
  RoomItem(name: "2L NS"),
  RoomItem(name: "3L NS"),
  RoomItem(name: "4L NS"),
  RoomItem(name: "5L NS"),
  RoomItem(name: "500cc NS"),
  RoomItem(name: "2 500cc NS"),
  RoomItem(name: "250cc NS"),
  RoomItem(name: "50cc NS"),
  RoomItem(name: "100CC NS"),
  RoomItem(name: "Insulin Syringe"),
  RoomItem(name: "gravity"),
  RoomItem(name: "35"),
  RoomItem(name: "hotline"),
  RoomItem(name: "caresite"),
  RoomItem(name: "secondary"),
  RoomItem(name: "60"),
  RoomItem(name: "16 OG"),
  RoomItem(name: "18 OG"),
  RoomItem(name: "6 ET"),
  RoomItem(name: "6.5 ET"),
  RoomItem(name: "7 ET"),
  RoomItem(name: "7.5 ET"),
  RoomItem(name: "8 ET"),
  RoomItem(name: "8.5 ET"),
  RoomItem(name: "alcohol"),
  RoomItem(name: "flushes"),
  RoomItem(name: "heplocks"),
  RoomItem(name: "EKG"),
  RoomItem(name: "44"),
  RoomItem(name: "white pads"),
  RoomItem(name: "bio patches"),
  RoomItem(name: "sutures"),
  RoomItem(name: "MAC 3"),
  RoomItem(name: "MAC 4"),
  RoomItem(name: "Medium"),
  RoomItem(name: "Pediatric"),
  RoomItem(name: "Miller 2"),
  RoomItem(name: "Miller 3"),
  RoomItem(name: "tongue"),
  RoomItem(name: "stylets"),
  RoomItem(name: "Esophageal"),
  RoomItem(name: "Masks"),
  RoomItem(name: "Salters"),
  RoomItem(name: "Setup"),
  RoomItem(name: "Oxygen"),
  RoomItem(name: "Pump"),
  RoomItem(name: "Warmer"),
];

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _roomsFile async {
  final path = await _localPath;
  return File('$path/rooms.json');
}

Future<File> get _itemsFile async {
  final path = await _localPath;
  return File('$path/items.json');
}

Future<File> writeRooms() async {
  print("Writing rooms");
  final file = await _roomsFile;

  Map<String, dynamic> map = {'rooms': rooms.map((e) => e.toJson()).toList()};

  return file.writeAsString(json.encode(map));
}

Future<File> writeItems() async {
  print("Writing items");
  final file = await _itemsFile;
  Map<String, dynamic> map = {
    'items': roomItems.map((e) => e.toJson()).toList()
  };
  return file.writeAsString(json.encode(map));
}

Future<List<RoomItem>> readItems() async {
  final items = <RoomItem>[];
  try {
    final file = await _itemsFile;
    final contents = await file.readAsString();

    final jsonData = jsonDecode(contents);

    for (var item in jsonData['items']) {
      items.add(RoomItem.fromJson(item));
    }
  } catch (e) {
    print(e);
  }
  return items;
}

Future<List<Room>> readRooms() async {
  final roomsDecoded = <Room>[];
  try {
    final file = await _roomsFile;

    // Read the file
    final contents = await file.readAsString();

    final jsonData = jsonDecode(contents);
    for (var room in jsonData['rooms']) {
      roomsDecoded.add(Room.fromJson(room));
    }
  } catch (e) {
    print(e);
  }
  return roomsDecoded;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Item Room Tracker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    readRooms().then((result) {
      setState(() {
        if (result.isEmpty) {
          rooms.addAll(seedRooms);
          writeRooms();
        } else {
          rooms.clear();
          rooms.addAll(result);
        }

        print("Read Results: ${result.map((e) => e.toJson()).toList()}");
      });
    });

    readItems().then((result) {
      setState(() {
        if (result.isEmpty) {
          roomItems.addAll(seedItems);
          writeItems();
        } else {
          roomItems.clear();
          roomItems.addAll(result);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          ElevatedButton(
              onPressed: () {
                setState(() {
                  for (var room in rooms) {
                    room.presentItems.clear();
                    room.status = false;
                  }
                  writeRooms();
                });
              },
              child: const Text("Clear All Rooms"))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: rooms.length,
                  itemBuilder: (BuildContext context, int index) {
                    final room = rooms[index];
                    return RoomEntry(room: room);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class RoomEntry extends StatefulWidget {
  const RoomEntry({super.key, required this.room});

  final Room room;

  @override
  State<RoomEntry> createState() => _RoomEntryState();
}

class _RoomEntryState extends State<RoomEntry> {
  @override
  Widget build(BuildContext context) {
    final room = widget.room;
    return ListTile(
      title: Text(room.name),
      leading: ElevatedButton(
        child: null,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: room.status ? Colors.green : Colors.red,
        ),
        onPressed: () {
          setState(() {
            room.status = !room.status;
            writeRooms();
          });
        },
      ),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        ElevatedButton(
            onPressed: () {
              viewRoom(context);
            },
            child: const Text("View")),
      ]),
    );
  }

  void viewRoom(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => RoomPage(room: widget.room)));
  }
}

class RoomPage extends StatefulWidget {
  const RoomPage({super.key, required this.room});

  final Room room;

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(
        "Rebuilding room page for ${widget.room.name}. Items: ${widget.room.presentItems.length}");
    final sortedItems = List.from(widget.room.presentItems);
    sortedItems.sort((a, b) => a.name.compareTo(b.name));
    final itemsDisplay =
        sortedItems.fold("", (a, b) => "$a${a.isEmpty ? "" : ", "}${b.name}");
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.room.name),
          actions: [
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.room.presentItems.clear();
                    writeRooms();
                  });
                },
                child: const Text("Clear"))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                      title: const Text("Create Item"),
                      content: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                              hintText: "Enter Item Name")),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(ctx).pop(null);
                              controller.clear();
                            },
                            child: const Text("Cancel")),
                        ElevatedButton(
                            onPressed: () {
                              if (controller.text.isEmpty) {
                                Navigator.of(ctx).pop(null);
                              } else {
                                Navigator.of(ctx)
                                    .pop(RoomItem(name: controller.text));
                              }
                              controller.clear();
                            },
                            child: const Text("Create"))
                      ],
                    ),
                barrierDismissible: true);
            if (result != null) {
              setState(() {
                roomItems.add(result);
                writeItems();
              });
            }
            print("Returned: $result");
          },
          tooltip: 'Add Custom Item',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 50, child: Text("Items: $itemsDisplay")),
              Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: roomItems.length,
                      itemBuilder: (context, index) {
                        final item = roomItems[index];
                        return ListTile(
                          title: Text(item.name),
                          leading: ElevatedButton(
                            child: Icon(Icons.delete, color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                roomItems.remove(item);
                                writeItems();

                                for (var room in rooms) {
                                  if (room.presentItems.contains(item)) {
                                    room.presentItems.remove(item);
                                  }
                                }
                                writeRooms();
                              });
                            },
                          ),
                          trailing: Checkbox(
                              value: widget.room.presentItems.contains(item),
                              onChanged: (isNowChecked) {
                                setState(() {
                                  if (isNowChecked ?? false) {
                                    widget.room.presentItems.add(item);
                                  } else {
                                    widget.room.presentItems.remove(item);
                                  }
                                  writeRooms();
                                });
                              }),
                        );
                      })),
              SizedBox(height: 90)
            ],
          ),
        ));
  }
}
