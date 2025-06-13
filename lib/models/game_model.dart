class GameModel {
  int score = 0;
  bool isGameRunning = false;
  int level = 1;
  
  void startGame() {
    isGameRunning = true;
    score = 0;
    level = 1;
  }
  
  void stopGame() {
    isGameRunning = false;
  }
  
  void incrementScore() {
    if (isGameRunning) {
      score++;
      // Level erhöhen alle 10 Punkte
      if (score % 10 == 0) {
        level++;
      }
    }
  }
  
  void resetGame() {
    score = 0;
    level = 1;
    isGameRunning = false;
  }
} 