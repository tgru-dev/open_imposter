import 'package:flutter/material.dart';
import '../models/game_settings.dart';

class GameScreen extends StatefulWidget {
  final GameSettings settings;

  const GameScreen({super.key, required this.settings});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Spielstatus
  bool _isGameRunning = false;
  int _score = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Open Imposter'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Spieler: ${widget.settings.players.join(", ")}',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Imposter: ${widget.settings.imposterCount}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text(
              'Kategorien: ${widget.settings.selectedCategories.join(", ")}',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Score: $_score',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isGameRunning = !_isGameRunning;
                  if (!_isGameRunning) {
                    _score = 0;
                  }
                });
              },
              child: Text(_isGameRunning ? 'Stop Game' : 'Start Game'),
            ),
          ],
        ),
      ),
    );
  }
} 