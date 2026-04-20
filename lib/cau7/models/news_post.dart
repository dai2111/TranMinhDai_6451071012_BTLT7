class NewsPost {
  final int id;
  final String title;
  final String body;
  final int userId;

  const NewsPost({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
  });

  factory NewsPost.fromJson(Map<String, dynamic> json) {
    return NewsPost(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      userId: json['userId'] as int,
    );
  }
}