class AppointmentDto {
  final int patientId;
  final int doctorId;
  final String appointmentDate; // Format: YYYY-MM-DD
  final String appointmentTime; // Format: HH:mm


  AppointmentDto({
    required this.patientId,
    required this.doctorId,
    required this.appointmentDate,
    required this.appointmentTime,

  });

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'appointmentDate': appointmentDate,
      'appointmentTime': appointmentTime,

    };
  }
}
