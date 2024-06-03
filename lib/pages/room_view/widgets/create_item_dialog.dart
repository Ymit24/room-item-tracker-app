import 'package:flutter/material.dart';

/// Dialog to create new items.
class CreateItemDialog extends StatefulWidget {
  /// Callback for when the dialog is finished and should create an item.
  final Function(String) onCreate;

  const CreateItemDialog({super.key, required this.onCreate});

  @override
  State<StatefulWidget> createState() => _CreateItemDialogState();
}

class _CreateItemDialogState extends State<CreateItemDialog> {
  /// Controller for item name TextField.
  final _itemNameController = TextEditingController(text: '');

  @override
  void dispose() {
    _itemNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) => AlertDialog(
        title: const Text('Create Item'),
        content: TextField(
          controller: _itemNameController,
          decoration: const InputDecoration(hintText: 'Enter item name..'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_itemNameController.text.isEmpty) {
                ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
                    content: Text('Item Name Can\'t be Empty!')));
              } else {
                widget.onCreate(_itemNameController.text);
              }
            },
            child: const Text('Create'),
          )
        ],
      );
}
