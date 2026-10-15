import 'package:flutter/material.dart';
import '../data/sample_products.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../widgets/product_card.dart';
import '../widgets/state_widgets.dart';
import 'product_detail_screen.dart';

class MarketScreen extends StatefulWidget {
  final void Function(Product) onAddToCart;

  const MarketScreen({super.key, required this.onAddToCart});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final ApiService _api = ApiService();
  final StorageService _storage = StorageService();
  final TextEditingController _searchController = TextEditingController();

  List<Product> _products = [];
  bool _loading = true;
  String? _error;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _restoreSearch();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _restoreSearch() async {
    final saved = await _storage.loadSearch();
    if (!mounted || saved.isEmpty) return;
    setState(() {
      _query = saved;
      _searchController.text = saved;
    });
  }

  void _onSearchChanged(String value) {
    setState(() => _query = value);
    _storage.saveSearch(value);
  }

  Future<void> _load({bool useSample = false}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = useSample ? sampleProducts : await _api.fetchProducts();
      if (!mounted) return;
      setState(() {
        _products = data;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not load products. Check your internet connection.';
        _loading = false;
      });
    }
  }

  List<Product> get _filtered => _products
      .where((p) => p.title.toLowerCase().contains(_query.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HarvestHub')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search fresh produce...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        tooltip: 'Clear search',
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return ErrorRetry(
        message: _error!,
        onRetry: _load,
        onUseSample: () => _load(useSample: true),
      );
    }
    final items = _filtered;
    if (items.isEmpty) {
      return EmptyState(message: 'No products match "$_query".');
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final product = items[index];
          return ProductCard(
            product: product,
            onAdd: () => widget.onAddToCart(product),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen(
                  product: product,
                  onAddToCart: widget.onAddToCart,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}