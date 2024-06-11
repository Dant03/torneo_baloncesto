import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class Championship {
  final String id;
  final String name;
  final DateTime date;
  final String location;
  final DateTime registrationDeadline;
  final DateTime startDate;
  final String daysOfWeek;
  final String startTime;
  final String endTime;
  final double tournamentFee;
  final double registrationFee;
  final double matchFee;
  final String imageUrl;
  final int numberOfCourts;

  Championship({
    String? id,
    required this.name,
    required this.date,
    required this.location,
    required this.registrationDeadline,
    required this.startDate,
    required this.daysOfWeek,
    required this.startTime,
    required this.endTime,
    required this.tournamentFee,
    required this.registrationFee,
    required this.matchFee,
    required this.imageUrl,
    required this.numberOfCourts,
  }) : id = id ?? Uuid().v4();

  factory Championship.fromMap(Map<String, dynamic> map) {
    return Championship(
      id: map['id'],
      name: map['name'],
      date: DateTime.parse(map['date']),
      location: map['location'],
      registrationDeadline: DateTime.parse(map['registration_deadline']),
      startDate: DateTime.parse(map['start_date']),
      daysOfWeek: map['days_of_week'],
      startTime: map['start_time'],
      endTime: map['end_time'],
      tournamentFee: (map['tournament_fee'] is int) ? (map['tournament_fee'] as int).toDouble() : map['tournament_fee'],
      registrationFee: (map['registration_fee'] is int) ? (map['registration_fee'] as int).toDouble() : map['registration_fee'],
      matchFee: (map['match_fee'] is int) ? (map['match_fee'] as int).toDouble() : map['match_fee'],
      imageUrl: map['image_url'],
      numberOfCourts: map['number_of_courts'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'location': location,
      'registration_deadline': registrationDeadline.toIso8601String(),
      'start_date': startDate.toIso8601String(),
      'days_of_week': daysOfWeek,
      'start_time': startTime,
      'end_time': endTime,
      'tournament_fee': tournamentFee,
      'registration_fee': registrationFee,
      'match_fee': matchFee,
      'image_url': imageUrl,
      'number_of_courts': numberOfCourts,
    };
  }

  String getFormattedDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  String get formattedDate => getFormattedDate(date);
  String get formattedRegistrationDeadline => getFormattedDate(registrationDeadline);
  String get formattedStartDate => getFormattedDate(startDate);
}
