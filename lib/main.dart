import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/simulation_engine.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const AvidaDroidApp());
}

class AvidaDroidApp extends StatelessWidget {
  const AvidaDroidApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SimulationEngine(),
      child: MaterialApp(
        title: 'Avida-Droid',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
