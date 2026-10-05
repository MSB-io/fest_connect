/// Registration Record Data Model
/// Represents a confirmed student booking for a specific fest event.
class Registration {
  // Unique Pass ID generated at the time of booking (e.g. 'REG-8472910')
  final String id;

  // The ID of the event the student registered for
  final String eventId;

  // The name of the event for quick display on the confirmation pass
  final String eventName;

  // The full name of the student attendee
  final String studentName;

  // The validated 12-digit university roll number (e.g., '150096724125')
  final String rollNumber;

  // The validated institutional email address (e.g., '2024.manthanb@isu.ac.in')
  final String email;

  // Exact date and timestamp when the registration was submitted
  final DateTime registeredAt;

  // Constructor requiring all registration fields
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
