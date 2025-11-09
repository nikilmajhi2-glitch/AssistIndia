import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:assistindia/services/background_service.dart';
import 'package:assistindia/utils/prefs.dart';
import 'package:assistindia/screens/bind_screen.dart';
import 'package:assistindia/screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Prefs.init();
  await AndroidAlarmManager.initialize();

  runApp(const AssistIndiaApp());
}

class AssistIndiaApp extends StatelessWidget {
  const AssistIndiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData.dark().copyWith(
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF3949AB),
        secondary: Color(0xFFFDD835),
      ),
      scaffoldBackgroundColor: const Color(0xFF0F1724),
      useMaterial3: true,
      textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Poppins'),
    );

    return MaterialApp(
      title: 'AssistIndia',
      theme: theme,
      home: Prefs.getUserId() == null
          ? const BindScreen()
          : const DashboardScreen(),
    );
  }
}