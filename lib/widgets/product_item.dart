import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../pages/product_detail/product_detail_page.dart'; // Import the detail page

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // *** CHANGED: Wrap the Card in an InkWell for tap detection ***
    return InkWell(
      onTap: () {
        // Navigate to the Product Detail Page when tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product), // Pass the product object
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image - Handle potential null thumbnail
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: product.thumbnail != null && product.thumbnail!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(product.thumbnail!),
                          fit: BoxFit.cover,
                        )
                      : const DecorationImage( // Placeholder image if thumbnail is null or empty
                           image: AssetImage('assets/images/placeholder_product.png'),
                           fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(width: 12.0),
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle potential null title
                    Text(
                      product.title ?? 'No Title',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        // fontFamily: 'CircularStd', // Apply custom font
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    // Price is double, already handled
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                         // fontFamily: 'CircularStd', // Apply custom font
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    // Handle potential null description
                    Text(
                      product.description ?? 'No description available.',
                      style: const TextStyle(fontSize: 12.0, color: Colors.grey, // fontFamily: 'CircularStd'
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Add to Cart Button
              IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                color: Colors.blue,
                onPressed: () {
                  // Dispatch AddProductToCart event to CartBloc
                  BlocProvider.of<CartBloc>(context).add(
                    AddProductToCart(product: product),
                  );
                  floatingSnackBar(message: '${product.title ?? "Item"} added to cart!', context: context);                   
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
