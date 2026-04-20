class UserUpdate {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String website;
  final String username;

  const UserUpdate({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.website,
    required this.username,
  });

  /// Parse từ dummyjson.com/users/{id}
  factory UserUpdate.fromJson(Map<String, dynamic> json) {
    final firstName = json['firstName'] as String? ?? '';
    final lastName  = json['lastName']  as String? ?? '';
    return UserUpdate(
      id:       json['id']       as int,
      name:     '$firstName $lastName'.trim(),
      email:    json['email']    as String? ?? '',
      phone:    json['phone']    as String? ?? '',
      website:  (json['company'] as Map?)?['name'] as String? ?? '',
      username: json['username'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id':       id,
    'name':     name,
    'email':    email,
    'phone':    phone,
    'website':  website,
    'username': username,
  };

  UserUpdate copyWith({
    String? name,
    String? email,
    String? phone,
    String? website,
    String? username,
  }) {
    return UserUpdate(
      id:       id,
      name:     name     ?? this.name,
      email:    email    ?? this.email,
      phone:    phone    ?? this.phone,
      website:  website  ?? this.website,
      username: username ?? this.username,
    );
  }
}