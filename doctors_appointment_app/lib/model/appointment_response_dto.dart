import 'enum.dart';

class AppointmentResponse {
  final int? doctorId;
  final String? doctorName;
  final String? qualification;
  final int? patientId;
  final String? patientName;
  final String? patientDob;
  final String? patientGender;
  final int? appointmentId;
  final String? appointmentDate;
  final String? appointmentTime;
  final Status? appointmentStatus;

  AppointmentResponse({
    this.doctorId,
    this.doctorName,
    this.qualification,
    this.patientId,
    this.patientName,
    this.patientDob,
    this.patientGender,
    this.appointmentId,
    this.appointmentDate,
    this.appointmentTime,
    this.appointmentStatus,
  });

  factory AppointmentResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentResponse(
      doctorId: json['doctorId'],
      doctorName: json['doctorName'],
      qualification: json['qualification'],
      patientId: json['patientId'],
      patientName: json['patientName'],
      patientDob: json['patientDob'],
      patientGender: json['patientGender'],
      appointmentId: json['appointmentId'],
      appointmentDate: json['appointmentDate']?.toString(),
      appointmentTime: json['appointmentTime']?.toString(),
      appointmentStatus: Status.values.firstWhere(
            (e) => e.name == json['appointmentStatus'],
        orElse: () => Status.PENDING,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'doctorName': doctorName,
      'qualification': qualification,
      'patientId': patientId,
      'patientName': patientName,
      'patientDob': patientDob,
      'patientGender': patientGender,
      'appointmentId': appointmentId,
      'appointmentDate': appointmentDate,
      'appointmentTime': appointmentTime,
      'appointmentStatus': appointmentStatus?.name,
    };
  }
}
