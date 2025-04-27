import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import flutter_bloc
import 'package:todak_commerce/widgets/app_button.dart';
import '../../models/product.dart';
import '../../bloc/cart/cart_bloc.dart'; // Import CartBloc
import '../../bloc/cart/cart_event.dart'; // Import CartEvent


class ProductDetailPage extends StatelessWidget {
  final Product product; // We'll pass the Product object to this page

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title ?? 'Product Details'), // Use null-aware operator
      ),
      body: SingleChildScrollView( // Use SingleChildScrollView for scrolling content
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image (or placeholder)
            Center( // Center the image
              child: product.thumbnail != null && product.thumbnail!.isNotEmpty
                  ? Image.network(
                      product.thumbnail!,
                      height: 250, // Adjust height as needed
                      fit: BoxFit.contain, // Use contain to show full image
                      errorBuilder: (context, error, stackTrace) {
                        // Placeholder if image fails to load
                        return Image.asset(
                          'assets/images/placeholder_product.png', // Use your placeholder asset
                          height: 250,
                          fit: BoxFit.contain,
                        );
                      },
                    )
                  : Image.asset(
                      'assets/images/placeholder_product.png', // Use your placeholder asset
                      height: 250,
                      fit: BoxFit.contain,
                    ),
            ),
            const SizedBox(height: 24.0),

            // Product Title
            Text(
              product.title ?? 'No Title Available',
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                // fontFamily: 'CircularStd', // Apply custom font
              ),
            ),
            const SizedBox(height: 8.0),

            // Product Price
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.green,
                fontWeight: FontWeight.w600,
                 // fontFamily: 'CircularStd', // Apply custom font
              ),
            ),
            const SizedBox(height: 16.0),

            // Product Description
            Text(
              product.description ?? 'No description available.',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
                 // fontFamily: 'CircularStd', // Apply custom font
              ),
            ),
            const SizedBox(height: 16.0),

            // Additional Details (Optional - add more fields as needed)
            Text(
              'Brand: ${product.brand ?? 'N/A'}',
              style: const TextStyle(fontSize: 16.0,  // fontFamily: 'CircularStd'
              ),
            ),
             const SizedBox(height: 4.0),
            Text(
              'Category: ${product.category ?? 'N/A'}',
              style: const TextStyle(fontSize: 16.0,  // fontFamily: 'CircularStd'
              ),
            ),
             const SizedBox(height: 4.0),
            Text(
              'Rating: ${product.rating.toStringAsFixed(1)}', // Format rating
              style: const TextStyle(fontSize: 16.0,  // fontFamily: 'CircularStd'
              ),
            ),
             const SizedBox(height: 4.0),
            Text(
              'Stock: ${product.stock}',
              style: const TextStyle(fontSize: 16.0,  // fontFamily: 'CircularStd'
              ),
            ),

            // You can add more details here like images list, reviews, etc.
            const SizedBox(height: 24.0),

            Center(
               child:
               AppButton(text: 'Add to Cart', onPressed: () {
                  
                  BlocProvider.of<CartBloc>(context).add(
                    AddProductToCart(product: product),
                  );
                  // Show success message
                  floatingSnackBar(message: '${product.title ?? "Item"} added to cart!', context: context);
                }
                ),                
            ),
          ],
        ),
      ),
    );
  }
}
