// Import Flutter's core Material Design UI package
import 'package:flutter/material.dart';

// Import all application screens for navigation routing
import 'screens/event_list_screen.dart'; // Home screen displaying available events
import 'screens/event_detail_screen.dart'; // Screen showing full details of a selected event
import 'screens/registration_screen.dart'; // Form screen for student registration
import 'screens/confirmation_screen.dart'; // Screen displaying generated ticket pass
import 'screens/registrations_list_screen.dart'; // Screen for fest organizers to view all attendees

// Import the custom application theme (colors, fonts, button styles)
import 'theme/app_theme.dart';

/// The main entry point of the Flutter application.
/// Every Flutter and Dart application starts executing from this main() function.
void main() {
  // Ensure that Flutter widget bindings are initialized before running the app.
  // This is required so the Flutter engine is ready to communicate with native platform code.
  WidgetsFlutterBinding.ensureInitialized();

  // Inflate the root widget (FestConnectApp) and attach it to the device screen.
  runApp(const FestConnectApp());
}

/// FestConnectApp is the root widget of the entire application.
/// It extends StatelessWidget because the app configuration itself does not change dynamically.
class FestConnectApp extends StatelessWidget {
  // Constructor with 'super.key' to pass a unique identifier key to the parent StatelessWidget.
  // This helps Flutter efficiently identify and track widgets in the widget tree.
  const FestConnectApp({super.key});

  // The build method describes the user interface structure for this widget.
  @override
  Widget build(BuildContext context) {
    // MaterialApp is the top-level container that configures global theming, title, and routes.
    return MaterialApp(
      // The title of the application (shown in the OS task manager / browser tab)
      title: 'FestConnect',

      // Hide the default red "DEBUG" banner from the top-right corner of the screen
      debugShowCheckedModeBanner: false,

      // Apply our clean, minimalist Black & White Material 3 theme
      theme: AppTheme.lightTheme,

      // The initial screen route that opens when the app first launches ('/' = Event List Screen)
      initialRoute: '/',

      // Named routes table: maps string paths to their corresponding screen widgets.
      // This allows clean navigation using: Navigator.pushNamed(context, '/path')
      routes: {
        // Root path: loads the main Event List Screen
        '/': (context) => const EventListScreen(),

        // Detail path: loads the Event Details Screen
        '/detail': (context) => const EventDetailScreen(),

        // Register path: loads the Student Registration Form Screen
        '/register': (context) => const RegistrationScreen(),

        // Confirmation path: loads the Ticket Pass Confirmation Screen
        '/confirmation': (context) => const ConfirmationScreen(),

        // Registrations path: loads the Organizer Participation Tracker Screen
        '/registrations': (context) => const RegistrationsListScreen(),
      },
    );
  }
}
