import 'package:flutter/material.dart';

import '../features/workout/spike_screen.dart';

class FightcraftApp extends StatelessWidget {
  const FightcraftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fightcraft',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.red,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      // Phase 4 replaces this with the Home screen and routing.
      home: const SpikeScreen(),
    );
  }
}
