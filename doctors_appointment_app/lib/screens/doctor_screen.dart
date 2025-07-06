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
                child: ListTile(
                  title: Text(doctor.name),
                  subtitle: Text(
                    '${doctor.specialization ?? ''} - ${doctor.qualification ?? ''}',
                  ),
                  trailing: ElevatedButton(
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
              );
            },
          );
        },
      ),
    );
  }
}
