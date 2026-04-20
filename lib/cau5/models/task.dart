class Task {
  final int id;
  final int userId;
  final String title;
  final bool completed;

  const Task({
    required this.id,
    required this.userId,
    required this.title,
    required this.completed,
  });

  /// Parse từ dummyjson.com/todos
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id:        json['id']        as int,
      userId:    json['userId']    as int,
      title:     json['todo']      as String,   // dummyjson dùng "todo" thay vì "title"
      completed: json['completed'] as bool,
    );
  }
}