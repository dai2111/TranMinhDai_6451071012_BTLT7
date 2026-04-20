import 'package:flutter/material.dart';
import '../models/news_post.dart';
import '../utils/news_api_service.dart';
import '../widgets/news_card.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsApiService _api = NewsApiService();

  List<NewsPost> _posts = [];
  bool _isLoading = true;
  bool _usingMockData = false;
  DateTime? _lastRefreshed;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    setState(() {
      _isLoading = true;
      _usingMockData = false;
    });

    final posts = await _api.fetchPosts();

    // Nhận biết mock: title tiếng Việt
    final isMock = posts.isNotEmpty &&
        posts.first.title.contains(
            RegExp(r'[àáâãèéêìíòóôõùúăđĩũơưạảấầẩẫậắằẳẵặẹẻẽếềểễệỉịọỏốồổỗộớờởỡợụủứừửữựỳỵýỷỹ]'));

    setState(() {
      _posts = posts;
      _isLoading = false;
      _usingMockData = isMock;
      _lastRefreshed = DateTime.now();
    });
  }

  /// Called by RefreshIndicator — không bao giờ throw
  Future<void> _onRefresh() async {
    final posts = await _api.fetchPosts();

    final isMock = posts.isNotEmpty &&
        posts.first.title.contains(
            RegExp(r'[àáâãèéêìíòóôõùúăđĩũơưạảấầẩẫậắằẳẵặẹẻẽếềểễệỉịọỏốồổỗộớờởỡợụủứừửữựỳỵýỷỹ]'));

    setState(() {
      _posts = posts;
      _usingMockData = isMock;
      _lastRefreshed = DateTime.now();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF3A86FF),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          content: Row(
            children: [
              const Icon(Icons.refresh_rounded,
                  color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                isMock
                    ? 'Đã làm mới (dữ liệu mẫu)'
                    : 'Đã cập nhật ${posts.length} bài viết',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      );
    }
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3A86FF), Color(0xFF0043CE)],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Tin Tức',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Làm mới',
            onPressed: _onRefresh,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF3A86FF)),
            SizedBox(height: 16),
            Text('Đang tải tin tức...',
                style: TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      )
          : RefreshIndicator(
        color: const Color(0xFF3A86FF),
        strokeWidth: 2.5,
        displacement: 60,
        onRefresh: _onRefresh,
        child: CustomScrollView(
          slivers: [
            // ── Mock data banner ──────────────────────────────
            if (_usingMockData)
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  color: Colors.amber.shade50,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded,
                          color: Colors.amber.shade700, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'API không khả dụng — đang hiển thị dữ liệu mẫu.',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.amber.shade800),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Pull hint banner
            SliverToBoxAdapter(
              child: Container(
                color: const Color(0xFF3A86FF),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_downward_rounded,
                        color: Colors.white70, size: 14),
                    const SizedBox(width: 6),
                    const Text(
                      'Kéo xuống để làm mới',
                      style: TextStyle(
                          color: Colors.white70, fontSize: 12),
                    ),
                    const Spacer(),
                    if (_lastRefreshed != null)
                      Text(
                        'Cập nhật: ${_formatTime(_lastRefreshed)}',
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 11),
                      ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => NewsCard(
                    post: _posts[index],
                    index: index,
                  ),
                  childCount: _posts.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}