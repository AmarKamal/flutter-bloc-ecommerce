import 'package:equatable/equatable.dart';
import '../../models/product.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class PlaceOrder extends OrderEvent {
  final Map<int, int> cartItems; // productId: quantity
  final List<Product> productsInCart; // Product details

  const PlaceOrder({required this.cartItems, required this.productsInCart});

  @override
  List<Object> get props => [cartItems, productsInCart];
}

class OrderCompleted extends OrderEvent {} // This event is now less critical for saving

class ResetOrder extends OrderEvent {}

// *** ADDED: Event to load order history ***
class LoadOrderHistory extends OrderEvent {}
