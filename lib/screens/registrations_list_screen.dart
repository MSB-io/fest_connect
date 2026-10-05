import 'package:flutter/material.dart';
import '../services/event_service.dart';
import '../theme/app_theme.dart';

/// RegistrationsListScreen: Organizer Participation Tracker & Audit Log
///
/// Concepts Used:
/// 1. Central Repository Access: Reads 'allRegistrations' directly from the shared 'EventService'.
/// 2. Conditional Rendering: Displays an empty state icon and message if no students have registered yet.
/// 3. ListView.separated: Renders student registration records in an efficient, separated list.
class RegistrationsListScreen extends StatelessWidget {
  const RegistrationsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Reference to the shared in-memory mock repository
    final eventService = EventService();

    // Fetch the full list of recorded registrations
    final registrations = eventService.allRegistrations;

    return Scaffold(
      // AppBar with title and subtle divider
      appBar: AppBar(
        title: const Text('Organizer Participation Log'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppTheme.border, height: 1),
        ),
      ),

      // Center container with max width constraint
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: registrations.isEmpty
              // 1. Empty State View (shown before any registrations are submitted)
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_outlined,
                          size: 48, color: AppTheme.textMuted),
                      const SizedBox(height: 12),
                      const Text(
                        'No registrations recorded yet',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Register for an event to see entries tracked here.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                )
              // 2. Populated List View (displays all registered students)
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: registrations.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final reg = registrations[index];

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Pass ID and Time of Registration Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                reg.id,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              Text(
                                '${reg.registeredAt.hour.toString().padLeft(2, '0')}:${reg.registeredAt.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Student Name
                          Text(
                            reg.studentName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),

                          // Roll Number and College Email
                          Text(
                            'Roll: ${reg.rollNumber} • ${reg.email}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Event Name Tag
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Event: ${reg.eventName}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
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
}
