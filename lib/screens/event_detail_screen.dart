import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/event_service.dart';
import '../theme/app_theme.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Extract event passed via named route arguments
    final initialEvent = ModalRoute.of(context)?.settings.arguments as Event?;

    if (initialEvent == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Event Details')),
        body: const Center(
          child: Text('No event selected.'),
        ),
      );
    }

    final eventService = EventService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppTheme.border, height: 1),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: StreamBuilder<Event?>(
            stream: eventService.watchEvent(initialEvent.id),
            initialData: eventService.getEventById(initialEvent.id) ?? initialEvent,
            builder: (context, snapshot) {
              final event = snapshot.data ?? initialEvent;
              final bool isSoldOut = event.seatsRemaining <= 0;
              final bool isLowSeats =
                  event.seatsRemaining > 0 && event.seatsRemaining <= 5;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Text(
                        event.category.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Event Title
                    Text(
                      event.name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Live Seats Counter Card (Crucial Outcome requirement)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSoldOut
                                  ? AppTheme.badgeRed
                                  : (isLowSeats
                                      ? Colors.amber[700]
                                      : AppTheme.badgeGreen),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Live Seat Availability',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  isSoldOut
                                      ? 'Registration Closed (0 seats remaining)'
                                      : '${event.seatsRemaining} of ${event.totalSeats} seats remaining',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: isSoldOut
                                        ? AppTheme.badgeRed
                                        : AppTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!isSoldOut)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'REAL-TIME',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Information details
                    _buildInfoRow(
                      icon: Icons.calendar_today_outlined,
                      title: 'Date & Time',
                      subtitle: '${event.date} • ${event.time}',
                    ),
                    const Divider(height: 24, color: AppTheme.border),
                    _buildInfoRow(
                      icon: Icons.location_on_outlined,
                      title: 'Venue',
                      subtitle: event.venue,
                    ),
                    const Divider(height: 24, color: AppTheme.border),
                    _buildInfoRow(
                      icon: Icons.people_outline,
                      title: 'Capacity',
                      subtitle: '${event.totalSeats} registered participants max',
                    ),

                    const SizedBox(height: 24),

                    // Description section
                    const Text(
                      'About the Event',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.description,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: AppTheme.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Register Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isSoldOut
                            ? null
                            : () {
                                // Named route with arguments to Registration Form
                                Navigator.pushNamed(
                                  context,
                                  '/register',
                                  arguments: event,
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          isSoldOut ? 'Sold Out' : 'Register for this Event',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppTheme.textPrimary),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
