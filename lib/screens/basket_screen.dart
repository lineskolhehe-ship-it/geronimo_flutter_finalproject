import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/state_widgets.dart';
import 'checkout_screen.dart';

class BasketScreen extends StatelessWidget {
  final List<CartItem> cart;
  final void Function(CartItem, int) onChangeQuantity;
  final void Function(CartItem) onRemove;
  final VoidCallback onOrderPlaced;

  const BasketScreen({
    super.key,
    required this.cart,
    required this.onChangeQuantity,
    required this.onRemove,
    required this.onOrderPlaced,
  });

  double get _total => cart.fold(0, (sum, item) => sum + item.total);
  int get _itemCount => cart.fold(0, (sum, item) => sum + item.quantity);

  Future<void> _confirmDelete(BuildContext context, CartItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove item?'),
        content: Text('Remove ${item.product.title} from your basket?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed == true) onRemove(item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Basket')),
      body: cart.isEmpty
          ? const EmptyState(
              message: 'Your basket is empty.\nAdd fresh produce from the Market.',
              icon: Icons.shopping_basket_outlined,
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ProductImage(
                                  url: item.product.thumbnail, size: 64),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.product.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall),
                                    Text(
                                        '\$${item.product.price.toStringAsFixed(2)} each'),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: item.quantity > 1
                                              ? () => onChangeQuantity(item, -1)
                                              : null,
                                          icon: const Icon(
                                              Icons.remove_circle_outline),
                                          tooltip: 'Decrease quantity',
                                        ),
                                        Text('${item.quantity}'),
                                        IconButton(
                                          onPressed: () =>
                                              onChangeQuantity(item, 1),
                                          icon: const Icon(
                                              Icons.add_circle_outline),
                                          tooltip: 'Increase quantity',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        _confirmDelete(context, item),
                                    icon: const Icon(Icons.delete_outline,
                                        color: Colors.red),
                                    tooltip: 'Remove item',
                                  ),
                                  Text(
                                    '\$${item.total.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$_itemCount item(s)'),
                              Text(
                                'Total: \$${_total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CheckoutScreen(
                                total: _total,
                                itemCount: _itemCount,
                                onOrderPlaced: onOrderPlaced,
                              ),
                            ),
                          ),
                          child: const Text('Checkout'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}