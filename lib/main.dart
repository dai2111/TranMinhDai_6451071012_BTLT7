import 'package:flutter/material.dart';
import 'cau1/views/user_list_screen.dart';
import 'cau2/views/product_detail_screen.dart';
import 'cau3/views/create_post_screen.dart';
import 'cau4/views/update_user_screen.dart';
import 'cau5/views/task_list_screen.dart';
import 'cau6/views/search_screen.dart';
import 'cau7/views/news_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Exercises',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const SelectionScreen(),
    );
  }
}

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_ExerciseItem> exercises = [
      _ExerciseItem(
        number: '01',
        title: 'Fetch User List',
        subtitle: 'GET API · Ứng dụng danh bạ',
        description: 'Lấy danh sách user từ JSONPlaceholder API và hiển thị tên + email.',
        icon: Icons.people_alt_rounded,
        color: Colors.indigo,
        destination: const UserListScreen(),
      ),
      _ExerciseItem(
        number: '02',
        title: 'Product Detail',
        subtitle: 'GET + JSON Parsing · Ứng dụng bán hàng',
        description: 'Hiển thị chi tiết sản phẩm với title, price, description từ API.',
        icon: Icons.shopping_bag_rounded,
        color: Colors.teal,
        destination: const ProductDetailScreen(),
      ),
      _ExerciseItem(
        number: '03',
        title: 'Create Post',
        subtitle: 'POST API · Mạng xã hội',
        description: 'Tạo bài viết mới, gửi JSON body qua http.post() và hiển thị response từ server.',
        icon: Icons.edit_rounded,
        color: Colors.deepPurple,
        destination: const CreatePostScreen(),
      ),
      _ExerciseItem(
        number: '04',
        title: 'Update User Info',
        subtitle: 'PUT API · Hồ sơ cá nhân',
        description: 'Load thông tin user (GET), chỉnh sửa form rồi gửi PUT để cập nhật.',
        icon: Icons.edit_note_rounded,
        color: Color(0xFF667EEA),
        destination: UpdateUserScreen(),
      ),
      _ExerciseItem(
        number: '05',
        title: 'Delete Item',
        subtitle: 'DELETE API · Quản lý task',
        description: 'Xóa task bằng http.delete(), Dismissible vuốt hoặc icon button.',
        icon: Icons.delete_outline_rounded,
        color: Colors.orange,
        destination: TaskListScreen(),
      ),
      _ExerciseItem(
        number: '06',
        title: 'Search API',
        subtitle: 'Query Params · Tìm kiếm sản phẩm',
        description: 'Tìm kiếm theo keyword với debounce + lọc theo category.',
        icon: Icons.search_rounded,
        color: Colors.pink,
        destination: SearchScreen(),
      ),
      _ExerciseItem(
        number: '07',
        title: 'Pull to Refresh',
        subtitle: 'RefreshIndicator · Tin tức',
        description: 'Kéo xuống để reload dữ liệu với RefreshIndicator animation.',
        icon: Icons.refresh_rounded,
        color: Color(0xFF3A86FF),
        destination: NewsScreen(),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        title: const Text(
          'Flutter Exercises',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Colors.indigo,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: const Text(
              'Chọn bài tập để bắt đầu',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final item = exercises[index];
                return _ExerciseCard(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseItem {
  final String number;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final Widget destination;

  const _ExerciseItem({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.destination,
  });
}

class _ExerciseCard extends StatelessWidget {
  final _ExerciseItem item;
  const _ExerciseCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => item.destination),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: item.color.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 90,
              height: 110,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bài',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    item.number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(item.icon, color: Colors.white70, size: 20),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: item.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(Icons.arrow_forward_ios_rounded,
                  size: 16, color: item.color),
            ),
          ],
        ),
      ),
    );
  }
}