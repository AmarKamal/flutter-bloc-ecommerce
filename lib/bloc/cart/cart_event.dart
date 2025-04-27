import 'package:equatable/equatable.dart';
import 'package:todak_commerce/models/product.dart';


abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class AddProductToCart extends CartEvent {
  final Product product;

  const AddProductToCart({required this.product});

  @override
  List<Object> get props => [product];
}

class RemoveProductFromCart extends CartEvent {
  final Product product;

  const RemoveProductFromCart({required this.product});

  @override
  List<Object> get props => [product];
}

class UpdateCartItemQuantity extends CartEvent {
  final Product product;
  final int quantity;

  const UpdateCartItemQuantity({required this.product, required this.quantity});

  @override
  List<Object> get props => [product, quantity];
}

class ClearCart extends CartEvent {}
