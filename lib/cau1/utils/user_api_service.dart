import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('$_baseUrl/users'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users. Status: ${response.statusCode}');
    }
  }
}