import 'package:itdel/Autentikasi/Login/login.dart';

class BookingRuangan {
  int? id;
  int? user_id;
  User? user;
  String? approverRole;
  String? ruangan;
  String? reason;
  DateTime? startDate;
  DateTime? endDate;
  String? status;

  BookingRuangan({
    this.id,
    this.user_id,
    this.user,
    this.approverRole,
    this.ruangan,
    this.reason,
    this.startDate,
    this.endDate,
    this.status,
  });

  factory BookingRuangan.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return BookingRuangan();
    }

    return BookingRuangan(
      id: json['id'] as int?,
      user_id: json['user_id'] as int?,
      approverRole: json['approver_role'] as String?,
      ruangan: json['ruangan'] as String?,
      reason: json['reason'] as String?,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      status: json['status'] as String?,
    );
  }
}
