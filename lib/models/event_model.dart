/// Event Data Model
/// Represents an individual fest event with its schedule, venue, capacity, and remaining seats.
class Event {
  // Unique identifier for the event (e.g., 'ev-1')
  final String id;

  // Title or name of the event (e.g., 'AI & Web3 Hackathon')
  final String name;

  // Domain category for filtering (e.g., 'Technical', 'Cultural', 'Gaming', 'Creative')
  final String category;

  // Scheduled date of the event (e.g., 'Oct 15, 2026')
  final String date;

  // Scheduled time slot (e.g., '09:00 AM - 05:00 PM')
  final String time;

  // Campus location / room where the event takes place (e.g., 'Tech Park Lab 301')
  final String venue;

  // Detailed description and rules of the event
  final String description;

  // Maximum allowed attendees / capacity
  final int totalSeats;

  // Available seats left (mutable so it can decrement when a student registers)
  int seatsRemaining;

  // Constructor requiring all fields to be initialized
  Event({
    required this.id,
    required this.name,
    required this.category,
    required this.date,
    required this.time,
    required this.venue,
    required this.description,
    required this.totalSeats,
    required this.seatsRemaining,
  });

  // Helper method to create a modified copy of an Event object
  Event copyWith({
    String? id,
    String? name,
    String? category,
    String? date,
    String? time,
    String? venue,
    String? description,
    int? totalSeats,
    int? seatsRemaining,
  }) {
    return Event(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      date: date ?? this.date,
      time: time ?? this.time,
      venue: venue ?? this.venue,
      description: description ?? this.description,
      totalSeats: totalSeats ?? this.totalSeats,
      seatsRemaining: seatsRemaining ?? this.seatsRemaining,
    );
  }
}
