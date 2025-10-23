import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/simulation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Force landscape orientation for better viewing
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const AvidaDroidApp());
}

class AvidaDroidApp extends StatelessWidget {
  const AvidaDroidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avida-Droid',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const SimulationScreen(),
    );
  }
}
