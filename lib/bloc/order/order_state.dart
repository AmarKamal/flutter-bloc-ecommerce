import 'package:equatable/equatable.dart';
import 'package:todak_commerce/models/product.dart';


abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderProcessing extends OrderState {}

class OrderPlaced extends OrderState {
  final Map<int, int> orderedItems;
  final List<Product> orderedProducts;
  final double totalAmount;

  const OrderPlaced({
    required this.orderedItems,
    required this.orderedProducts,
    required this.totalAmount,
  });

  @override
  List<Object> get props => [orderedItems, orderedProducts, totalAmount];
}

class OrderCompleteSuccess extends OrderState {}

class OrderError extends OrderState {
  final String message;

  const OrderError({required this.message});

  @override
  List<Object> get props => [message];
}
