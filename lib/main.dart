import 'package:app/notification_service.dart';
import 'package:app/signIn.dart';
import 'package:app/weather_page.dart';
import 'package:app/welcome.dart';
import 'package:app/home.dart';
import 'package:app/admin_panel.dart';
import 'package:app/admin_management.dart';
import 'package:app/public_report_view.dart';
import 'package:app/admin_setup.dart';
import 'package:app/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase/firebase_options.dart';
import 'package:app/report_disaster.dart';
import 'package:app/ReportForm.dart';
import 'package:app/about.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
 
    // Initialize default admin
    await AdminSetup.initializeDefaultAdmin();
    
    NotificationService().initialize();
    runApp(const MyApp());
  } catch (e) {
    print('Error initializing Firebase: $e');
    // Run app even if Firebase fails
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Disaster Management',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomePage(),
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const MyHomePage(),
        '/report': (context) => const Report_disater(),
        '/admin': (context) => const AdminPanel(),
        '/admin-management': (context) => const AdminManagement(),
        '/approved-reports': (context) => const ApprovedReports(),
        '/weather': (context) => const WeatherPage(),
        '/about': (context) => const AboutPage(),
      },
      // Handle unknown routes
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const WelcomePage(),
        );
      },
      // Handle route generation for dynamic routes
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/report-form':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => ReportForm(
                disasterType: args?['disasterType'] ?? 'Emergency',
              ),
            );
          default:
            return null;
        }
      },
    );
  }
}
