import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/search_product.dart';

class SearchApiService {
  static const String _baseUrl = 'https://fakestoreapi.com';

  /// FakeStore không hỗ trợ ?q= nên ta fetch all rồi filter client-side
  /// Đây là pattern thực tế khi API không hỗ trợ full-text search
  Future<List<SearchProduct>> searchProducts(String keyword) async {
    final response =
    await http.get(Uri.parse('$_baseUrl/products'));
    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      final all =
      list.map((e) => SearchProduct.fromJson(e)).toList();

      if (keyword.trim().isEmpty) return all;

      final q = keyword.toLowerCase();
      return all
          .where((p) =>
      p.title.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q))
          .toList();
    }
    throw Exception(
        'Failed to search products. Status: ${response.statusCode}');
  }

  Future<List<SearchProduct>> fetchByCategory(String category) async {
    final encoded = Uri.encodeComponent(category);
    final response = await http
        .get(Uri.parse('$_baseUrl/products/category/$encoded'));
    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      return list.map((e) => SearchProduct.fromJson(e)).toList();
    }
    throw Exception('Failed to load category');
  }
}