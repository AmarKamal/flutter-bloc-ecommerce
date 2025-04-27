// lib/models/order.dart
import 'dart:convert';

import 'package:todak_commerce/models/address.dart';
import 'package:todak_commerce/models/product.dart';

class Order {
  final String id; // Unique ID for the order (e.g., timestamp + random)
  final DateTime orderDate;
  final Map<int, int> items; // productId: quantity
  final List<Product> productsDetails; // Details of products in the order
  final double totalAmount;
  final Address shippingAddress;

  Order({
    required this.id,
    required this.orderDate,
    required this.items,
    required this.productsDetails,
    required this.totalAmount,
    required this.shippingAddress,
  });

  // Convert an Order object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderDate': orderDate.toIso8601String(), // Convert DateTime to String
      // *** CHANGED: Convert Map<int, int> to Map<String, int> for JSON encoding ***
      'items': items.map((key, value) => MapEntry(key.toString(), value)),
      // Convert list of Product objects to list of JSON maps
      'productsDetails': productsDetails.map((p) => p.toJson()).toList(),
      'totalAmount': totalAmount,
      'shippingAddress': shippingAddress.toJson(), // Convert Address object to JSON map
    };
  }

  // Create an Order object from a JSON map
  factory Order.fromJson(Map<String, dynamic> json) {
    // *** CHANGED: Convert Map<String, dynamic> back to Map<int, int> when decoding ***
    final Map<String, dynamic> itemsJson = Map<String, dynamic>.from(json['items']);
    final Map<int, int> itemsMap = itemsJson.map((key, value) => MapEntry(int.parse(key), value));


    return Order(
      id: json['id'],
      orderDate: DateTime.parse(json['orderDate']), // Convert String back to DateTime
      items: itemsMap, // Use the converted map
      // Convert list of JSON maps back to list of Product objects
      productsDetails: List<Product>.from(json['productsDetails'].map((item) => Product.fromJson(item))),
      totalAmount: json['totalAmount'].toDouble(), // Ensure double
      shippingAddress: Address.fromJson(json['shippingAddress']), // Create Address object
    );
  }

  // Helper to convert Order object to a JSON string
  String toRawJson() => json.encode(toJson());

  // Helper to create Order object from a JSON string
  factory Order.fromRawJson(String str) => Order.fromJson(json.decode(str));
}
