import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/doctor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AppointmentBookingScreen extends StatefulWidget {
  final Doctor doctor;

  const AppointmentBookingScreen({super.key, required this.doctor});

  @override
  State<AppointmentBookingScreen> createState() => _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool isSubmitting = false;

  Future<void> _submitAppointment() async {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select date and time.'),
      ));
      return;
    }

    setState(() => isSubmitting = true);

    // Format date as YYYY-MM-DD
    final appointmentDate = "${selectedDate!.year.toString().padLeft(4, '0')}"
        "-${selectedDate!.month.toString().padLeft(2, '0')}"
        "-${selectedDate!.day.toString().padLeft(2, '0')}";

    // Format time as HH:mm
    final hour = selectedTime!.hour.toString().padLeft(2, '0');
    final minute = selectedTime!.minute.toString().padLeft(2, '0');
    final appointmentTime = "$hour:$minute";

    final storage = const FlutterSecureStorage();
    final patientIdStr = await storage.read(key: 'user_id');
    final patientId = patientIdStr != null ? int.tryParse(patientIdStr) ?? 0 : 0;

    final body = {
      "doctorId": widget.doctor.id,
      "patientId": patientId,
      "appointmentDate": appointmentDate,
      "appointmentTime": appointmentTime,
    };

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8081/api/patient/book'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment booked successfully!')),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Failed to book appointment');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: today.add(const Duration(days: 30)),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) setState(() => selectedTime = time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book Appointment with Dr. ${widget.doctor.name}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(selectedDate == null
                  ? 'Select Date'
                  : "${selectedDate!.year.toString().padLeft(4, '0')}-"
                  "${selectedDate!.month.toString().padLeft(2, '0')}-"
                  "${selectedDate!.day.toString().padLeft(2, '0')}"),
              onPressed: _pickDate,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.access_time),
              label: Text(selectedTime == null
                  ? 'Select Time'
                  : selectedTime!.format(context)),
              onPressed: _pickTime,
            ),
            const SizedBox(height: 30),
            isSubmitting
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _submitAppointment,
              child: const Text('Confirm Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}
