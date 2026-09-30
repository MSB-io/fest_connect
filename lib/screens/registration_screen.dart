import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/event_service.dart';
import '../theme/app_theme.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final EventService _eventService = EventService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _rollController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Mandatory Form Validators as per Case Study Requirements
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

  String? _validateRollNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your roll number';
    }
    final roll = value.trim();
    // Institutional roll number: 150096724 + 3 digits (12 digits total)
    final rollRegex = RegExp(r'^150096724\d{3}$');
    if (!rollRegex.hasMatch(roll)) {
      return 'Roll number must be 12 digits starting with 150096724 (e.g. 150096724125)';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your college email';
    }
    final email = value.trim();
    // Institutional email format: YYYY.name@isu.ac.in
    final emailRegex =
        RegExp(r'^\d{4}\.[a-zA-Z0-9._]+@isu\.ac\.in$', caseSensitive: false);
    if (!emailRegex.hasMatch(email)) {
      return 'Must be a valid college email: YYYY.name@isu.ac.in';
    }
    return null;
  }

  Future<void> _submitForm(Event event) async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final reg = await _eventService.registerStudent(
      eventId: event.id,
      studentName: _nameController.text,
      rollNumber: _rollController.text,
      email: _emailController.text,
    );

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    if (reg != null) {
      // Navigate to confirmation screen with named route and pass registration as arguments
      Navigator.pushReplacementNamed(
        context,
        '/confirmation',
        arguments: reg,
      );
    } else {
      setState(() {
        _errorMessage = 'Sorry, this event is already full or unavailable.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract Event from route arguments
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
              key: _formKey,
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

                  // Name Field
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

                  // Roll Number Field
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

                  // Email Address Field
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

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : () => _submitForm(event),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
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
