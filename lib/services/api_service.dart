import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  // Free public API, no account or key needed.
  static const String _url =
      'https://dummyjson.com/products/category/groceries';

  /// Throws an exception on failure so the screen can show an error state.
  Future<List<Product>> fetchProducts() async {
    final response =
        await http.get(Uri.parse(_url)).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw Exception('Server error (${response.statusCode})');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final list = data['products'] as List<dynamic>;
    return list
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}