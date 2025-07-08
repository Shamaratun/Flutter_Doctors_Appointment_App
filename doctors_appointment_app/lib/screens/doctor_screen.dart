import 'package:flutter/material.dart';
import '../model/doctor.dart';
import '../services/doctor_service.dart';
import 'appointment_booking_screen.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final DoctorService _doctorService = DoctorService();
  late Future<List<Doctor>> _doctors;

  @override
  void initState() {
    super.initState();
    _doctors = _doctorService.getAllDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Available Doctors")),
      body: FutureBuilder<List<Doctor>>(
        future: _doctors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final doctors = snapshot.data ?? [];

          return ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Specialization: ${doctor.specialization ?? 'N/A'}'),
                      Text('Qualification: ${doctor.qualification ?? 'N/A'}'),
                      Text('Experience: ${doctor.experience ?? 'N/A'} years'),
                      Text('Email: ${doctor.email ?? 'N/A'}'),
                      Text('Phone: ${doctor.phone ?? 'N/A'}'),
                      Text('Hospital: ${doctor.hospitalName ?? 'N/A'}'),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    AppointmentBookingScreen(doctor: doctor),
                              ),
                            );
                          },
                          child: const Text("Take Appointment"),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
