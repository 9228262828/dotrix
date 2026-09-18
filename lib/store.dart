import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

class DotrixStore extends ChangeNotifier {
  static const _classicKey = 'dotrix_best_classic_v1';
  static const _rushKey = 'dotrix_best_rush_v1';
  static const _endlessKey = 'dotrix_best_endless_v1';
  static const _gamesKey = 'dotrix_games_played_v1';
  static const _hitsKey = 'dotrix_total_hits_v1';
  static const _comboKey = 'dotrix_best_combo_v1';
  static const _darkKey = 'dotrix_dark_mode_v1';
  static const _hapticKey = 'dotrix_haptic_v1';

  bool ready = false;
  bool darkMode = false;
  bool hapticsEnabled = true;

  int bestClassic = 0;
  int bestTimeRush = 0;
  int bestEndless = 0;
  int gamesPlayed = 0;
  int totalHits = 0;
  int bestCombo = 0;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    bestClassic = prefs.getInt(_classicKey) ?? 0;
    bestTimeRush = prefs.getInt(_rushKey) ?? 0;
    bestEndless = prefs.getInt(_endlessKey) ?? 0;
    gamesPlayed = prefs.getInt(_gamesKey) ?? 0;
    totalHits = prefs.getInt(_hitsKey) ?? 0;
    bestCombo = prefs.getInt(_comboKey) ?? 0;
    darkMode = prefs.getBool(_darkKey) ?? false;
    hapticsEnabled = prefs.getBool(_hapticKey) ?? true;

    ready = true;
    notifyListeners();
  }

  int bestFor(GameMode mode) {
    switch (mode) {
      case GameMode.classic:
        return bestClassic;
      case GameMode.timeRush:
        return bestTimeRush;
      case GameMode.endless:
        return bestEndless;
    }
  }

  Future<void> registerGame({
    required GameMode mode,
    required int score,
    required int hits,
    required int runBestCombo,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    gamesPlayed += 1;
    totalHits += hits;

    if (runBestCombo > bestCombo) {
      bestCombo = runBestCombo;
    }

    switch (mode) {
      case GameMode.classic:
        if (score > bestClassic) bestClassic = score;
        break;
      case GameMode.timeRush:
        if (score > bestTimeRush) bestTimeRush = score;
        break;
      case GameMode.endless:
        if (score > bestEndless) bestEndless = score;
        break;
    }

    await prefs.setInt(_classicKey, bestClassic);
    await prefs.setInt(_rushKey, bestTimeRush);
    await prefs.setInt(_endlessKey, bestEndless);
    await prefs.setInt(_gamesKey, gamesPlayed);
    await prefs.setInt(_hitsKey, totalHits);
    await prefs.setInt(_comboKey, bestCombo);

    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    darkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkKey, value);
    notifyListeners();
  }

  Future<void> setHaptics(bool value) async {
    hapticsEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hapticKey, value);
    notifyListeners();
  }

  Future<void> resetProgress() async {
    bestClassic = 0;
    bestTimeRush = 0;
    bestEndless = 0;
    gamesPlayed = 0;
    totalHits = 0;
    bestCombo = 0;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_classicKey);
    await prefs.remove(_rushKey);
    await prefs.remove(_endlessKey);
    await prefs.remove(_gamesKey);
    await prefs.remove(_hitsKey);
    await prefs.remove(_comboKey);

    notifyListeners();
  }
}
