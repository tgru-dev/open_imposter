import 'package:flutter/material.dart';
import 'screens/start_screen.dart';

final ValueNotifier<bool> darkModeNotifier = ValueNotifier(false);

void main() {
  runApp(const MyGame());
}

class MyGame extends StatelessWidget {
  const MyGame({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: darkModeNotifier,
      builder: (context, isDarkMode, _) {
        return MaterialApp(
          title: 'Open Imposter',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            brightness: Brightness.light,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.purple,
            brightness: Brightness.dark,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const StartScreen(),
        );
      },
    );
  }
}
