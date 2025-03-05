import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/item_provider.dart';
import 'add_items_page.dart';
import 'edit_item_page.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  late Future<void> _fetchItemsFuture;

  @override
  void initState() {
    super.initState();
    _fetchItemsFuture = Provider.of<ItemProvider>(context, listen: false).fetchItems();
  }

  void _confirmDelete(BuildContext context, int itemId, ItemProvider itemProvider) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning, color: Colors.red, size: 50),
              const SizedBox(height: 10),
              const Text(
                "Confirm Delete",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Do you really want to delete this item?",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      Navigator.of(ctx).pop(); // Close dialog
                      itemProvider.deleteItem(itemId);

                      // Show success message in the middle
                      showDialog(
                        context: context,
                        builder: (ctx) => Dialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle, color: Colors.green, size: 50),
                                const SizedBox(height: 10),
                                const Text(
                                  "Deleted Successfully",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: const Text("OK"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text("Delete"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Items Page'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          // Background and List Content
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: FutureBuilder(
              future: _fetchItemsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (itemProvider.items.isEmpty) {
                  return const Center(child: Text('No items available'));
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 80),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: itemProvider.items.length,
                        itemBuilder: (context, index) {
                          final item = itemProvider.items[index];
                          final imageUrl = item.imageUrl != null
                              ? 'http://192.168.8.173:8000/storage/${item.imageUrl!}'
                              : null;

                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                            shadowColor: Colors.black.withOpacity(0.5),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image section
                                  imageUrl != null
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      imageUrl,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                      : const Icon(
                                    Icons.image,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 10),

                                  // Details section
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Title
                                        Text(
                                          item.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(height: 5),

                                        // Price
                                        Text(
                                          '\$${item.price.toString()}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.green,
                                          ),
                                        ),
                                        const SizedBox(height: 5),

                                        // Description
                                        Text(
                                          item.description,
                                          style: const TextStyle(fontSize: 14),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 10),

                                        // Edit and Delete buttons
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            // Edit Button
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.blue,
                                                size: 20,
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => EditItemPage(item: item),
                                                  ),
                                                );
                                              },
                                            ),
                                            // Delete Button with Confirmation
                                            IconButton(
                                              icon: const Icon(Icons.delete, color: Colors.red),
                                              onPressed: () => _confirmDelete(context, item.id!, itemProvider),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),

          //  Bottom Button
          Padding(
            padding: const EdgeInsets.only(bottom: 20), // Adjust the value as needed
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddItemsPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
                ),
                child: const Text(
                  'Add New Item',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
