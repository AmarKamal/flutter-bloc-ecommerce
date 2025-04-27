
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../pages/product_detail/product_detail_page.dart';
import '../utils/app_colors.dart'; 

class ProductGridItem extends StatelessWidget {
  final Product product;

  const ProductGridItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return InkWell(
      onTap: () {
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product), 
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: product.thumbnail != null && product.thumbnail!.isNotEmpty
            ? Image.network(
                product.thumbnail!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/images/placeholder_product.png',
              fit: BoxFit.contain,
            );
                },
              )
            : Image.asset(
                'assets/images/placeholder_product.png',
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.title ?? 'No Title',
              style: textTheme.titleMedium?.copyWith(fontSize: 14, color: colorScheme.onSurface),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4.0),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: textTheme.bodyMedium?.copyWith(fontSize: 12, color: kcSuccess, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4.0),
            Text(
              product.description ?? 'No description available.',
              style: textTheme.bodySmall?.copyWith(color: kcTextSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
              ),
            ),
            Row(
              children: [
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            color: colorScheme.primary,
            onPressed: () {
              BlocProvider.of<CartBloc>(context).add(
                AddProductToCart(product: product),
              );
              floatingSnackBar(message: '${product.title ?? "Item"} added to cart!', context: context);
            },
          ),
              ],
            ),
          ],
        ),
            ),
    );
  }
}
