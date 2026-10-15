import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class StorageService {
  static const _cartKey = 'cart';
  static const _searchKey = 'search_query';
  static const _nameKey = 'draft_name';
  static const _phoneKey = 'draft_phone';
  static const _addressKey = 'draft_address';
  static const _tabKey = 'selected_tab';
  static const _openKey = 'open_screen';
  static const _productsKey = 'cached_products';

  // ---- Basket ----
  Future<void> saveCart(List<CartItem> cart) async {
    final prefs = await SharedPreferences.getInstance();
    final data = cart.map((c) => c.toJson()).toList();
    await prefs.setString(_cartKey, jsonEncode(data));
  }

  Future<List<CartItem>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cartKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // ---- Search ----
  Future<void> saveSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_searchKey, query);
  }

  Future<String> loadSearch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_searchKey) ?? '';
  }

  // ---- Checkout form draft ----
  Future<void> saveCheckoutDraft({
    required String name,
    required String phone,
    required String address,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
    await prefs.setString(_phoneKey, phone);
    await prefs.setString(_addressKey, address);
  }

  Future<Map<String, String>> loadCheckoutDraft() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_nameKey) ?? '',
      'phone': prefs.getString(_phoneKey) ?? '',
      'address': prefs.getString(_addressKey) ?? '',
    };
  }

  Future<void> clearCheckoutDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_nameKey);
    await prefs.remove(_phoneKey);
    await prefs.remove(_addressKey);
  }

  // ---- Selected bottom tab ----
  Future<void> saveTab(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_tabKey, index);
  }

  Future<int> loadTab() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_tabKey) ?? 0;
  }

  // ---- Which page is open on top (detail / checkout) ----
  Future<void> saveOpenScreen(String type, {Product? product}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _openKey,
      jsonEncode({
        'type': type,
        if (product != null) 'product': product.toJson(),
      }),
    );
  }

  Future<Map<String, dynamic>?> loadOpenScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_openKey);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> clearOpenScreen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_openKey);
  }

  // ---- Product list cache ----
  Future<void> saveProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final data = products.map((p) => p.toJson()).toList();
    await prefs.setString(_productsKey, jsonEncode(data));
  }

  Future<List<Product>> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_productsKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}