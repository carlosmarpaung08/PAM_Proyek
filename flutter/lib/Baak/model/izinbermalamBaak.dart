class IzinBermalam {
  final int id;
  final int userId;
  final String status;
  final String reason;
  final String startDate;
  final String endDate;

  IzinBermalam({
    required this.id,
    required this.userId,
    required this.status,
    required this.reason,
    required this.startDate,
    required this.endDate,
  });

  factory IzinBermalam.fromJson(Map<String, dynamic> json) {
    return IzinBermalam(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      status: json['status'] as String,
      reason: json['reason'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
    );
  }
}
