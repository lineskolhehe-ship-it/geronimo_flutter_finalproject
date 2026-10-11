import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/state_widgets.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  final void Function(Product) onAddToCart;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: ProductImage(url: product.thumbnail, size: 220)),
            const SizedBox(height: 16),
            Text(product.title,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text(product.category)),
                Chip(
                  avatar: const Icon(Icons.star, size: 18, color: Colors.amber),
                  label: Text(product.rating.toStringAsFixed(1)),
                ),
                Chip(label: Text('${product.stock} in stock')),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 16),
            Text('Description',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(product.description),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: () => onAddToCart(product),
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Add to basket'),
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
          ),
        ),
      ),
    );
  }
}