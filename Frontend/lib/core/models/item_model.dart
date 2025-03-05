class ItemModel {
  final int? id;
  final String title;
  final double price;
  final String description;
  final String? imageUrl;

  ItemModel({
    this.id,
    required this.title,
    required this.price,
    required this.description,
    this.imageUrl,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      title: json['title'],
      price: (json['price'] is num) ? json['price'].toDouble() : double.tryParse(json['price'].toString()) ?? 0.0,
      description: json['description'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'price': price,
      'description': description,
      'image_url': imageUrl,
    };
  }
}
