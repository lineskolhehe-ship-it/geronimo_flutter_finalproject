import 'package:flutter/material.dart';

/// Shown when there is nothing to display.
class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyState({
    super.key,
    required this.message,
    this.icon = Icons.search_off,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Colors.grey),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

/// Shown when the API request fails.
class ErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onUseSample;

  const ErrorRetry({
    super.key,
    required this.message,
    required this.onRetry,
    required this.onUseSample,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 64, color: Colors.redAccent),
            const SizedBox(height: 12),
            const Text('Something went wrong',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
            TextButton(
              onPressed: onUseSample,
              child: const Text('Use offline sample data'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Product image with a leaf-icon fallback if the image is missing or fails.
class ProductImage extends StatelessWidget {
  final String url;
  final double size;

  const ProductImage({super.key, required this.url, this.size = 80});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: size,
      height: size,
      color: Colors.green.shade100,
      child: Icon(Icons.eco, color: Colors.green.shade700, size: size / 2),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: url.isEmpty
          ? placeholder
          : Image.network(
              url,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => placeholder,
            ),
    );
  }
}