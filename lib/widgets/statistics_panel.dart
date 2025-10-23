import 'package:flutter/material.dart';
import '../services/simulation_engine.dart';

class StatisticsPanel extends StatelessWidget {
  final SimulationEngine engine;

  const StatisticsPanel({Key? key, required this.engine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildStatRow('Generation', engine.generation.toString()),
            _buildStatRow('Population', engine.totalOrganisms.toString()),
            _buildStatRow(
              'Avg Fitness',
              engine.averageFitness.toStringAsFixed(2),
            ),
            _buildStatRow('Total Mutations', engine.totalMutations.toString()),
            _buildStatRow(
              'Max Population',
              '${SimulationEngine.gridWidth * SimulationEngine.gridHeight}',
            ),
            const SizedBox(height: 8),
            _buildStatRow(
              'Grid Size',
              '${SimulationEngine.gridWidth}×${SimulationEngine.gridHeight}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
