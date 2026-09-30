class Registration {
  final String id;
  final String eventId;
  final String eventName;
  final String studentName;
  final String rollNumber;
  final String email;
  final DateTime registeredAt;

  Registration({
    required this.id,
    required this.eventId,
    required this.eventName,
    required this.studentName,
    required this.rollNumber,
    required this.email,
    required this.registeredAt,
  });
}
