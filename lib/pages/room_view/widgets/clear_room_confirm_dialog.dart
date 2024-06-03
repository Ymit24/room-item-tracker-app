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
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.onClear();
            },
            child: const Text('Yes, clear!'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      );
}
