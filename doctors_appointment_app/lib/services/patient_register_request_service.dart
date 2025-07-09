import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../model/user_register_request_dto.dart';

class PatientRegisterRequestService {
  static const String _baseUrl = 'http://10.0.2.2:8082/api/user';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<int?> getUserId() async {
    final idStr = await _storage.read(key: 'user_id');
    if (idStr != null) {
      return int.tryParse(idStr);
    }
    return null;
  }

  Future<Map<String, dynamic>> fetchUserProfile(int userId) async {
    final url = Uri.parse('$_baseUrl/get/my/info?id=$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load profile: ${response.statusCode}');
    }
  }

  Future<void> updateUserProfile({
    required int userId,
    required String name,
    required String phoneNo,
    required String address,
  }) async {
    final url = Uri.parse('$_baseUrl/edit/my/info/$userId');
    final body = jsonEncode({
      'name': name,
      'phoneNo': phoneNo,
      'address': address,
    });

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile: ${response.statusCode}');
    }
  }

  Future<void> registerUser(UserRegisterRequestDto user) async {
    final url = Uri.parse('http://10.0.2.2:8082/api/auth/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('User registered successfully');
    } else {
      print('Failed to register user: ${response.body}');
      throw Exception('Register failed');
    }
  }
}