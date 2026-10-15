import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class StorageService {
  static const _cartKey = 'cart';
  static const _searchKey = 'search_query';
  static const _nameKey = 'draft_name';
  static const _phoneKey = 'draft_phone';
  static const _addressKey = 'draft_address';

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

  Future<void> saveSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_searchKey, query);
  }

  Future<String> loadSearch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_searchKey) ?? '';
  }

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
}