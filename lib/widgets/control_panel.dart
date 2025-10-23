import 'package:flutter/material.dart';
import '../services/simulation_engine.dart';

class ControlPanel extends StatelessWidget {
  final SimulationEngine engine;

  const ControlPanel({Key? key, required this.engine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Controls',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: engine.isRunning ? null : engine.start,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: engine.isRunning ? engine.pause : null,
                  icon: const Icon(Icons.pause),
                  label: const Text('Pause'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: engine.reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Speed: ${engine.ticksPerSecond} ticks/sec',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Slider(
              value: engine.ticksPerSecond.toDouble(),
              min: 1,
              max: 60,
              divisions: 59,
              label: '${engine.ticksPerSecond} ticks/sec',
              onChanged: (value) {
                engine.setSpeed(value.round());
              },
            ),
          ],
        ),
      ),
    );
  }
}
