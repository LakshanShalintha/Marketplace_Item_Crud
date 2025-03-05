import 'package:get/get.dart';
import '../models/item_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ItemController extends GetxController {
  var items = <ItemModel>[].obs;
  var isLoading = false.obs;

  static const String apiUrl = "http://192.168.8.173:8000/api";

  @override
  void onInit() {
    fetchItems();
    super.onInit();
  }

  // Fetch items from API
  Future<void> fetchItems() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse('$apiUrl/items'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        items.assignAll(jsonData.map((item) => ItemModel.fromJson(item)).toList());
      } else {
        Get.snackbar("Error", "Failed to load items");
      }
    } catch (error) {
      Get.snackbar("Error", "Error fetching items: $error");
    } finally {
      isLoading(false);
    }
  }

  // Add Item to API
  Future<void> addItem(ItemModel item) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/items'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(item.toJson()),
      );

      if (response.statusCode == 201) {
        items.add(item);
        Get.snackbar("Success", "Item added successfully");
      } else {
        Get.snackbar("Error", "Failed to add item");
      }
    } catch (error) {
      Get.snackbar("Error", "Error adding item: $error");
    }
  }

  // Update Item
  Future<void> updateItem(ItemModel item) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/items/${item.id}'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(item.toJson()),
      );

      if (response.statusCode == 200) {
        final updatedItem = ItemModel.fromJson(jsonDecode(response.body));
        int index = items.indexWhere((i) => i.id == updatedItem.id);
        if (index != -1) {
          items[index] = updatedItem;
          Get.snackbar("Success", "Item updated successfully");
        }
      } else {
        Get.snackbar("Error", "Failed to update item");
      }
    } catch (error) {
      Get.snackbar("Error", "Error updating item: $error");
    }
  }

  // Delete Item
  Future<void> deleteItem(int id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/items/$id'));

      if (response.statusCode == 200) {
        items.removeWhere((item) => item.id == id);
        Get.snackbar("Success", "Item deleted successfully");
      } else {
        Get.snackbar("Error", "Failed to delete item");
      }
    } catch (error) {
      Get.snackbar("Error", "Error deleting item: $error");
    }
  }
}
