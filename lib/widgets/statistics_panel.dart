import 'package:flutter/material.dart';
import '../models/statistics.dart';

class StatisticsPanel extends StatelessWidget {
  final Statistics stats;

  const StatisticsPanel({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.grey.shade900,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatRow('Updates', stats.updates.toString()),
            _buildStatRow('Population', stats.population.toString()),
            _buildStatRow('Total Births', stats.totalBirths.toString()),
            _buildStatRow('Total Deaths', stats.totalDeaths.toString()),
            const Divider(color: Colors.white24),
            _buildStatRow('Avg Age', stats.averageAge.toStringAsFixed(1)),
            _buildStatRow('Avg Fitness', stats.averageFitness.toStringAsFixed(1)),
            _buildStatRow('Avg Generation', stats.averageGeneration.toStringAsFixed(1)),
            _buildStatRow('Avg Genome Len', stats.averageGenomeLength.toStringAsFixed(1)),
            const Divider(color: Colors.white24),
            const Text(
              'Tasks Completed:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            ...stats.taskCounts.entries.map((e) => _buildTaskRow(e.key, e.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskRow(String task, int count) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              task,
              style: const TextStyle(color: Colors.white60, fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            count.toString(),
            style: const TextStyle(
              color: Colors.greenAccent,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
