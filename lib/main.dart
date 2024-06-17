import 'package:flutter/material.dart';
import 'package:tictactic_app/settings_screen.dart';
import 'package:tictactic_app/splash_screen.dart';
import 'package:tictactic_app/tictactoe_screen.dart';

void main() async {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const TicTacToeScreen(),
        '/settings': (context) => SettingsScreen(
              onSettingsChanged: () {},
            ),
      },
      theme: ThemeData(
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.grey[800]),
        ),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.orangeAccent),
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
    );
  }
}
