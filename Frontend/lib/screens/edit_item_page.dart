import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/models/item_model.dart';
import '../core/providers/item_provider.dart';
import 'items_page.dart';

class EditItemPage extends StatefulWidget {
  final ItemModel item;

  const EditItemPage({super.key, required this.item});

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.item.title;
    _priceController.text = widget.item.price.toString();
    _descriptionController.text = widget.item.description;
  }

  // Function to show the dialog message
  void _showDialog(String message, {bool isSuccess = true}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isSuccess ? 'Success' : 'Error', textAlign: TextAlign.center),
          content: Center(  // Wrap the message in Center widget to center-align it
            child: Text(
              message,
              textAlign: TextAlign.center, // Center-align the message text
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (isSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ItemsPage()),
                  );
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveItem() async {
    final updatedItem = ItemModel(
      id: widget.item.id,
      title: _titleController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,
      description: _descriptionController.text,
      imageUrl: widget.item.imageUrl, // Use the existing image URL
    );

    try {
      await Provider.of<ItemProvider>(context, listen: false).updateItem(updatedItem);

      // Show success message
      _showDialog('Item updated successfully');
    } catch (error) {
      // Show error message
      _showDialog('Failed to update item: $error', isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title TextField
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),

            // Price TextField
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            const SizedBox(height: 16),

            // Description TextField
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16),

            // Save Button
            ElevatedButton(
              onPressed: _saveItem,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
