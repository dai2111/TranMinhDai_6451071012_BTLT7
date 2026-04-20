import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class PostApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<Post> createPost({
    required int userId,
    required String title,
    required String body,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/posts'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'userId': userId,
        'title': title,
        'body': body,
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return Post.fromJson(json);
    } else {
      throw Exception('Failed to create post. Status: ${response.statusCode}');
    }
  }
}