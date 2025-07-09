class UserRegisterRequestDto {
final String name;
final String email;
final String password;

UserRegisterRequestDto({
  required this.name,
  required this.email,
  required this.password,
});

Map<String, dynamic> toJson() {
  return {
    'name': name,
    'email': email,
    'password': password,
  };
}

factory UserRegisterRequestDto.fromJson(Map<String, dynamic> json) {
return UserRegisterRequestDto(
name: json['name'],
email: json['email'],
password: json['password'],
);
}
}
