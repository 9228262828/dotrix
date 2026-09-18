import 'package:flutter/material.dart';
import 'store.dart';
import 'ui.dart';
import 'screens.dart';

class DotrixApp extends StatefulWidget {
  const DotrixApp({super.key});

  @override
  State<DotrixApp> createState() => _DotrixAppState();
}

class _DotrixAppState extends State<DotrixApp> {
  final DotrixStore store = DotrixStore();

  @override
  void initState() {
    super.initState();
    store.load();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'DOTRIX',
          themeMode: store.darkMode ? ThemeMode.dark : ThemeMode.light,
          theme: dotrixTheme(Brightness.light),
          darkTheme: dotrixTheme(Brightness.dark),
          home: SplashScreen(store: store),
        );
      },
    );
  }
}
