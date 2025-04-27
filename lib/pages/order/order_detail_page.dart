import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import '../../models/order.dart'; // Import Order model
import '../../models/product.dart'; // Import Product model

class OrderDetailPage extends StatelessWidget {
  final Order order; // The specific order to display

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
     final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(order.orderDate);

     final orderedItemsList = order.items.entries.map((entry) {
      final productId = entry.key;
      final quantity = entry.value;
       // Find the product details from the productsDetails list in the order
       final product = order.productsDetails.firstWhere(
        (p) => p.id == productId,
         orElse: () =>
          Product(id: 0, title: 'Unknown Product', description: '', price: 0, discountPercentage: 0, rating: 0, stock: 0, brand: '', category: '', thumbnail: '', images: []));


      return ListTile(
        leading: Image.network(product.thumbnail ?? '', width: 50, height: 50, fit: BoxFit.cover,
           errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported), // Placeholder on error
        ),
        title: Text(product.title ?? 'Unknown Product'),
        subtitle: Text('\$${product.price.toStringAsFixed(2)} x $quantity'),
        trailing: Text('Total: \$${(product.price * quantity).toStringAsFixed(2)}'),
      );
    }).toList();


    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Use SingleChildScrollView for potentially long content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order ID: ${order.id}',
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Order Date: $formattedDate',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              const Divider(),
               const Text(
                'Shipping To:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(order.shippingAddress.formattedAddress), // Display the shipping address
              const SizedBox(height: 16.0),
              const Divider(),
              const Text(
                'Items Ordered:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              // Display ordered items
              Column( // Use Column to display the list of ListTiles
                children: orderedItemsList,
              ),
              const Divider(),
              Text(
                'Order Total: \$${order.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              // Add more details if needed (e.g., payment info, status)
            ],
          ),
        ),
      ),
    );
  }
}
