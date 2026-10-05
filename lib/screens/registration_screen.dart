import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/event_service.dart';
import '../theme/app_theme.dart';

/// RegistrationScreen: Form Screen to Register a Student for an Event
///
/// Concepts Used:
/// 1. Form & `GlobalKey<FormState>`: Manages form validation state across all fields.
/// 2. TextEditingControllers: Manages input text for Name, Roll No, and Email.
/// 3. Memory Management: Controllers are disposed in dispose() to avoid memory leaks.
/// 4. Regular Expressions (RegEx): Enforces institutional data standards.
/// 5. Navigator.pushReplacementNamed: Replaces form in the navigation stack with
///    the confirmation pass so the user cannot press Back to resubmit.
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Global key uniquely identifying the Form widget to trigger validation
  final _formKey = GlobalKey<FormState>();

  // Reference to the shared in-memory mock repository
  final EventService _eventService = EventService();

  // Text editing controllers to capture user input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Error message state if registration fails (e.g., event full)
  String? _errorMessage;

  @override
  void dispose() {
    // Clean up controllers when the widget is removed from the widget tree
    _nameController.dispose();
    _rollController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// Validates the student's full name:
  /// - Non-empty
  /// - Minimum 2 characters
  /// - Only alphabetic characters, spaces, dots, or apostrophes
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    final nameRegex = RegExp(r"^[a-zA-Z\s\.\']+$");
    if (!nameRegex.hasMatch(value.trim())) {
      return 'Name can only contain alphabetic characters';
    }
    return null;
  }

  /// Validates the institutional 12-digit roll number:
  /// - Must match ITM Skills University prefix: 150096724 + 3 student digits
  /// - Example: 150096724125
  String? _validateRollNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your roll number';
    }
    final roll = value.trim();
    final rollRegex = RegExp(r'^150096724\d{3}$');
    if (!rollRegex.hasMatch(roll)) {
      return 'Roll number must be 12 digits starting with 150096724 (e.g. 150096724125)';
    }
    return null;
  }

  /// Validates the institutional email:
  /// - Strictly enforces the @isu.ac.in domain
  /// - Must follow standard format: YYYY.name@isu.ac.in (e.g., 2024.manthanb@isu.ac.in)
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your college email';
    }
    final email = value.trim();
    final emailRegex =
        RegExp(r'^\d{4}\.[a-zA-Z0-9._]+@isu\.ac\.in$', caseSensitive: false);
    if (!emailRegex.hasMatch(email)) {
      return 'Must be a valid college email: YYYY.name@isu.ac.in';
    }
    return null;
  }

  /// Submits the registration form after validating all input fields
  void _submitForm(Event event) {
    // Dismiss soft keyboard
    FocusScope.of(context).unfocus();

    // Trigger validation on all FormFields; abort if any validator returns an error
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Attempt to register the student in our mock repository
    final reg = _eventService.registerStudent(
      eventId: event.id,
      studentName: _nameController.text,
      rollNumber: _rollController.text,
      email: _emailController.text,
    );

    if (reg != null) {
      // Success: replace current route with confirmation screen passing ticket record
      Navigator.pushReplacementNamed(
        context,
        '/confirmation',
        arguments: reg,
      );
    } else {
      // Event became full in the meantime
      setState(() {
        _errorMessage = 'Sorry, this event is already full.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract target event passed as named route argument
    final event = ModalRoute.of(context)?.settings.arguments as Event?;

    if (event == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: const Center(
          child: Text('Invalid event selection.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Registration'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppTheme.border, height: 1),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey, // Connects the form key to validate children
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Summary Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.category.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          event.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${event.date} • ${event.venue}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Student Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Enter your details below to confirm your seat.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 1. Full Name Input Field
                  const Text(
                    'Full Name',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Alex Johnson',
                      prefixIcon: Icon(Icons.person_outline, size: 20),
                    ),
                    validator: _validateName,
                    textInputAction: TextInputAction.next,
                  ),

                  const SizedBox(height: 18),

                  // 2. Roll Number Input Field
                  const Text(
                    'Roll Number',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _rollController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'e.g. 150096724125',
                      prefixIcon: Icon(Icons.badge_outlined, size: 20),
                    ),
                    validator: _validateRollNumber,
                    textInputAction: TextInputAction.next,
                  ),

                  const SizedBox(height: 18),

                  // 3. College Email Input Field
                  const Text(
                    'College Email',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'e.g. 2024.manthanb@isu.ac.in',
                      prefixIcon: Icon(Icons.mail_outline, size: 20),
                    ),
                    validator: _validateEmail,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submitForm(event),
                  ),

                  // Error Banner (displayed if event is full)
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline,
                              size: 18, color: AppTheme.badgeRed),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.badgeRed,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Submit Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _submitForm(event),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Complete Registration',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
