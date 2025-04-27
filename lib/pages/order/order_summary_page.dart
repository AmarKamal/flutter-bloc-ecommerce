import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todak_commerce/widgets/app_button.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';


import '../../bloc/cart/cart_bloc.dart';
import '../../bloc/cart/cart_event.dart';
import '../../models/product.dart';
import '../../models/address.dart';
import '../../models/order.dart' as order_model; 


class OrderSummaryPage extends StatelessWidget {
  final Map<int, int> cartItems;
  final List<Product> productsInCart;
  final Address shippingAddress;

  const OrderSummaryPage({
    super.key,
    required this.cartItems,
    required this.productsInCart,
    required this.shippingAddress,
  });

  double get _totalAmount {
    double total = 0.0;
    for (var entry in cartItems.entries) {
      final productId = entry.key;
      final quantity = entry.value;
      final product = productsInCart.firstWhere(
          (p) => p.id == productId,
          orElse: () =>
              Product(id: 0, title: '', description: '', price: 0, discountPercentage: 0, rating: 0, stock: 0, brand: '', category: '', thumbnail: '', images: []));
      total += product.price * quantity;
    }
    return total;
  }

  Future<void> _saveOrder(BuildContext context) async {
    debugPrint('Attempting to save order...'); // Debug debugPrint

    if (cartItems.isEmpty) {
      debugPrint('Cart is empty, not saving order.'); // Debug debugPrint
      return;
    }

    try {
      final order = order_model.Order(
        id: const Uuid().v4(),
        orderDate: DateTime.now(),
        items: cartItems,
        productsDetails: productsInCart,
        totalAmount: _totalAmount,
        shippingAddress: shippingAddress,
      );
      debugPrint('Order object created: ${order.id}'); // Debug debugPrint

      final prefs = await SharedPreferences.getInstance();
      debugPrint('SharedPreferences instance obtained.'); // Debug debugPrint

      final String? ordersJsonString = prefs.getString('orderHistory');
      debugPrint('Existing order history string: $ordersJsonString'); // Debug debugPrint

      List<order_model.Order> orderHistory = [];
      if (ordersJsonString != null && ordersJsonString.isNotEmpty) { // Added check for empty string
        try {
           final List<dynamic> ordersJsonList = json.decode(ordersJsonString);
           orderHistory = ordersJsonList.map((json) => order_model.Order.fromJson(json)).toList();
           debugPrint('Successfully decoded existing order history (${orderHistory.length} orders).'); // Debug debugPrint
        } catch (e) {
           debugPrint('Error decoding existing order history: $e'); // Debug debugPrint error
           
           orderHistory = [];
        }
      } else {
        debugPrint('No existing order history found.'); // Debug debugPrint
      }


      orderHistory.add(order);
      debugPrint('New order added to history (${orderHistory.length} orders total).'); // Debug debugPrint

      final String updatedOrdersJsonString = json.encode(orderHistory.map((o) => o.toJson()).toList());
      debugPrint('Updated order history string created.'); // Debug debugPrint
      // debugPrint('Updated order history string: $updatedOrdersJsonString'); // Uncomment for full string

      await prefs.setString('orderHistory', updatedOrdersJsonString);
      debugPrint('Order history saved to SharedPreferences.'); // Debug debugPrint

      // Dispatch ClearCart event
      BlocProvider.of<CartBloc>(context).add(ClearCart());
      debugPrint('ClearCart event dispatched.'); // Debug debugPrint
      
      floatingSnackBar(message: 'Order Placed Successfully!', context: context);      
      
      debugPrint('Success snackbar shown.'); // Debug debugPrint

      // Navigate back to the Home page
      Navigator.popUntil(context, (route) => route.isFirst);
      debugPrint('Navigated back to home.'); // Debug debugPrint

    } catch (e, stacktrace) { // Catch any exceptions during the save process
      debugPrint('*** Error saving order: $e ***'); // Debug debugPrint error
      debugPrint('*** Stacktrace: $stacktrace ***'); // Debug debugPrint stacktrace
      
      floatingSnackBar(message: 'Failed to place order: $e', context: context);      
    }
  }


  @override
  Widget build(BuildContext context) {
    final orderedItemsList = cartItems.entries.map((entry) {
      final productId = entry.key;
      final quantity = entry.value;
       final product = productsInCart.firstWhere(
        (p) => p.id == productId,
         orElse: () =>
          Product(id: 0, title: 'Unknown Product', description: '', price: 0, discountPercentage: 0, rating: 0, stock: 0, brand: '', category: '', thumbnail: '', images: []));


      return ListTile(
        leading: Image.network(product.thumbnail ?? '', width: 50, height: 50, fit: BoxFit.cover,
           errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported),
        ),
        title: Text(product.title ?? 'Unknown Product'),
        subtitle: Text('\$${product.price.toStringAsFixed(2)} x $quantity'),
        trailing: Text('Total: \$${(product.price * quantity).toStringAsFixed(2)}'),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             const Text(
              'Shipping To:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(shippingAddress.formattedAddress),
            const SizedBox(height: 16.0),
            const Divider(),
            const Text(
              'Items in Order:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView(
                children: orderedItemsList,
              ),
            ),
            const Divider(),
            Text(
              'Order Total: \$${_totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24.0),
            Center(              
              child: 
              AppButton(text: 'Create Order', onPressed: (){
                _saveOrder(context);
              }
              , isLoading: false),               

              
            ),
          ],
        ),
      ),
    );
  }
}
