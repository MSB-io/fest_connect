import '../models/event_model.dart';
import '../models/registration_model.dart';

/// Simple In-Memory Mock Service for FestConnect
/// Stores mock events and registrations in Dart Lists (no external database).
class EventService {
  // Singleton pattern: ensures all screens share the exact same mock data
  static final EventService _instance = EventService._internal();
  factory EventService() => _instance;

  EventService._internal() {
    _loadSampleEvents();
  }

  // In-memory mock lists (held in RAM while app is running)
  final List<Event> events = [];
  final List<Registration> registrations = [];

  List<Event> get allEvents => events;
  List<Registration> get allRegistrations => registrations;

  void _loadSampleEvents() {
    events.addAll([
      Event(
        id: 'ev-1',
        name: 'AI & Web3 Hackathon',
        category: 'Technical',
        date: 'Oct 15, 2026',
        time: '09:00 AM - 05:00 PM',
        venue: 'Tech Park Lab 301',
        description:
            'A 24-hour sprint to build decentralized AI applications. Teams of up to 4 members. Hardware and mentorship provided on-site.',
        totalSeats: 40,
        seatsRemaining: 12,
      ),
      Event(
        id: 'ev-2',
        name: 'Battle of the Bands',
        category: 'Cultural',
        date: 'Oct 16, 2026',
        time: '06:00 PM - 09:30 PM',
        venue: 'Main Open Amphitheatre',
        description:
            'Annual inter-college acoustic & rock band competition. Cash prizes for best vocalist, drummer, and original composition.',
        totalSeats: 60,
        seatsRemaining: 5,
      ),
      Event(
        id: 'ev-3',
        name: 'Speed Coding Showdown',
        category: 'Technical',
        date: 'Oct 15, 2026',
        time: '02:00 PM - 04:30 PM',
        venue: 'Computing Centre 2',
        description:
            'Test your algorithmic speed and debugging skills across multiple rounds of competitive programming challenges.',
        totalSeats: 50,
        seatsRemaining: 18,
      ),
      Event(
        id: 'ev-4',
        name: 'Valorant Championship',
        category: 'Gaming',
        date: 'Oct 17, 2026',
        time: '11:00 AM - 06:00 PM',
        venue: 'Indoor Esports Arena',
        description:
            '5v5 knockout esports tournament. BYOD or use campus tournament rigs. High-speed LAN and live shoutcasting.',
        totalSeats: 32,
        seatsRemaining: 4,
      ),
      Event(
        id: 'ev-5',
        name: 'Street Photography Walk',
        category: 'Creative',
        date: 'Oct 16, 2026',
        time: '07:30 AM - 10:30 AM',
        venue: 'Campus North Lawn Gate',
        description:
            'Guided photo walk capturing the morning spirit and preparations of the college fest. Phone cameras and DSLRs welcome.',
        totalSeats: 25,
        seatsRemaining: 9,
      ),
    ]);
  }

  // Find an event by its ID
  Event? getEventById(String id) {
    try {
      return events.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  // Register student: decrements seat count and adds a registration record
  Registration? registerStudent({
    required String eventId,
    required String studentName,
    required String rollNumber,
    required String email,
  }) {
    final event = getEventById(eventId);
    if (event == null || event.seatsRemaining <= 0) {
      return null;
    }

    // Decrease available seats in mock list
    event.seatsRemaining -= 1;

    // Create new registration record
    final registration = Registration(
      id: 'REG-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      eventId: event.id,
      eventName: event.name,
      studentName: studentName.trim(),
      rollNumber: rollNumber.trim().toUpperCase(),
      email: email.trim().toLowerCase(),
      registeredAt: DateTime.now(),
    );

    registrations.add(registration);
    return registration;
  }
}
