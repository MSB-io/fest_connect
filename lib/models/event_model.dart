class Event {
  final String id;
  final String name;
  final String category;
  final String date;
  final String time;
  final String venue;
  final String description;
  final int totalSeats;
  int seatsRemaining;

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
