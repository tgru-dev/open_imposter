import 'package:flutter/material.dart';
import '../models/game_settings.dart';
import 'dart:math';
import 'game_end_screen.dart';

class GamePhaseScreen extends StatefulWidget {
  final GameSettings gameSettings;

  const GamePhaseScreen({Key? key, required this.gameSettings}) : super(key: key);

  @override
  State<GamePhaseScreen> createState() => _GamePhaseScreenState();
}

class _GamePhaseScreenState extends State<GamePhaseScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _isCardRevealed = false;
  int _currentPlayerIndex = 0;
  bool _isDarkMode = false;
  bool _showEndButton = false;
  bool _hasCardBeenRevealedForCurrentPlayer = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.4),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _revealCard() {
    if (!_isCardRevealed) {
      _controller.forward();
      setState(() {
        _isCardRevealed = true;
        _hasCardBeenRevealedForCurrentPlayer = true;
      });
      // Nach 1,5 Sekunden automatisch wieder verdecken, wenn noch nicht Endphase
      if (!_showEndButton) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted && _isCardRevealed && !_showEndButton) {
            _controller.reverse();
            setState(() {
              _isCardRevealed = false;
            });
          }
        });
      }
    }
  }

  void _nextPlayer() {
    if (_currentPlayerIndex < widget.gameSettings.players.length - 1) {
      setState(() {
        _currentPlayerIndex++;
        _isCardRevealed = false;
        _hasCardBeenRevealedForCurrentPlayer = false;
        _controller.reset();
      });
    } else {
      // Zeige den Startspieler an
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: _isDarkMode ? Colors.grey[800] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Startspieler',
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black87,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              '${widget.gameSettings.players.first} beginnt das Spiel!',
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black87,
                fontSize: 18,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _showEndButton = true;
                    _isCardRevealed = false;
                  });
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.grey[200];
    final cardColor = isDarkMode ? Colors.grey[800] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final buttonColor = Colors.purple;
    final buttonTextColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Spielphase'),
        backgroundColor: buttonColor,
        foregroundColor: buttonTextColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_showEndButton)
              GestureDetector(
                onVerticalDragEnd: (details) {
                  if (details.primaryVelocity! < 0) {
                    _revealCard();
                  }
                },
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.4,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.gameSettings.players[_currentPlayerIndex],
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (_isCardRevealed) ...[
                          if (widget.gameSettings.imposters.contains(widget.gameSettings.players[_currentPlayerIndex])) ...[
                            Text(
                              'Du bist der Imposter!',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (widget.gameSettings.showImposterHints)
                              Text(
                                'Hinweis: ${widget.gameSettings.currentHint}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                          ] else ...[
                            Text(
                              'Wort: ${widget.gameSettings.currentWord}',
                              style: TextStyle(
                                fontSize: 24,
                                color: textColor,
                              ),
                            ),
                          ],
                        ] else ...[
                          Text(
                            'Nach oben wischen',
                            style: TextStyle(
                              fontSize: 18,
                              color: textColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 30),
            if ((_isCardRevealed || _hasCardBeenRevealedForCurrentPlayer) && !_showEndButton)
              ElevatedButton(
                onPressed: _nextPlayer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: buttonTextColor,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Weiter',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            if (_showEndButton)
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameEndScreen(
                          imposters: widget.gameSettings.imposters,
                          word: widget.gameSettings.currentWord ?? '',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: buttonTextColor,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Spiel beenden',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 