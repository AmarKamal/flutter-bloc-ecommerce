// lib/pages/cart/cart_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import for SharedPreferences
import 'package:todak_commerce/widgets/app_button.dart';
import '../../bloc/cart/cart_bloc.dart';
import '../../bloc/cart/cart_event.dart';
import '../../bloc/cart/cart_state.dart';

import '../../models/product.dart'; // Import Product model
import '../../models/address.dart'; // Import Address model
import '../order/order_summary_page.dart'; 
import '../address/address_edit_page.dart'; // Import AddressEditPage

class CartPage extends StatefulWidget { 
  const CartPage({super.key});

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> { 
  Address? _userAddress; // State variable to hold the user's address

  @override
  void initState() {
    super.initState();
    _loadAddress(); // Load address when the page initializes
  }

  // Function to load the address from SharedPreferences
  Future<void> _loadAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final addressJsonString = prefs.getString('userAddress');
    if (addressJsonString != null) {
      setState(() {
        _userAddress = Address.fromRawJson(addressJsonString);
      });
    } else {
       setState(() {
        _userAddress = null; // Ensure _userAddress is null if no address is saved
      });
    }
  }

  // Function to navigate to the Address Edit Page
  void _navigateToEditAddress() async {
    // Navigate and wait for the result (true if saved/deleted)
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressEditPage(initialAddress: _userAddress),
      ),
    );

    // If the address was saved or deleted, reload it
    if (result == true) {
      _loadAddress();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const Center(
              child: Text('Your cart is empty!'),
            );
          }

          final cartItemsList = state.items.entries.map((entry) {
            final productId = entry.key;
            final quantity = entry.value;
            final product = state.productsInCart.firstWhere(
                (p) => p.id == productId,
                 orElse: () =>
                  Product(id: 0, title: 'Unknown Product', description: '', price: 0, discountPercentage: 0, rating: 0, stock: 0, brand: '', category: '', thumbnail: '', images: []));


            return ListTile(
              leading: Image.network(product.thumbnail ?? '', width: 50, height: 50, fit: BoxFit.cover,
                 errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported), // Placeholder on error
              ),
              title: Text(product.title ?? 'Unknown Product'),
              subtitle: Text('\$${product.price.toStringAsFixed(2)} x $quantity'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                       BlocProvider.of<CartBloc>(context).add(
                         UpdateCartItemQuantity(product: product, quantity: quantity - 1),
                       );
                    },
                  ),
                   Text('$quantity'),
                   IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                       BlocProvider.of<CartBloc>(context).add(
                         UpdateCartItemQuantity(product: product, quantity: quantity + 1),
                       );
                    },
                  ),
                ],
              ),
            );
          }).toList();

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    // *** ADDED: Address Section ***
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Shipping Address:',
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8.0),
                          InkWell( // Make the address section tappable
                            onTap: _navigateToEditAddress,
                            child: Container(
                               width: double.infinity, // Take full width
                               padding: const EdgeInsets.all(12.0),
                               decoration: BoxDecoration(
                                 border: Border.all(color: Colors.grey),
                                 borderRadius: BorderRadius.circular(8.0),
                               ),
                              child: _userAddress == null
                                  ? const Text(
                                      'Tap to add shipping address',
                                      style: TextStyle(color: Colors.blue),
                                    )
                                  : Text(_userAddress!.formattedAddress),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(), // Separator between address and cart items
                    ...cartItemsList, // Spread the list of cart items
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Total: \$${state.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16.0),
                    // *** CHANGED: Navigate to OrderSummaryPage ***
                    AppButton(text: 'Proceed to Order Summary',
                    onPressed: _userAddress == null || state.items.isEmpty
                          ? null // Disable if no address or empty cart
                          : () {
                              // Navigate to Order Summary Page, passing cart details and address
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderSummaryPage(
                                    cartItems: state.items,
                                    productsInCart: state.productsInCart,
                                    shippingAddress: _userAddress!, // Pass the address
                                  ),
                                ),
                              );
                            }
                    ),
                    
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
