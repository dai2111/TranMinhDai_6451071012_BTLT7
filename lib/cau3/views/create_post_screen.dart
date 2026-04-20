import 'package:flutter/material.dart';
import '../models/post.dart';
import '../utils/post_api_service.dart';
import '../widgets/response_card.dart';

enum PostStatus { idle, loading, success, error }

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  final PostApiService _apiService = PostApiService();

  PostStatus _status = PostStatus.idle;
  Post? _responsePost;
  String _errorMessage = '';

  int _charCount = 0;
  static const int _maxBodyChars = 300;

  @override
  void initState() {
    super.initState();
    _bodyController.addListener(() {
      setState(() => _charCount = _bodyController.text.length);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submitPost() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _status = PostStatus.loading;
      _responsePost = null;
      _errorMessage = '';
    });

    try {
      final post = await _apiService.createPost(
        userId: 1,
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
      );

      setState(() {
        _status = PostStatus.success;
        _responsePost = post;
      });

      // Show snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: const Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  'Post created successfully!',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _status = PostStatus.error;
        _errorMessage = e.toString();
      });
    }
  }

  void _resetForm() {
    _titleController.clear();
    _bodyController.clear();
    setState(() {
      _status = PostStatus.idle;
      _responsePost = null;
      _errorMessage = '';
      _charCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text(
          'Tạo Bài Viết',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          if (_status != PostStatus.idle)
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Viết lại',
              onPressed: _resetForm,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.deepPurple, Color(0xFF7B2FBE)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit_rounded,
                        color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chia sẻ điều gì đó',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Bài viết sẽ được gửi qua POST API',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title field
                  _buildLabel('Tiêu đề bài viết', Icons.title_rounded),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _titleController,
                    enabled: _status != PostStatus.loading,
                    maxLength: 100,
                    decoration: _inputDecoration(
                      hint: 'Nhập tiêu đề bài viết...',
                      icon: Icons.short_text_rounded,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Tiêu đề không được để trống';
                      }
                      if (value.trim().length < 5) {
                        return 'Tiêu đề phải có ít nhất 5 ký tự';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Body field
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLabel('Nội dung', Icons.notes_rounded),
                      Text(
                        '$_charCount/$_maxBodyChars',
                        style: TextStyle(
                          fontSize: 12,
                          color: _charCount > _maxBodyChars
                              ? Colors.red
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _bodyController,
                    enabled: _status != PostStatus.loading,
                    maxLines: 6,
                    maxLength: _maxBodyChars,
                    decoration: _inputDecoration(
                      hint: 'Hôm nay bạn đang nghĩ gì?',
                      icon: Icons.article_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nội dung không được để trống';
                      }
                      if (value.trim().length < 10) {
                        return 'Nội dung phải có ít nhất 10 ký tự';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 8),

                  // Info chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline_rounded,
                            size: 14, color: Colors.deepPurple.shade300),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'userId mặc định là 1. Server trả về JSON với id mới.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.deepPurple.shade300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _status == PostStatus.loading
                          ? null
                          : _submitPost,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                        Colors.deepPurple.withOpacity(0.5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _status == PostStatus.loading
                          ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Đang gửi...',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                          : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send_rounded, size: 18),
                          SizedBox(width: 10),
                          Text(
                            'Đăng bài viết',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Response section
            if (_status == PostStatus.success && _responsePost != null) ...[
              ResponseCard(post: _responsePost!),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _resetForm,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Tạo bài viết mới'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.deepPurple,
                    side: const BorderSide(color: Colors.deepPurple),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],

            if (_status == PostStatus.error) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        color: Colors.redAccent, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Gửi bài thất bại',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _errorMessage,
                            style: const TextStyle(
                                color: Colors.redAccent, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.deepPurple),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
      prefixIcon: Icon(icon, color: Colors.deepPurple.shade200, size: 20),
      filled: true,
      fillColor: Colors.white,
      counterStyle: const TextStyle(fontSize: 0, height: 0), // hide counter
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade100),
      ),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}