import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils/task_api_service.dart';
import '../widgets/task_item.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskApiService _api = TaskApiService();
  List<Task> _tasks = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() { _isLoading = true; _error = ''; });
    try {
      final tasks = await _api.fetchTasks();
      setState(() { _tasks = tasks; _isLoading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  Future<void> _deleteTask(int id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;
    final removed = _tasks[index];

    // Optimistic: xóa UI trước
    setState(() => _tasks.removeAt(index));

    try {
      await _api.deleteTask(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          content: Row(children: [
            const Icon(Icons.delete_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Đã xóa: "${removed.title}"',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ]),
          action: SnackBarAction(
            label: 'Hoàn tác',
            textColor: Colors.white,
            onPressed: () => setState(() => _tasks.insert(index, removed)),
          ),
        ));
      }
    } catch (e) {
      // Rollback nếu API lỗi
      setState(() => _tasks.insert(index, removed));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          content: Text('Xóa thất bại: $e'),
        ));
      }
    }
  }

  int get _completedCount => _tasks.where((t) => t.completed).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        title: const Text('Quản Lý Task',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadTasks,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.orange),
            SizedBox(height: 16),
            Text('Đang tải danh sách task...',
                style: TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      )
          : _error.isNotEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  size: 56, color: Colors.redAccent),
              const SizedBox(height: 12),
              const Text('Không thể tải dữ liệu',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(_error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _loadTasks,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Thử lại'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      )
          : Column(
        children: [
          // Stats header
          Container(
            color: Colors.orange,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(
              children: [
                _StatChip(
                    label: 'Tổng',
                    value: '${_tasks.length}',
                    color: Colors.white),
                const SizedBox(width: 12),
                _StatChip(
                    label: 'Hoàn thành',
                    value: '$_completedCount',
                    color: Colors.greenAccent),
                const SizedBox(width: 12),
                _StatChip(
                    label: 'Còn lại',
                    value:
                    '${_tasks.length - _completedCount}',
                    color: Colors.white70),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.orange.shade50,
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            child: const Row(
              children: [
                Icon(Icons.swipe_left_rounded,
                    size: 16, color: Colors.orange),
                SizedBox(width: 6),
                Text(
                  'Vuốt sang trái hoặc nhấn 🗑 để xóa task',
                  style: TextStyle(
                      fontSize: 12, color: Colors.orange),
                ),
              ],
            ),
          ),
          Expanded(
            child: _tasks.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt_rounded,
                      size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Danh sách trống!',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.only(
                  top: 8, bottom: 16),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return TaskItem(
                  task: task,
                  onDelete: () => _deleteTask(task.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatChip(
      {required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        Text(label,
            style: const TextStyle(
                color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}