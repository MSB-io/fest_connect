import 'package:flutter/material.dart';
import '../models/registration_model.dart';
import '../theme/app_theme.dart';

/// ConfirmationScreen: Displays the Generated Boarding-Pass / Ticket Receipt
///
/// Concepts Used:
/// 1. StatelessWidget: Once generated, the ticket details do not change.
/// 2. ModalRoute Arguments: Extracts the confirmed 'Registration' record.
/// 3. Stack Clearing Navigation: Uses 'Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false)'
///    to clear the previous navigation history and return cleanly to the home screen.
class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Extract the confirmed registration record passed from the registration form
    final reg = ModalRoute.of(context)?.settings.arguments as Registration?;

    return Scaffold(
      // AppBar with disabled back arrow (automaticallyImplyLeading: false)
      appBar: AppBar(
        title: const Text('Confirmation'),
        automaticallyImplyLeading: false, // Prevents pressing back into the submitted form
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppTheme.border, height: 1),
        ),
      ),

      // Center container with max width constraint
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Success Checkmark Badge (Clean monochrome circle with check icon)
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),

                // Success Title & Subtitle
                const Text(
                  'Registration Confirmed',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Your seat has been reserved and stored centrally.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),

                const SizedBox(height: 32),

                // Digital Ticket / Boarding-Pass Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pass ID Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'PASS ID',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                              color: AppTheme.textMuted,
                            ),
                          ),
                          Text(
                            reg?.id ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(height: 1, color: AppTheme.border),
                      const SizedBox(height: 14),

                      // Ticket Details Section
                      _buildTicketDetail('Event', reg?.eventName ?? '-'),
                      const SizedBox(height: 12),
                      _buildTicketDetail('Attendee', reg?.studentName ?? '-'),
                      const SizedBox(height: 12),
                      _buildTicketDetail('Roll Number', reg?.rollNumber ?? '-'),
                      const SizedBox(height: 12),
                      _buildTicketDetail('Email', reg?.email ?? '-'),
                      const SizedBox(height: 12),
                      _buildTicketDetail(
                        'Registered On',
                        reg != null
                            ? '${reg.registeredAt.day}/${reg.registeredAt.month}/${reg.registeredAt.year} at ${reg.registeredAt.hour.toString().padLeft(2, '0')}:${reg.registeredAt.minute.toString().padLeft(2, '0')}'
                            : '-',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Return to Home Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Reset navigation history and route back to the main Event List
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                      );
                    },
                    child: const Text('Back to Event List'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper method to build key-value detail pairs for the ticket card
  Widget _buildTicketDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
