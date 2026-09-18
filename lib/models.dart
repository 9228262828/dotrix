enum GameMode {
  classic,
  timeRush,
  endless,
}

String gameModeLabel(GameMode mode) {
  switch (mode) {
    case GameMode.classic:
      return 'Classic';
    case GameMode.timeRush:
      return 'Time Rush';
    case GameMode.endless:
      return 'Endless';
  }
}

String gameModeSubtitle(GameMode mode) {
  switch (mode) {
    case GameMode.classic:
      return '3 lives. Misses cost a life.';
    case GameMode.timeRush:
      return '60 seconds. Score as much as you can.';
    case GameMode.endless:
      return 'One miss ends the run.';
  }
}
