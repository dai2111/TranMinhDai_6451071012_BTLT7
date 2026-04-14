import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductApiService {
  static const String _baseUrl = 'https://fakestoreapi.com';

  Future<Product> fetchProduct({int id = 1}) async {
    final response = await http.get(Uri.parse('$_baseUrl/products/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return Product.fromJson(json);
    } else {
      throw Exception('Failed to load product. Status: ${response.statusCode}');
    }
  }
}