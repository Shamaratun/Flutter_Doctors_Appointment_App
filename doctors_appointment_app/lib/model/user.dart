class User {
  final int? id;
  final String name;
  final String email;
  final String password; // Used only during registration or login
  final String? role;
  final String? phone;
  final String? createdAt;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.role,
    this.phone,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'], // Optional: may be null or hidden
      role: json['role'],
      phone: json['phone'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'phone': phone,
      'created_at': createdAt,
    };
  }
}
