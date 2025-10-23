import 'package:flutter/material.dart';
import '../models/organism.dart';
import '../services/simulation_engine.dart';

class GridView extends StatelessWidget {
  final SimulationEngine engine;

  const GridView({Key? key, required this.engine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          color: Colors.black,
        ),
        child: CustomPaint(
          painter: GridPainter(
            grid: engine.grid,
            gridWidth: SimulationEngine.gridWidth,
            gridHeight: SimulationEngine.gridHeight,
          ),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final List<List<Organism?>> grid;
  final int gridWidth;
  final int gridHeight;

  GridPainter({
    required this.grid,
    required this.gridWidth,
    required this.gridHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / gridWidth;
    final cellHeight = size.height / gridHeight;

    for (int y = 0; y < gridHeight; y++) {
      for (int x = 0; x < gridWidth; x++) {
        final organism = grid[y][x];
        if (organism != null) {
          final rect = Rect.fromLTWH(
            x * cellWidth,
            y * cellHeight,
            cellWidth,
            cellHeight,
          );

          // Color based on fitness (red = low, yellow = medium, green = high)
          final color = _getFitnessColor(organism.fitness);

          canvas.drawRect(rect, Paint()..color = color);
        }
      }
    }
  }

  Color _getFitnessColor(double fitness) {
    // Normalize fitness to 0-1 range (assuming fitness is typically 0.1 to 3.0)
    final normalized = ((fitness - 0.1) / 2.9).clamp(0.0, 1.0);

    if (normalized < 0.5) {
      // Red to Yellow
      return Color.lerp(Colors.red, Colors.yellow, normalized * 2)!;
    } else {
      // Yellow to Green
      return Color.lerp(Colors.yellow, Colors.green, (normalized - 0.5) * 2)!;
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) => true;
}
