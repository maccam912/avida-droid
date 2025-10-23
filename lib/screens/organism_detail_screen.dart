import 'package:flutter/material.dart';
import '../models/organism.dart';
import '../models/cpu.dart';

class OrganismDetailScreen extends StatelessWidget {
  final Organism organism;

  const OrganismDetailScreen({super.key, required this.organism});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organism Details'),
        backgroundColor: Colors.grey.shade900,
      ),
      backgroundColor: Colors.grey.shade800,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('Basic Information', [
              _buildInfoRow('Age', organism.age.toString()),
              _buildInfoRow('Generation', organism.generation.toString()),
              _buildInfoRow('Merit', organism.merit.toString()),
              _buildInfoRow('Fitness', organism.fitness.toString()),
              _buildInfoRow('Children', organism.childCount.toString()),
              _buildInfoRow('Genome Length', organism.genomeLength.toString()),
            ]),
            const SizedBox(height: 16),
            _buildSection('CPU State', [
              _buildInfoRow('IP', organism.cpu.heads[Head.ip].toString()),
              _buildInfoRow('Read Head', organism.cpu.heads[Head.read].toString()),
              _buildInfoRow('Write Head', organism.cpu.heads[Head.write].toString()),
              _buildInfoRow('Flow Head', organism.cpu.heads[Head.flow].toString()),
              const Divider(color: Colors.white24),
              _buildInfoRow('AX Register', organism.cpu.registers[Register.ax].toString()),
              _buildInfoRow('BX Register', organism.cpu.registers[Register.bx].toString()),
              _buildInfoRow('CX Register', organism.cpu.registers[Register.cx].toString()),
              const Divider(color: Colors.white24),
              _buildInfoRow('Stack Size', organism.cpu.stack.length.toString()),
              _buildInfoRow('Output Buffer', organism.cpu.outputBuffer.length.toString()),
            ]),
            const SizedBox(height: 16),
            _buildSection('Tasks Completed', [
              if (organism.completedTasks.isEmpty)
                const Text(
                  'No tasks completed yet',
                  style: TextStyle(color: Colors.white60, fontStyle: FontStyle.italic),
                )
              else
                ...organism.completedTasks.map((task) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.greenAccent, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            task,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    )),
            ]),
            const SizedBox(height: 16),
            _buildSection('Genome', [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SelectableText(
                  _formatGenome(organism.genomeString),
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatGenome(String genome) {
    // Format genome in lines of 50 characters
    final buffer = StringBuffer();
    for (int i = 0; i < genome.length; i += 50) {
      final end = (i + 50 < genome.length) ? i + 50 : genome.length;
      buffer.writeln(genome.substring(i, end));
    }
    return buffer.toString();
  }
}
