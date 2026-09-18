import 'package:flutter/material.dart';
import 'models.dart';

const dotrixNavy = Color(0xFF08111F);
const dotrixBlue = Color(0xFF2563EB);
const dotrixCyan = Color(0xFF22D3EE);
const dotrixPurple = Color(0xFF7C3AED);
const dotrixPink = Color(0xFFEC4899);
const dotrixGreen = Color(0xFF10B981);
const dotrixAmber = Color(0xFFF59E0B);
const dotrixRed = Color(0xFFEF4444);

ThemeData dotrixTheme(Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: ColorScheme.fromSeed(
      seedColor: dotrixPurple,
      brightness: brightness,
    ),
    scaffoldBackgroundColor: brightness == Brightness.dark
        ? const Color(0xFF060A12)
        : const Color(0xFFF4F7FB),
    appBarTheme: const AppBarTheme(centerTitle: false),
    cardTheme: CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
  );
}

Color modeColor(GameMode mode) {
  switch (mode) {
    case GameMode.classic:
      return dotrixPurple;
    case GameMode.timeRush:
      return dotrixCyan;
    case GameMode.endless:
      return dotrixPink;
  }
}

IconData modeIcon(GameMode mode) {
  switch (mode) {
    case GameMode.classic:
      return Icons.favorite_rounded;
    case GameMode.timeRush:
      return Icons.timer_rounded;
    case GameMode.endless:
      return Icons.all_inclusive_rounded;
  }
}

class DotrixLogo extends StatelessWidget {
  final double size;

  const DotrixLogo({
    super.key,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * .28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [dotrixPurple, dotrixBlue, dotrixCyan],
        ),
        boxShadow: [
          BoxShadow(
            color: dotrixPurple.withOpacity(.25),
            blurRadius: size * .36,
            offset: Offset(0, size * .14),
          ),
        ],
      ),
      child: Icon(
        Icons.adjust_rounded,
        color: Colors.white,
        size: size * .52,
      ),
    );
  }
}

class StatTile extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final IconData icon;

  const StatTile({
    super.key,
    required this.value,
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        border: Border.all(color: color.withOpacity(.18)),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: .8,
            ),
          ),
        ],
      ),
    );
  }
}
