DOTRIX — Tap Reflex
Tagline: See it. Tap it. Beat it.
Package: com.dotrix.reflex

Add this dependency to pubspec.yaml:

dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.3.2

Included:
- Splash Screen
- Home Screen
- Classic Mode
- Time Rush Mode
- Endless Mode
- 4x4 tap grid
- Dynamic target timing
- Score
- Combo
- Best scores per mode
- Classic lives
- 60-second Time Rush timer
- Endless one-miss game over
- Pause / Resume
- Game Over Screen
- Play Again
- Statistics
- Dark Mode
- Haptic feedback toggle
- Privacy Policy
- Terms & Conditions
- Reset progress
- Offline persistence with SharedPreferences

Gameplay:
- Classic: 3 lives. Wrong tap or timeout costs one life.
- Time Rush: 60 seconds. Wrong tap or timeout simply moves the target.
- Endless: first wrong tap or timeout ends the run.
- Target duration starts at 1400ms and gradually decreases to a safe minimum of 680ms.

No Firebase
No backend
No login
No ads
No analytics
No Flame engine
No physics engine
No image assets required
No audio assets required

The game logic uses one periodic Timer and cancels it in dispose().
The Game Over route is guarded to prevent duplicate navigation.
