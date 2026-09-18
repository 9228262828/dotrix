import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'models.dart';
import 'store.dart';

class DotrixGameController extends ChangeNotifier {
  static const int gridCount = 16;
  static const int tickMs = 50;

  final DotrixStore store;
  final GameMode mode;
  final Random _random = Random();

  Timer? _timer;
  bool _registered = false;

  int score = 0;
  int combo = 0;
  int runBestCombo = 0;
  int hits = 0;
  int lives = 3;

  int targetIndex = 0;
  int targetRemainingMs = 1400;
  int targetDurationMs = 1400;

  int totalRemainingMs = 60000;

  bool paused = false;
  bool gameOver = false;

  DotrixGameController({
    required this.store,
    required this.mode,
  });

  void start() {
    _timer?.cancel();

    score = 0;
    combo = 0;
    runBestCombo = 0;
    hits = 0;
    lives = 3;
    totalRemainingMs = 60000;
    paused = false;
    gameOver = false;
    _registered = false;

    _spawnTarget();

    _timer = Timer.periodic(
      const Duration(milliseconds: tickMs),
      (_) => _tick(),
    );

    notifyListeners();
  }

  double get targetProgress {
    if (targetDurationMs <= 0) return 0;
    return (targetRemainingMs / targetDurationMs).clamp(0.0, 1.0).toDouble();
  }

  double get rushProgress {
    if (mode != GameMode.timeRush) return 1;
    return (totalRemainingMs / 60000).clamp(0.0, 1.0).toDouble();
  }

  int get secondsLeft => (totalRemainingMs / 1000).ceil().clamp(0, 60).toInt();

  void togglePause() {
    if (gameOver) return;
    paused = !paused;
    notifyListeners();
  }

  void tapCell(int index) {
    if (paused || gameOver) return;

    if (index == targetIndex) {
      score += 1;
      combo += 1;
      hits += 1;

      if (combo > runBestCombo) {
        runBestCombo = combo;
      }

      _spawnTarget();
      notifyListeners();
      return;
    }

    _miss();
  }

  void _tick() {
    if (paused || gameOver) return;

    if (mode == GameMode.timeRush) {
      totalRemainingMs -= tickMs;

      if (totalRemainingMs <= 0) {
        totalRemainingMs = 0;
        _finish();
        return;
      }
    }

    targetRemainingMs -= tickMs;

    if (targetRemainingMs <= 0) {
      _miss();
      return;
    }

    notifyListeners();
  }

  void _miss() {
    if (gameOver) return;

    combo = 0;

    switch (mode) {
      case GameMode.classic:
        lives -= 1;
        if (lives <= 0) {
          lives = 0;
          _finish();
          return;
        }
        _spawnTarget();
        break;

      case GameMode.timeRush:
        _spawnTarget();
        break;

      case GameMode.endless:
        _finish();
        return;
    }

    notifyListeners();
  }

  void _spawnTarget() {
    final previous = targetIndex;

    if (gridCount <= 1) {
      targetIndex = 0;
    } else {
      int next = previous;
      while (next == previous) {
        next = _random.nextInt(gridCount);
      }
      targetIndex = next;
    }

    targetDurationMs = _durationForScore(score);
    targetRemainingMs = targetDurationMs;
  }

  int _durationForScore(int value) {
    final reduction = (value * 28).clamp(0, 720).toInt();
    return 1400 - reduction;
  }

  Future<void> _finish() async {
    if (gameOver) return;

    gameOver = true;
    paused = false;
    _timer?.cancel();

    if (!_registered) {
      _registered = true;
      await store.registerGame(
        mode: mode,
        score: score,
        hits: hits,
        runBestCombo: runBestCombo,
      );
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
