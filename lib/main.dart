import 'package:flutter/material.dart';
import 'screens/event_list_screen.dart';
import 'screens/event_detail_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/confirmation_screen.dart';
import 'screens/registrations_list_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FestConnectApp());
}

class FestConnectApp extends StatelessWidget {
  const FestConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FestConnect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      // Named routes implementation as required by Dart logic specs
      routes: {
        '/': (context) => const EventListScreen(),
        '/detail': (context) => const EventDetailScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/confirmation': (context) => const ConfirmationScreen(),
        '/registrations': (context) => const RegistrationsListScreen(),
      },
    );
  }
}
