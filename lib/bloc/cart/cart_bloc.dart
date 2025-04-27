// lib/bloc/cart/cart_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import './cart_event.dart';
import './cart_state.dart';
import '../../models/product.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddProductToCart>(_onAddProductToCart);
    on<RemoveProductFromCart>(_onRemoveProductFromCart);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
    on<ClearCart>(_onClearCart);
  }

  void _onAddProductToCart(AddProductToCart event, Emitter<CartState> emit) {
    final currentItems = Map<int, int>.from(state.items);
    final productId = event.product.id;

    if (currentItems.containsKey(productId)) {
      currentItems[productId] = currentItems[productId]! + 1;
    } else {
      currentItems[productId] = 1;
    }

    // Add product details if not already in the list
    final currentProductsInCart = List<Product>.from(state.productsInCart);
    if (!currentProductsInCart.any((p) => p.id == productId)) {
      currentProductsInCart.add(event.product);
    }

    // *** This emit call should trigger a state change ***
    emit(state.copyWith(items: currentItems, productsInCart: currentProductsInCart));
  }

  void _onRemoveProductFromCart(RemoveProductFromCart event, Emitter<CartState> emit) {
    final currentItems = Map<int, int>.from(state.items);
    final productId = event.product.id;

    if (currentItems.containsKey(productId)) {
      if (currentItems[productId]! > 1) {
        currentItems[productId] = currentItems[productId]! - 1;
      } else {
        currentItems.remove(productId);
      }
    }

     // Remove product details if quantity becomes 0
    final currentProductsInCart = List<Product>.from(state.productsInCart);
    if (!currentItems.containsKey(productId)) {
       currentProductsInCart.removeWhere((p) => p.id == productId);
    }

    // *** This emit call should trigger a state change ***
    emit(state.copyWith(items: currentItems, productsInCart: currentProductsInCart));
  }

  void _onUpdateCartItemQuantity(UpdateCartItemQuantity event, Emitter<CartState> emit) {
     final currentItems = Map<int, int>.from(state.items);
    final productId = event.product.id;
    final quantity = event.quantity;

    if (quantity > 0) {
      currentItems[productId] = quantity;
       // Add product details if not already in the list (in case it was removed and re-added)
      final currentProductsInCart = List<Product>.from(state.productsInCart);
      if (!currentProductsInCart.any((p) => p.id == productId)) {
        currentProductsInCart.add(event.product);
      }
       // *** This emit call should trigger a state change ***
       emit(state.copyWith(items: currentItems, productsInCart: currentProductsInCart));

    } else {
      currentItems.remove(productId);
       // Remove product details if quantity becomes 0
      final currentProductsInCart = List<Product>.from(state.productsInCart);
      currentProductsInCart.removeWhere((p) => p.id == productId);
      // *** This emit call should trigger a state change ***
      emit(state.copyWith(items: currentItems, productsInCart: currentProductsInCart));
    }
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    // *** This emit call should trigger a state change ***
    emit(const CartState(items: {}, productsInCart: []));
  }
}
