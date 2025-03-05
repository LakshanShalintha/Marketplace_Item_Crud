import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/item_model.dart';

class ItemProvider with ChangeNotifier {
  List<ItemModel> _items = [];
  bool _isLoading = false;

  List<ItemModel> get items => _items;
  bool get isLoading => _isLoading;

  Future<void> fetchItems() async {
    try {
      _isLoading = true;
      notifyListeners();

      const String apiUrl =  "http://192.168.8.173:8000/api";
      final response = await http.get(Uri.parse('$apiUrl/items'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        _items = jsonData.map((item) => ItemModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load items');
      }
    } catch (error) {
      if (kDebugMode) print('Error fetching items: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add Item to API
  Future<void> addItem(ItemModel item) async {
    try {
      const String apiUrl = "http://192.168.8.173:8000/api";
      final response = await http.post(
        Uri.parse('$apiUrl/items'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(item.toJson()),
      );

      if (response.statusCode == 201) {
        _items.add(item);
        notifyListeners();
      } else {
        throw Exception('Failed to add item');
      }
    } catch (error) {
      if (kDebugMode) print('Error adding item: $error');
    }
  }

  // Add this method in your ItemProvider class

  Future<void> updateItem(ItemModel item) async {
    try {
      const String apiUrl = "http://192.168.8.173:8000/api";
      final response = await http.put(
        Uri.parse('$apiUrl/items/${item.id}'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(item.toJson()),
      );

      if (response.statusCode == 200) {
        // Successfully updated item
        final updatedItem = ItemModel.fromJson(jsonDecode(response.body));
        final index = _items.indexWhere((i) => i.id == updatedItem.id);
        if (index != -1) {
          _items[index] = updatedItem;
          notifyListeners();
        }
      } else {
        throw Exception('Failed to update item');
      }
    } catch (error) {
      if (kDebugMode) print('Error updating item: $error');
    }
  }



  Future<void> deleteItem(int id) async {
    try {
      const String apiUrl = "http://192.168.8.173:8000/api";

      final response = await http.delete(Uri.parse('$apiUrl/items/$id'));

      if (response.statusCode == 200) {
        _items.removeWhere((item) => item.id == id);
        notifyListeners();
      } else {
        throw Exception('Failed to delete item');
      }
    } catch (error) {
      if (kDebugMode) print('Error deleting item: $error');
    }
  }

}
