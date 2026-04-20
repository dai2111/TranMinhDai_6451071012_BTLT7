import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_update.dart';

class UserUpdateApiService {
  // dummyjson.com hoạt động ổn trên thiết bị thật, không bị 403
  static const String _baseUrl = 'https://dummyjson.com';

  Future<UserUpdate> fetchUser(int id) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/users/$id'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return UserUpdate.fromJson(jsonDecode(response.body));
    }
    throw Exception('Lỗi tải dữ liệu (${response.statusCode})');
  }

  Future<UserUpdate> updateUser(UserUpdate user) async {
    final response = await http
        .put(
      Uri.parse('$_baseUrl/users/${user.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      // dummyjson trả về object đã merge → parse lại
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      // Nếu response thiếu field thì fallback về user đã gửi
      try {
        return UserUpdate.fromJson(json);
      } catch (_) {
        return user;
      }
    }
    throw Exception('Lỗi cập nhật (${response.statusCode})');
  }
}