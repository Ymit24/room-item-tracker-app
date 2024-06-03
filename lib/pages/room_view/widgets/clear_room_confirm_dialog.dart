import 'package:flutter/material.dart';

/// Dialog to show clear room confirmation.
class ClearRoomConfirmDialog extends StatefulWidget {
  const ClearRoomConfirmDialog({super.key, required this.onClear});

  /// Callback for when the user confirms to clear the room.
  final Function() onClear;

  @override
  State<StatefulWidget> createState() => _ClearRoomConfirmDialogState();
}

class _ClearRoomConfirmDialogState extends State<ClearRoomConfirmDialog> {
  @override
  Widget build(BuildContext ctx) => AlertDialog(
        content: const Text(
          'Are you sure that you wan\'t to clear all items from the room?',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            icon: const Icon(
              Icons.cancel,
              color: Colors.red,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.onClear();
            },
            icon: const Icon(
              Icons.check,
              color: Colors.green,
            ),
          ),
        ],
      );
}
