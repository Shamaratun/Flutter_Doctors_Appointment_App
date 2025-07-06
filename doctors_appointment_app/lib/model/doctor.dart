class Doctor {
  final int? id;
  final String name;
  final String email;
  final String? password; // usually kept null in frontend unless creating
  final String? specialization;
  final String? qualification;
  final int? experience;
  final String? hospitalName;
  final String? phone;
  final String? image;
  final String? role;
  final String? createdAt;

  Doctor({
    this.id,
    required this.name,
    required this.email,
    this.password,
    this.specialization,
    this.qualification,
    this.experience,
    this.hospitalName,
    this.phone,
    this.image,
    this.role,
    this.createdAt,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: json['doctor_name'] ?? '',
      email: json['doctor_email'] ?? '',
      password: json['doctor_password'],
      specialization: json['specialization'],
      qualification: json['qualification'],
      experience: json['experience'],
      hospitalName: json['hospitalName'],
      phone: json['phone'],
      image: json['image'],
      role: json['role'],
      createdAt: json['createdAt'] ,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor_name': name,
      'doctor_email': email,
      'doctor_password': password,
      'specialization': specialization,
      'qualification': qualification,
      'experience': experience,
      'hospitalName': hospitalName,
      'phone': phone,
      'image': image,
      'role': role,
      'createdAt': createdAt?.toString(),
    };
  }
}
