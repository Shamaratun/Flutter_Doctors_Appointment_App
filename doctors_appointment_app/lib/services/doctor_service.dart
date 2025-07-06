import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/doctor.dart';

class DoctorService {
  final String baseUrl = 'http://10.0.2.2:8081';

  Future<List<Doctor>> getAllDoctors() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/admin/get/all/doctors'),
    );    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Doctor.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load doctors');
    }
  }
}
