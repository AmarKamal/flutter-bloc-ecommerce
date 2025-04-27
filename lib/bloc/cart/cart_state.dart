import 'package:equatable/equatable.dart';
import '../../models/product.dart';

class CartState extends Equatable {
  // Map of Product ID to Quantity
  final Map<int, int> items;
  final List<Product> productsInCart; // Store product details for display

  const CartState({this.items = const {}, this.productsInCart = const []});

  CartState copyWith({
    Map<int, int>? items,
    List<Product>? productsInCart,
  }) {
    return CartState(
      items: items ?? this.items,
      productsInCart: productsInCart ?? this.productsInCart,
    );
  }

  // Helper to calculate total price
  double get totalPrice {
    double total = 0.0;
    for (var entry in items.entries) {
      final productId = entry.key;
      final quantity = entry.value;
      final product = productsInCart.firstWhere(
          (p) => p.id == productId,
          orElse: () =>
              Product(id: 0, title: '', description: '', price: 0, discountPercentage: 0, rating: 0, stock: 0, brand: '', category: '', thumbnail: '', images: [])); // Provide a default or handle error
      total += product.price * quantity;
    }
    return total;
  }

  // Helper to get total number of items (sum of quantities)
  int get totalItems => items.values.fold(0, (sum, quantity) => sum + quantity);


  @override
  List<Object> get props => [items, productsInCart]; // Equatable props
}
