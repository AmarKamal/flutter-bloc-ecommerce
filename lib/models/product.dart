class Product {
  final int id;
  final String? title;
  final String? description;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String? brand;
  final String? category;
  final String? thumbnail;
  final List<String>? images;

  Product({
    required this.id,
    this.title,
    this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    this.brand,
    this.category,
    this.thumbnail,
    this.images,
  });

  // Factory method to create a Product object from a JSON map
  factory Product.fromJson(Map<String, dynamic> json) {
    // Safely handle potential nulls and ensure correct types
    return Product(
      id: json['id'],
      title: json['title'], // Will be null if json['title'] is null
      description: json['description'], // Will be null if json['description'] is null
      price: (json['price'] as num?)?.toDouble() ?? 0.0, // Safely cast and provide default
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0.0, // Safely cast and provide default
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0, // Safely cast and provide default
      stock: json['stock'] ?? 0, // Provide default for int
      brand: json['brand'], // Will be null if json['brand'] is null
      category: json['category'], // Will be null if json['category'] is null
      thumbnail: json['thumbnail'], // Will be null if json['thumbnail'] is null
      // Handle the images list - ensure it's a List and contains Strings, provide default
      images: (json['images'] as List<dynamic>?)
          ?.map((item) => item?.toString() ?? '') // Map each item to String, handle null items
          .toList() ?? [], // Convert to list, provide empty list if json['images'] is null
    );
  }

  // *** This is the toJson() method that was missing or incorrect in your Product model ***
  // Method to convert a Product object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'brand': brand,
      'category': category,
      'thumbnail': thumbnail,
      'images': images, // This will be a List<String>?
      // Note: Other fields from the API response like tags, dimensions, etc.
      // are not included here as they are not in our Product model.
      // Add them if you need to save them with the order.
    };
  }
}
