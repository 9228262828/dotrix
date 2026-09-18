import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game_controller.dart';
import 'models.dart';
import 'store.dart';
import 'ui.dart';

class SplashScreen extends StatefulWidget {
  final DotrixStore store;

  const SplashScreen({
    super.key,
    required this.store,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _open();
  }

  Future<void> _open() async {
    while (!widget.store.ready) {
      await Future.delayed(const Duration(milliseconds: 40));
    }

    await Future.delayed(const Duration(milliseconds: 650));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(store: widget.store),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DotrixLogo(size: 98),
            SizedBox(height: 22),
            Text(
              'DOTRIX',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                letterSpacing: 5,
              ),
            ),
            SizedBox(height: 7),
            Text(
              'SEE IT • TAP IT • BEAT IT',
              style: TextStyle(
                color: dotrixPurple,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final DotrixStore store;

  const HomeScreen({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 34),
              children: [
                Row(
                  children: [
                    const DotrixLogo(size: 58),
                    const SizedBox(width: 13),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DOTRIX',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3,
                            ),
                          ),
                          Text(
                            'TAP REFLEX',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Statistics',
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StatsScreen(store: store),
                        ),
                      ),
                      icon: const Icon(Icons.bar_chart_rounded),
                    ),
                    IconButton(
                      tooltip: 'Settings',
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SettingsScreen(store: store),
                        ),
                      ),
                      icon: const Icon(Icons.settings_outlined),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  'Choose your run',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Hit the glowing dot before it disappears.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                ...GameMode.values.map(
                  (mode) => Padding(
                    padding: const EdgeInsets.only(bottom: 13),
                    child: _ModeCard(
                      mode: mode,
                      best: store.bestFor(mode),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GameScreen(
                            store: store,
                            mode: mode,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        dotrixNavy,
                        dotrixPurple.withOpacity(.92),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.bolt_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          store.gamesPlayed == 0
                              ? 'Your reflex history starts with the first run.'
                              : '${store.gamesPlayed} games • ${store.totalHits} successful taps • Best combo ${store.bestCombo}',
                          style: const TextStyle(
                            color: Colors.white,
                            height: 1.45,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ModeCard extends StatelessWidget {
  final GameMode mode;
  final int best;
  final VoidCallback onTap;

  const _ModeCard({
    required this.mode,
    required this.best,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = modeColor(mode);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(19),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: color.withOpacity(.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  modeIcon(mode),
                  color: color,
                  size: 30,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gameModeLabel(mode),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      gameModeSubtitle(mode),
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'BEST  $best',
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.play_arrow_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  final DotrixStore store;
  final GameMode mode;

  const GameScreen({
    super.key,
    required this.store,
    required this.mode,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final DotrixGameController controller;
  bool navigatedToGameOver = false;

  @override
  void initState() {
    super.initState();

    controller = DotrixGameController(
      store: widget.store,
      mode: widget.mode,
    );

    controller.addListener(_watchGame);
    controller.start();
  }

  void _watchGame() {
    if (!mounted || !controller.gameOver || navigatedToGameOver) return;

    navigatedToGameOver = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => GameOverScreen(
            store: widget.store,
            mode: widget.mode,
            score: controller.score,
            bestCombo: controller.runBestCombo,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    controller.removeListener(_watchGame);
    controller.dispose();
    super.dispose();
  }

  void _tapCell(int index) {
    if (controller.paused || controller.gameOver) return;

    final correct = index == controller.targetIndex;

    if (widget.store.hapticsEnabled) {
      if (correct) {
        HapticFeedback.selectionClick();
      } else {
        HapticFeedback.mediumImpact();
      }
    }

    controller.tapCell(index);
  }

  @override
  Widget build(BuildContext context) {
    final modeColorValue = modeColor(widget.mode);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(gameModeLabel(widget.mode).toUpperCase()),
            actions: [
              IconButton(
                tooltip: controller.paused ? 'Resume' : 'Pause',
                onPressed: controller.togglePause,
                icon: Icon(
                  controller.paused
                      ? Icons.play_arrow_rounded
                      : Icons.pause_rounded,
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              SafeArea(
                top: false,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
                  children: [
                    _gameHeader(modeColorValue),
                    const SizedBox(height: 18),
                    LinearProgressIndicator(
                      minHeight: 9,
                      borderRadius: BorderRadius.circular(99),
                      value: controller.targetProgress,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'TARGET TIME',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    if (widget.mode == GameMode.timeRush) ...[
                      const SizedBox(height: 15),
                      LinearProgressIndicator(
                        minHeight: 7,
                        borderRadius: BorderRadius.circular(99),
                        value: controller.rushProgress,
                        color: dotrixCyan,
                      ),
                    ],
                    const SizedBox(height: 20),
                    _grid(),
                    const SizedBox(height: 20),
                    Text(
                      'Tap only the glowing dot.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.paused) _pauseOverlay(),
            ],
          ),
        );
      },
    );
  }

  Widget _gameHeader(Color color) {
    final thirdLabel = widget.mode == GameMode.classic
        ? 'LIVES'
        : widget.mode == GameMode.timeRush
            ? 'TIME'
            : 'BEST';

    final thirdValue = widget.mode == GameMode.classic
        ? '${controller.lives}'
        : widget.mode == GameMode.timeRush
            ? '${controller.secondsLeft}s'
            : '${widget.store.bestFor(widget.mode)}';

    return Row(
      children: [
        Expanded(
          child: StatTile(
            value: '${controller.score}',
            label: 'SCORE',
            icon: Icons.bolt_rounded,
            color: color,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: StatTile(
            value: '${controller.combo}',
            label: 'COMBO',
            icon: Icons.local_fire_department_rounded,
            color: dotrixAmber,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: StatTile(
            value: thirdValue,
            label: thirdLabel,
            icon: widget.mode == GameMode.classic
                ? Icons.favorite_rounded
                : widget.mode == GameMode.timeRush
                    ? Icons.timer_rounded
                    : Icons.emoji_events_outlined,
            color: widget.mode == GameMode.classic
                ? dotrixRed
                : widget.mode == GameMode.timeRush
                    ? dotrixCyan
                    : dotrixGreen,
          ),
        ),
      ],
    );
  }

  Widget _grid() {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: DotrixGameController.gridCount,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final active = index == controller.targetIndex;
          final color = modeColor(widget.mode);

          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _tapCell(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 110),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: active
                      ? color.withOpacity(.14)
                      : Theme.of(context).colorScheme.surface,
                  border: Border.all(
                    color: active
                        ? color.withOpacity(.65)
                        : Theme.of(context)
                            .colorScheme
                            .outline
                            .withOpacity(.12),
                    width: active ? 2 : 1,
                  ),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: color.withOpacity(.28),
                            blurRadius: 20,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 110),
                    scale: active ? 1 : .72,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: active
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  color,
                                  dotrixCyan,
                                ],
                              )
                            : null,
                        color: active
                            ? null
                            : Theme.of(context)
                                .colorScheme
                                .outline
                                .withOpacity(.10),
                      ),
                      child: active
                          ? const Icon(
                              Icons.touch_app_rounded,
                              color: Colors.white,
                              size: 20,
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _pauseOverlay() {
    return Positioned.fill(
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface.withOpacity(.94),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.pause_circle_filled_rounded,
                  size: 72,
                  color: dotrixPurple,
                ),
                const SizedBox(height: 16),
                const Text(
                  'PAUSED',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: 220,
                  child: FilledButton.icon(
                    onPressed: controller.togglePause,
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('RESUME'),
                  ),
                ),
                const SizedBox(height: 9),
                SizedBox(
                  width: 220,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.home_outlined),
                    label: const Text('BACK HOME'),
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

class GameOverScreen extends StatelessWidget {
  final DotrixStore store;
  final GameMode mode;
  final int score;
  final int bestCombo;

  const GameOverScreen({
    super.key,
    required this.store,
    required this.mode,
    required this.score,
    required this.bestCombo,
  });

  @override
  Widget build(BuildContext context) {
    final color = modeColor(mode);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 42, 22, 30),
          children: [
            Center(
              child: Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(.12),
                ),
                child: Icon(
                  Icons.emoji_events_rounded,
                  color: color,
                  size: 48,
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'RUN COMPLETE',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 29,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              gameModeLabel(mode),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: StatTile(
                    value: '$score',
                    label: 'SCORE',
                    icon: Icons.bolt_rounded,
                    color: color,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatTile(
                    value: '$bestCombo',
                    label: 'RUN COMBO',
                    icon: Icons.local_fire_department_rounded,
                    color: dotrixAmber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            StatTile(
              value: '${store.bestFor(mode)}',
              label: 'BEST SCORE',
              icon: Icons.workspace_premium_rounded,
              color: dotrixGreen,
            ),
            const SizedBox(height: 26),
            FilledButton.icon(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => GameScreen(
                    store: store,
                    mode: mode,
                  ),
                ),
              ),
              icon: const Icon(Icons.replay_rounded),
              label: const Padding(
                padding: EdgeInsets.all(14),
                child: Text('PLAY AGAIN'),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.home_outlined),
              label: const Padding(
                padding: EdgeInsets.all(14),
                child: Text('BACK HOME'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatsScreen extends StatelessWidget {
  final DotrixStore store;

  const StatsScreen({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('STATISTICS')),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Reflex record',
                style: TextStyle(
                  fontSize: 29,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Your best runs and overall tap history.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: StatTile(
                      value: '${store.gamesPlayed}',
                      label: 'GAMES',
                      icon: Icons.sports_esports_rounded,
                      color: dotrixPurple,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatTile(
                      value: '${store.totalHits}',
                      label: 'HITS',
                      icon: Icons.touch_app_rounded,
                      color: dotrixCyan,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              StatTile(
                value: '${store.bestCombo}',
                label: 'BEST COMBO',
                icon: Icons.local_fire_department_rounded,
                color: dotrixAmber,
              ),
              const SizedBox(height: 24),
              ...GameMode.values.map(
                (mode) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: modeColor(mode).withOpacity(.12),
                        child: Icon(
                          modeIcon(mode),
                          color: modeColor(mode),
                        ),
                      ),
                      title: Text(
                        gameModeLabel(mode),
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      subtitle: Text(gameModeSubtitle(mode)),
                      trailing: Text(
                        '${store.bestFor(mode)}',
                        style: TextStyle(
                          color: modeColor(mode),
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SettingsScreen extends StatelessWidget {
  final DotrixStore store;

  const SettingsScreen({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('SETTINGS')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      value: store.darkMode,
                      onChanged: store.setDarkMode,
                      secondary: const Icon(Icons.dark_mode_outlined),
                      title: const Text('Dark mode'),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      value: store.hapticsEnabled,
                      onChanged: store.setHaptics,
                      secondary: const Icon(Icons.vibration_rounded),
                      title: const Text('Haptic feedback'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.privacy_tip_outlined),
                      title: const Text('Privacy Policy'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LegalScreen(
                            title: 'Privacy Policy',
                            body: privacyText,
                          ),
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.description_outlined),
                      title: const Text('Terms & Conditions'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LegalScreen(
                            title: 'Terms & Conditions',
                            body: termsText,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  textColor: dotrixRed,
                  iconColor: dotrixRed,
                  leading: const Icon(Icons.delete_sweep_outlined),
                  title: const Text('Reset progress'),
                  subtitle: const Text(
                    'Delete scores, statistics, and game history.',
                  ),
                  onTap: () => _reset(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _reset(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset all progress?'),
        content: const Text(
          'Best scores and statistics will be deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('CANCEL'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('RESET'),
          ),
        ],
      ),
    );

    if (ok == true) {
      await store.resetProgress();
    }
  }
}

const privacyText = '''DOTRIX PRIVACY POLICY

DOTRIX is an offline-first reflex game. The current core version does not require an account, login, Firebase, backend services, advertising, cloud sync, or behavioral analytics.

The game stores limited gameplay information locally on your device, including best scores for each game mode, games played, successful taps, best combo, dark-mode preference, and haptic-feedback preference.

This information is used only to provide local game progress, statistics, preferences, and best-score features.

The current core version does not require access to your location, camera, microphone, contacts, phone, SMS, calendar, photos, files, or payment information.

DOTRIX does not intentionally sell or rent your locally stored gameplay information and does not use your gameplay data for personalized advertising.

You can reset gameplay progress from the Settings screen. Clearing application storage or uninstalling the app may also remove locally stored information, subject to operating-system backup and restore behavior.

If future versions add accounts, cloud sync, analytics, crash reporting, advertising, online multiplayer, payments, or additional permissions, this policy should be reviewed and updated before release.

For privacy questions, contact the app publisher through the support email shown on the store listing.''';

const termsText = '''DOTRIX TERMS & CONDITIONS

DOTRIX is a casual reflex game intended for entertainment.

Scores, combos, timers, difficulty changes, and statistics are calculated from gameplay and are provided for entertainment and personal progress tracking.

The current core version stores progress locally. We do not guarantee recovery of scores or settings after uninstalling the app, clearing app data, device loss, storage failure, or operating-system changes.

DOTRIX is provided on an "as available" basis to the extent permitted by applicable law. Features may be improved, changed, added, or removed in future versions.

You are responsible for using the game in a safe and appropriate environment. Do not use the game when doing so could distract you from driving, operating machinery, walking in unsafe surroundings, or performing another activity that requires attention.

Use of DOTRIX is also subject to applicable laws and the terms of the app-distribution platform through which you obtained it.''';

class LegalScreen extends StatelessWidget {
  final String title;
  final String body;

  const LegalScreen({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SelectableText(
            body,
            style: const TextStyle(height: 1.7),
          ),
        ],
      ),
    );
  }
}
