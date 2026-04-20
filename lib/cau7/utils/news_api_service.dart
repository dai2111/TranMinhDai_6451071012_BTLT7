import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/news_post.dart';

class NewsApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  static List<NewsPost> get _mockPosts => List.generate(15, (i) {
    final id = i + 1;
    return NewsPost(
      id: id,
      userId: (id % 5) + 1,
      title: _mockTitles[i % _mockTitles.length],
      body: _mockBodies[i % _mockBodies.length],
    );
  });

  static const List<String> _mockTitles = [
    'Flutter 4.0 ra mắt với nhiều tính năng mới',
    'Dart 3.5 cải thiện hiệu năng đáng kể',
    'Google I/O 2025: Những điểm nổi bật',
    'Xu hướng lập trình mobile năm 2025',
    'So sánh Flutter vs React Native mới nhất',
    'Cách tối ưu ứng dụng Flutter của bạn',
    'State management trong Flutter: Riverpod 3.0',
    'Hướng dẫn tích hợp AI vào ứng dụng Flutter',
    'Top 10 package Flutter hữu ích nhất',
    'Clean Architecture trong Flutter',
    'Flutter Web: Từ A đến Z',
    'Testing Flutter app như một chuyên gia',
    'CI/CD cho dự án Flutter với GitHub Actions',
    'Firebase + Flutter: Best practices 2025',
    'Xây dựng app offline-first với Flutter',
  ];

  static const List<String> _mockBodies = [
    'Phiên bản mới mang đến nhiều cải tiến về hiệu năng và trải nghiệm lập trình viên, bao gồm hot reload nhanh hơn và widget mới.',
    'Cập nhật này tập trung vào việc cải thiện tốc độ biên dịch và giảm kích thước file output cuối cùng.',
    'Sự kiện thường niên của Google mang lại nhiều thông báo thú vị về tương lai của Android và Flutter.',
    'Các chuyên gia dự đoán xu hướng cross-platform development sẽ tiếp tục tăng trưởng mạnh trong năm nay.',
    'Bài phân tích chi tiết so sánh hai framework phổ biến nhất trong lĩnh vực phát triển ứng dụng đa nền tảng.',
  ];

  Future<List<NewsPost>> fetchPosts({int limit = 15}) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/posts?_limit=$limit'))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> list = jsonDecode(response.body);
        return list.map((e) => NewsPost.fromJson(e)).toList();
      }

      print('[NewsAPI] GET posts → ${response.statusCode}, dùng mock data');
      return _mockPosts;
    } on SocketException {
      print('[NewsAPI] Không có mạng, dùng mock data');
      return _mockPosts;
    } catch (e) {
      print('[NewsAPI] Lỗi: $e, dùng mock data');
      return _mockPosts;
    }
  }
}