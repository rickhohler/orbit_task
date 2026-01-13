import 'package:flutter/material.dart';
import 'src/ui/home_page.dart';

// -----------------------------------------------------------------------------
// App Entry Point
// -----------------------------------------------------------------------------

void main() {
  runApp(const OrbitTaskExampleApp());
}

/// The root widget of the OrbitTask example application.
///
/// Sets up the theme (Dark Mode, Deep Purple) and navigation.
class OrbitTaskExampleApp extends StatelessWidget {
  const OrbitTaskExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OrbitTask Example',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0B15), // Deep space background
        // Custom Orbit color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ).copyWith(
            primary: const Color(0xFF6200EA),
            secondary: const Color(0xFF00E5FF), // Neon Cyan accent
            tertiary: const Color(0xFFFF00E5), // Neon Magenta accent
            surface: const Color(0xFF1A1425),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1425),
          elevation: 0,
        ),
        // Removed CardTheme to fix "argument type 'CardTheme' can't be assigned to parameter type 'CardThemeData?'"
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6200EA),
            foregroundColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
