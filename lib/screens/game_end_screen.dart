import 'package:flutter/material.dart';

class GameEndScreen extends StatelessWidget {
  final List<String> imposters;
  final String word;

  const GameEndScreen({
    super.key,
    required this.imposters,
    required this.word,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.grey[200];
    final cardColor = isDarkMode ? Colors.grey[800] : Colors.white;
    final buttonColor = isDarkMode ? Colors.blue[700] : Colors.blue;
    final buttonBackgroundColor = isDarkMode ? Colors.blue[900] : Colors.blue[50];

    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      const Text(
                        'Spiel beendet!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Das Wort war:',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        word,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Die Imposter waren:',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...imposters.map((imposter) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          imposter,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )).toList(),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: buttonBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Zurück zum Start',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 