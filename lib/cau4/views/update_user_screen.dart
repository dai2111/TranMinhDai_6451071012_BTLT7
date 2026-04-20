import 'package:flutter/material.dart';
import '../models/user_update.dart';
import '../utils/user_update_api_service.dart';
import '../widgets/profile_avatar.dart';

class UpdateUserScreen extends StatefulWidget {
  const UpdateUserScreen({super.key});

  @override
  State<UpdateUserScreen> createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _api       = UserUpdateApiService();

  UserUpdate? _originalUser;
  bool _isLoadingUser = true;
  bool _isSubmitting  = false;
  String _loadError   = '';

  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _websiteCtrl;
  late final TextEditingController _usernameCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl     = TextEditingController();
    _emailCtrl    = TextEditingController();
    _phoneCtrl    = TextEditingController();
    _websiteCtrl  = TextEditingController();
    _usernameCtrl = TextEditingController();
    _loadUser();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _websiteCtrl.dispose();
    _usernameCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    setState(() { _isLoadingUser = true; _loadError = ''; });
    try {
      final user = await _api.fetchUser(1);
      _nameCtrl.text     = user.name;
      _emailCtrl.text    = user.email;
      _phoneCtrl.text    = user.phone;
      _websiteCtrl.text  = user.website;
      _usernameCtrl.text = user.username;
      setState(() { _originalUser = user; _isLoadingUser = false; });
    } catch (e) {
      setState(() { _loadError = e.toString(); _isLoadingUser = false; });
    }
  }

  Future<void> _submitUpdate() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      final updated = _originalUser!.copyWith(
        name:     _nameCtrl.text.trim(),
        email:    _emailCtrl.text.trim(),
        phone:    _phoneCtrl.text.trim(),
        website:  _websiteCtrl.text.trim(),
        username: _usernameCtrl.text.trim(),
      );
      final result = await _api.updateUser(updated);
      setState(() { _originalUser = result; _isSubmitting = false; });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: const Color(0xFF667EEA),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: const Row(children: [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('Cập nhật thành công!',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ]),
        ));
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Text('Lỗi: $e'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
          ),
        ),
        foregroundColor: Colors.white,
        title: const Text('Hồ Sơ Cá Nhân',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: _isLoadingUser
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF667EEA)),
            SizedBox(height: 16),
            Text('Đang tải thông tin...',
                style: TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      )
          : _loadError.isNotEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded,
                  size: 56, color: Colors.redAccent),
              const SizedBox(height: 12),
              const Text('Không tải được dữ liệu',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(_loadError,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _loadUser,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Thử lại'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF667EEA),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            // Live avatar header
            ProfileAvatar(
              name: _nameCtrl.text,
              username: _usernameCtrl.text,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionTitle('Thông tin cơ bản'),
                    const SizedBox(height: 12),
                    _buildField(
                      controller: _nameCtrl,
                      label: 'Họ và tên',
                      icon: Icons.person_outline_rounded,
                      validator: (v) => v!.trim().isEmpty
                          ? 'Không được để trống'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      controller: _usernameCtrl,
                      label: 'Username',
                      icon: Icons.alternate_email_rounded,
                      validator: (v) => v!.trim().isEmpty
                          ? 'Không được để trống'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    const _SectionTitle('Liên hệ'),
                    const SizedBox(height: 12),
                    _buildField(
                      controller: _emailCtrl,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v!.trim().isEmpty) return 'Không được để trống';
                        if (!v.contains('@')) return 'Email không hợp lệ';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      controller: _phoneCtrl,
                      label: 'Số điện thoại',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (v) => v!.trim().isEmpty
                          ? 'Không được để trống'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      controller: _websiteCtrl,
                      label: 'Công ty / Website',
                      icon: Icons.business_rounded,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                        _isSubmitting ? null : _submitUpdate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF667EEA),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                          const Color(0xFF667EEA)
                              .withOpacity(0.5),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: _isSubmitting
                            ? const Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 18, height: 18,
                              child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2),
                            ),
                            SizedBox(width: 10),
                            Text('Đang cập nhật...',
                                style: TextStyle(
                                    fontWeight:
                                    FontWeight.bold,
                                    fontSize: 15)),
                          ],
                        )
                            : const Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save_rounded, size: 18),
                            SizedBox(width: 8),
                            Text('Lưu thay đổi',
                                style: TextStyle(
                                    fontWeight:
                                    FontWeight.bold,
                                    fontSize: 15)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: !_isSubmitting,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF667EEA), size: 20),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
            const BorderSide(color: Color(0xFF667EEA), width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
            const BorderSide(color: Colors.redAccent, width: 1.5)),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4, height: 18,
          decoration: BoxDecoration(
              color: const Color(0xFF667EEA),
              borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xFF1A1A2E))),
      ],
    );
  }
}