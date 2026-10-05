import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/event_service.dart';
import '../theme/app_theme.dart';

/// EventListScreen: The Home / Main Screen of the FestConnect App
///
/// Concepts Used:
/// 1. StatefulWidget: The screen needs to redraw when the user selects different category filter chips.
/// 2. Dart Getters: '_filteredEvents' computes the filtered list dynamically based on '_selectedCategory'.
/// 3. Named Routes Navigation: Uses 'Navigator.pushNamed(context, '/detail', arguments: event)'.
/// 4. Responsive Layout: Wrapped in ConstrainedBox(maxWidth: 680) so it looks centered and sleek on web/desktop.
class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  // Reference to our Singleton mock repository
  final EventService _eventService = EventService();

  // Tracks the currently selected category filter
  String _selectedCategory = 'All';

  // Available fest event categories
  final List<String> _categories = [
    'All',
    'Technical',
    'Cultural',
    'Gaming',
    'Creative',
  ];

  /// Dynamically filters the events list based on the chosen category chip
  List<Event> get _filteredEvents {
    if (_selectedCategory == 'All') {
      return _eventService.events;
    }
    return _eventService.events
        .where((e) => e.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top Navigation Bar
      appBar: AppBar(
        title: Row(
          children: [
            // Decorative dark dot logo indicator
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppTheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text('FestConnect'),
          ],
        ),
        actions: [
          // Button to navigate to the Organizer Participation Tracker
          IconButton(
            tooltip: 'View Registrations',
            icon: const Icon(Icons.confirmation_number_outlined, size: 20),
            onPressed: () {
              Navigator.pushNamed(context, '/registrations');
            },
          ),
        ],
        // Subtle 1px bottom border
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppTheme.border, height: 1),
        ),
      ),

      // Center layout with maximum width constraint for clean desktop/web rendering
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header title section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'College Fest 2026',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Browse events, check live seats, and register instantly.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Category Filter ChoiceChips (Horizontal Scroll)
              SizedBox(
                height: 48,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategory == cat;

                    return ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      showCheckmark: false,
                      selectedColor: AppTheme.primary,
                      backgroundColor: AppTheme.surface,
                      labelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppTheme.textPrimary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? AppTheme.primary : AppTheme.border,
                        ),
                      ),
                      onSelected: (selected) {
                        // Update state to trigger UI rebuild with filtered list
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              // Events List section
              Expanded(
                child: _filteredEvents.isEmpty
                    ? Center(
                        child: Text(
                          'No events found in $_selectedCategory.',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: _filteredEvents.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final event = _filteredEvents[index];
                          return _buildEventCard(context, event);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds an individual event card widget
  Widget _buildEventCard(BuildContext context, Event event) {
    // Check seat availability conditions
    final bool isLowSeats = event.seatsRemaining > 0 && event.seatsRemaining <= 5;
    final bool isSoldOut = event.seatsRemaining <= 0;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        // Tap to open event details screen
        onTap: () async {
          // Pass event object as argument through named routes
          await Navigator.pushNamed(
            context,
            '/detail',
            arguments: event,
          );
          // Re-render when returning to update seat count if student registered
          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Category Tag & Seats Availability Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Category Tag badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
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
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),

                  // Seats remaining badge with color-coded dot
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSoldOut
                              ? AppTheme.badgeRed
                              : (isLowSeats
                                  ? Colors.amber[700]
                                  : AppTheme.badgeGreen),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isSoldOut
                            ? 'Full'
                            : '${event.seatsRemaining} seats left',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSoldOut
                              ? AppTheme.badgeRed
                              : (isLowSeats
                                  ? Colors.amber[800]
                                  : AppTheme.badgeGreen),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Event Name
              Text(
                event.name,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),

              const SizedBox(height: 10),

              // Date and Venue Row
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 14, color: AppTheme.textSecondary),
                  const SizedBox(width: 6),
                  Text(
                    event.date,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Icon(Icons.location_on_outlined,
                      size: 14, color: AppTheme.textSecondary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      event.venue,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),
              const Divider(height: 1, color: AppTheme.border),
              const SizedBox(height: 12),

              // Action buttons row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tap to view details',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  // Direct Register Button on card
                  ElevatedButton(
                    onPressed: isSoldOut
                        ? null // Disables button if event is sold out
                        : () async {
                            // Direct navigation to registration form with event argument
                            await Navigator.pushNamed(
                              context,
                              '/register',
                              arguments: event,
                            );
                            // Refresh seat count on return
                            setState(() {});
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: Text(isSoldOut ? 'Sold Out' : 'Register'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
