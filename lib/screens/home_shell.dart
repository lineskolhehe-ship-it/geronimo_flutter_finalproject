import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/storage_service.dart';
import 'basket_screen.dart';
import 'market_screen.dart';

/// Holds the bottom navigation and the shared basket state (via setState).
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final StorageService _storage = StorageService();
  int _index = 0;
  final List<CartItem> _cart = [];

  @override
  void initState() {
    super.initState();
    _restoreCart();
  }

  Future<void> _restoreCart() async {
    final saved = await _storage.loadCart();
    if (!mounted) return;
    setState(() {
      _cart.clear();
      _cart.addAll(saved);
    });
  }

  int get _itemCount => _cart.fold(0, (sum, item) => sum + item.quantity);

  void _addToCart(Product product) {
    setState(() {
      final i = _cart.indexWhere((c) => c.product.id == product.id);
      if (i >= 0) {
        _cart[i].quantity++;
      } else {
        _cart.add(CartItem(product: product));
      }
    });
    _storage.saveCart(_cart);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('${product.title} added to basket'),
        duration: const Duration(seconds: 2),
      ));
  }

  void _changeQuantity(CartItem item, int delta) {
    setState(() {
      item.quantity += delta;
      if (item.quantity < 1) item.quantity = 1;
    });
    _storage.saveCart(_cart);
  }

  /// Called after the user confirmed the delete dialog.
  void _removeItem(CartItem item) {
    final index = _cart.indexOf(item);
    setState(() => _cart.remove(item));
    _storage.saveCart(_cart);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('${item.product.title} removed'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              final at = index > _cart.length ? _cart.length : index;
              _cart.insert(at, item);
            });
            _storage.saveCart(_cart);
          },
        ),
      ));
  }

  void _clearCart() {
    setState(() => _cart.clear());
    _storage.saveCart(_cart);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          MarketScreen(onAddToCart: _addToCart),
          BasketScreen(
            cart: _cart,
            onChangeQuantity: _changeQuantity,
            onRemove: _removeItem,
            onOrderPlaced: _clearCart,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Market',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('$_itemCount'),
              isLabelVisible: _itemCount > 0,
              child: const Icon(Icons.shopping_basket_outlined),
            ),
            selectedIcon: Badge(
              label: Text('$_itemCount'),
              isLabelVisible: _itemCount > 0,
              child: const Icon(Icons.shopping_basket),
            ),
            label: 'Basket',
          ),
        ],
      ),
    );
  }
}