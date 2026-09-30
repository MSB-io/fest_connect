import 'dart:async';
import '../models/event_model.dart';
import '../models/registration_model.dart';

/// Central Event & Registration Service
/// Implements a reactive, stream-based in-memory repository conforming
/// to Cloud Firestore snapshot and document update patterns.
class EventService {
  static final EventService _instance = EventService._internal();
  factory EventService() => _instance;

  EventService._internal() {
    _initSampleEvents();
  }

  final List<Event> _events = [];
  final List<Registration> _registrations = [];

  // Broadcast stream controller to notify screens of live updates
  final StreamController<List<Event>> _eventsController =
      StreamController<List<Event>>.broadcast();

  Stream<List<Event>> get eventsStream => _eventsController.stream;

  List<Event> get allEvents => List.unmodifiable(_events);
  List<Registration> get allRegistrations => List.unmodifiable(_registrations);

  void _initSampleEvents() {
    _events.addAll([
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

  Event? getEventById(String id) {
    try {
      return _events.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Live stream for a specific event to show real-time seat count
  Stream<Event?> watchEvent(String id) {
    return eventsStream
        .map((events) => getEventById(id))
        .asBroadcastStream();
  }

  /// Registers a student for an event and decrements available seats
  Future<Registration?> registerStudent({
    required String eventId,
    required String studentName,
    required String rollNumber,
    required String email,
  }) async {
    final eventIndex = _events.indexWhere((e) => e.id == eventId);
    if (eventIndex == -1) return null;

    final event = _events[eventIndex];
    if (event.seatsRemaining <= 0) return null;

    // Decrement seats
    event.seatsRemaining -= 1;

    final registration = Registration(
      id: 'REG-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      eventId: event.id,
      eventName: event.name,
      studentName: studentName.trim(),
      rollNumber: rollNumber.trim().toUpperCase(),
      email: email.trim().toLowerCase(),
      registeredAt: DateTime.now(),
    );

    _registrations.add(registration);

    // Notify all active listeners across screens
    _eventsController.add(List.from(_events));

    return registration;
  }

  List<Registration> getRegistrationsForEvent(String eventId) {
    return _registrations.where((r) => r.eventId == eventId).toList();
  }

  void dispose() {
    _eventsController.close();
  }
}
