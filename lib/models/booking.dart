import 'package:intl/intl.dart';

class Booking {
  final String id;
  final String userId;
  final String pitchId;
  final DateTime startTime;
  final DateTime endTime;
  final double totalPrice;
  final String teamName;
  final String status;
  final bool isRecurring;
  final String? recurringGroupId;

  Booking({
    required this.id,
    required this.userId,
    required this.pitchId,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.teamName,
    required this.status,
    this.isRecurring = false,
    this.recurringGroupId,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['user_id'],
      pitchId: json['pitch_id'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      totalPrice: (json['total_price'] as num).toDouble(),
      teamName: json['team_name'],
      status: json['status'],
      isRecurring: json['is_recurring'] ?? false,
      recurringGroupId: json['recurring_group_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'pitch_id': pitchId,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'total_price': totalPrice,
      'team_name': teamName,
      'status': status,
      'is_recurring': isRecurring,
      'recurring_group_id': recurringGroupId,
    };
  }
}

class TimeSlot {
  final DateTime time;
  final Booking? booking;

  TimeSlot({required this.time, this.booking});

  bool get isBooked => booking != null;
  String get timeString => DateFormat('h:mm a').format(time);
}
