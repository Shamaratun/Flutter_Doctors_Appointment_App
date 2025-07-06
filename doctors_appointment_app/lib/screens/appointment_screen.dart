import 'package:flutter/material.dart';
import '../model/appointment_response_dto.dart';
import '../model/enum.dart';
import '../services/appointment_service.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final AppointmentService _appointmentService = AppointmentService();
  late Future<List<AppointmentResponse>> _appointments;

  @override
  void initState() {
    super.initState();
    _appointments = _appointmentService.fetchAppointments();
  }

  Color _getStatusColor(Status? status) {
    switch (status) {
      case Status.APPROVED:
        return Colors.green;
      case Status.COMPLETED:
        return Colors.blue;
      case Status.CANCELLED:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appointments')),
      body: FutureBuilder<List<AppointmentResponse>>(
        future: _appointments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('No appointments found'));
          }

          final appointments = snapshot.data!;
          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appt = appointments[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text('Dr. ${appt.doctorName ?? "Unknown"}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Patient: ${appt.patientName ?? "N/A"}'),
                      Text('Date: ${appt.appointmentDate ?? "N/A"}'),
                      Text('Time: ${appt.appointmentTime ?? "N/A"}'),
                      Text('Status: ${appt.appointmentStatus?.name ?? "Unknown"}',
                          style: TextStyle(
                            color: _getStatusColor(appt.appointmentStatus),
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                  trailing: const Icon(Icons.calendar_today),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
