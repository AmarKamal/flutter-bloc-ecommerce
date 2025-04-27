// lib/bloc/order/order_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import for SharedPreferences
import 'dart:convert'; // Import for json encoding/decoding

import './order_event.dart';
import '../../models/product.dart'; // Import Product model
import '../../models/order.dart'; // Import Order model

// *** ADDED: New Order States for History ***
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

// *** ADDED: States for Order History ***
class OrderHistoryLoading extends OrderState {}

class OrderHistoryLoaded extends OrderState {
  final List<Order> orders;

  const OrderHistoryLoaded({required this.orders});

  @override
  List<Object> get props => [orders];
}


class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial()) {
    on<PlaceOrder>(_onPlaceOrder);
    on<OrderCompleted>(_onOrderCompleted); // This event is no longer used for saving, but can be kept for other logic
    on<ResetOrder>(_onResetOrder);
    on<LoadOrderHistory>(_onLoadOrderHistory); // *** ADDED: Handler for LoadOrderHistory ***
  }

  // This handler is triggered when "Proceed to Order Summary" is tapped in CartPage
  void _onPlaceOrder(PlaceOrder event, Emitter<OrderState> emit) {
    // This state is now primarily used to pass data to the Order Summary Page
    // The actual saving happens when "Complete Order" is pressed on the summary page.
    double total = 0.0;
     for (var entry in event.cartItems.entries) {
      final productId = entry.key;
      final quantity = entry.value;
      final product = event.productsInCart.firstWhere(
          (p) => p.id == productId,
          orElse: () =>
              Product(id: 0, title: '', description: '', price: 0, discountPercentage: 0, rating: 0, stock: 0, brand: '', category: '', thumbnail: '', images: []));
      total += product.price * quantity;
    }

    emit(OrderPlaced(
      orderedItems: event.cartItems,
      orderedProducts: event.productsInCart,
      totalAmount: total,
    ));
  }

  // This handler is now less critical as saving happens in OrderSummaryPage
  void _onOrderCompleted(OrderCompleted event, Emitter<OrderState> emit) {
    
  }

  void _onResetOrder(ResetOrder event, Emitter<OrderState> emit) {
    emit(OrderInitial());
  }

  
  Future<void> _onLoadOrderHistory(LoadOrderHistory event, Emitter<OrderState> emit) async {
    emit(OrderHistoryLoading()); // Indicate loading

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? ordersJsonString = prefs.getString('orderHistory');

      List<Order> orderHistory = [];
      if (ordersJsonString != null) {
        final List<dynamic> ordersJsonList = json.decode(ordersJsonString);
        orderHistory = ordersJsonList.map((json) => Order.fromJson(json)).toList();
        // Optionally sort orders by date, newest first
        orderHistory.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      }

      emit(OrderHistoryLoaded(orders: orderHistory)); // Emit loaded history

    } catch (e) {
      final errorMessage = e.toString();
      emit(OrderError(message: 'Failed to load order history: $errorMessage')); // Emit error state
    }
  }
}
