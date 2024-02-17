class BookingRuanganBaak {
  final int id;
  final int userId;
  final String ruangan;
  final String reason;
  final String status;
  final String startDate;
  final String endDate;

  BookingRuanganBaak({
    required this.id,
    required this.userId,
    required this.ruangan,
    required this.reason,
    required this.status,
    required this.startDate,
    required this.endDate,
  });

  factory BookingRuanganBaak.fromJson(Map<String, dynamic> json) {
    return BookingRuanganBaak(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      ruangan: json['ruangan'] as String,
      reason: json['reason'] as String,
      status: json['status'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
    );
  }
}
