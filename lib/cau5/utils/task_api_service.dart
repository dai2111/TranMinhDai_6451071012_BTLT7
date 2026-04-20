import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class TaskApiService {
  // dummyjson.com: ổn định, không bị 403 trên thiết bị thật
  static const String _baseUrl = 'https://dummyjson.com';

  Future<List<Task>> fetchTasks({int limit = 15}) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/todos?limit=$limit'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      // dummyjson trả về { todos: [...], total: ..., skip: ..., limit: ... }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final list = data['todos'] as List<dynamic>;
      return list.map((e) => Task.fromJson(e)).toList();
    }
    throw Exception('Lỗi tải dữ liệu (${response.statusCode})');
  }

  Future<void> deleteTask(int id) async {
    final response = await http
        .delete(Uri.parse('$_baseUrl/todos/$id'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Lỗi xóa task (${response.statusCode})');
    }
    // dummyjson trả về object đã xóa kèm isDeleted: true
  }
}