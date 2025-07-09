import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/appointment_dto.dart';
import '../model/appointment_response_dto.dart';  // Import your model here

class AppointmentService {
  final String baseUrl = 'http://10.0.2.2:8081';

  Future<bool> bookAppointment(AppointmentDto dto) async {
    final url = Uri.parse("$baseUrl/book/appointment/by");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(dto.toJson()),
    );

    if (response.statusCode == 201) {
      print("Appointment booked successfully.");
      return true;
    } else {
      print("Failed to book appointment: ${response.body}");
      return false;
    }
  }


  Future<List<AppointmentResponse>> fetchAppointments() async {
    final response = await http.get(Uri.parse('$baseUrl/api/appointments'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => AppointmentResponse.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load appointments');
    }
  }
}
