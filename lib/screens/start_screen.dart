import 'package:flutter/material.dart';
import '../models/game_settings.dart';
import 'game_phase_screen.dart';
import '../main.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final TextEditingController _playerNameController = TextEditingController();
  bool _showImposterHints = false;
  final GameSettings _settings = GameSettings();

  @override
  void dispose() {
    _playerNameController.dispose();
    super.dispose();
  }

  void _toggleDarkMode() {
    darkModeNotifier.value = !darkModeNotifier.value;
  }

  void _toggleImposterHints(bool value) {
    setState(() {
      _showImposterHints = value;
    });
  }

  void _addPlayer() {
    if (_playerNameController.text.isNotEmpty) {
      setState(() {
        _settings.addPlayer(_playerNameController.text);
        _playerNameController.clear();
      });
    }
  }

  void _removePlayer(String name) {
    setState(() {
      _settings.removePlayer(name);
    });
  }

  void _toggleCategory(String category) {
    setState(() {
      _settings.toggleCategory(category);
    });
  }

  void _updateImposterCount(double value) {
    setState(() {
      _settings.numberOfImposters = value.round();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme.of(context).brightness == Brightness.dark ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Open Imposter'),
          actions: [
            IconButton(
              icon: Icon(Theme.of(context).brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode),
              onPressed: _toggleDarkMode,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Spieler hinzufügen
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Spieler hinzufügen',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _playerNameController,
                              decoration: InputDecoration(
                                hintText: 'Spielername',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _addPlayer,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Hinzufügen'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Spielerliste
                if (_settings.players.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Spielerliste',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _settings.players.map((player) {
                            return Chip(
                              label: Text(player),
                              onDeleted: () => _removePlayer(player),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),

                // Imposter Slider
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Anzahl Imposter: ${_settings.numberOfImposters}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                        ),
                      ),
                      Slider(
                        value: _settings.numberOfImposters.toDouble(),
                        min: 1,
                        max: _settings.players.length > 1 ? _settings.players.length - 1 : 1,
                        divisions: _settings.players.length > 2 ? _settings.players.length - 2 : null,
                        onChanged: _settings.players.length > 2 ? _updateImposterCount : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Imposter-Hinweise Option
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Imposter-Hinweise',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                        ),
                      ),
                      Switch(
                        value: _showImposterHints,
                        onChanged: _toggleImposterHints,
                        activeColor: Colors.blue,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Kategorien
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kategorien',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _settings.getAvailableCategories().map((category) {
                          return FilterChip(
                            label: Text(category),
                            selected: _settings.selectedCategories.contains(category),
                            onSelected: (selected) => _toggleCategory(category),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Start Button
                ElevatedButton(
                  onPressed: () {
                    if (_settings.players.length >= 3 && _settings.selectedCategories.isNotEmpty) {
                      // Wähle zufällige Imposter aus
                      List<String> shuffledPlayers = List.from(_settings.players);
                      shuffledPlayers.shuffle();
                      List<String> imposters = shuffledPlayers.take(_settings.numberOfImposters).toList();

                      // Wähle ein zufälliges Wort und einen Hinweis aus
                      Map<String, String> wordWithHint = _settings.getRandomWordWithHint();

                      // Erstelle neue GameSettings mit den ausgewählten Impostern und dem Wort
                      GameSettings newSettings = _settings.copyWith(
                        imposters: imposters,
                        currentWord: wordWithHint['word'],
                        currentHint: wordWithHint['hint'],
                        showImposterHints: _showImposterHints,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GamePhaseScreen(gameSettings: newSettings),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: _settings.players.length >= 3 && _settings.selectedCategories.isNotEmpty ? Colors.purple : Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Spiel starten',
                    style: TextStyle(
                      fontSize: 18,
                      color: _settings.players.length >= 3 && _settings.selectedCategories.isNotEmpty ? Colors.white : Colors.black54,
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