import 'category_manager.dart';

class GameSettings {
  List<String> players;
  List<String> selectedCategories;
  int numberOfImposters;
  bool showImposterHints;
  String? currentWord;
  String? currentHint;
  List<String> imposters;
  final CategoryManager _categoryManager = CategoryManager();

  GameSettings({
    List<String>? players,
    List<String>? selectedCategories,
    int? numberOfImposters,
    this.showImposterHints = false,
    this.currentWord,
    this.currentHint,
    List<String>? imposters,
  }) : 
    players = players ?? [],
    selectedCategories = selectedCategories ?? [],
    numberOfImposters = numberOfImposters ?? 1,
    imposters = imposters ?? [];

  GameSettings copyWith({
    List<String>? players,
    List<String>? selectedCategories,
    int? numberOfImposters,
    bool? showImposterHints,
    String? currentWord,
    String? currentHint,
    List<String>? imposters,
  }) {
    return GameSettings(
      players: players ?? this.players,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      numberOfImposters: numberOfImposters ?? this.numberOfImposters,
      showImposterHints: showImposterHints ?? this.showImposterHints,
      currentWord: currentWord ?? this.currentWord,
      currentHint: currentHint ?? this.currentHint,
      imposters: imposters ?? this.imposters,
    );
  }

  // Kategorien aus dem CategoryManager
  List<String> get categories => _categoryManager.getAvailableCategories();

  void addPlayer(String name) {
    if (!players.contains(name)) {
      players.add(name);
    }
  }

  void removePlayer(String name) {
    players.remove(name);
    // Stelle sicher, dass die Anzahl der Imposter nicht größer ist als die Anzahl der Spieler
    if (numberOfImposters > players.length - 1) {
      numberOfImposters = players.length > 1 ? players.length - 1 : 1;
    }
  }

  void reset() {
    players.clear();
    numberOfImposters = 1;
    selectedCategories.clear();
    currentWord = null;
    currentHint = null;
    imposters.clear();
  }

  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
  }

  Map<String, String> getRandomWordWithHint() {
    return _categoryManager.getRandomWordWithHint(selectedCategories);
  }

  List<String> getAvailableCategories() {
    return _categoryManager.getAvailableCategories();
  }
} 