import 'package:flutter/material.dart';
import '../models/world.dart';

class WorldGridPainter extends CustomPainter {
  final World world;
  final String colorMode; // 'fitness', 'age', 'generation', 'tasks'

  WorldGridPainter(this.world, this.colorMode);

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / world.width;
    final cellHeight = size.height / world.height;

    for (int y = 0; y < world.height; y++) {
      for (int x = 0; x < world.width; x++) {
        final organism = world.getOrganism(x, y);
        final rect = Rect.fromLTWH(
          x * cellWidth,
          y * cellHeight,
          cellWidth,
          cellHeight,
        );

        Color color;
        if (organism == null) {
          color = Colors.black;
        } else {
          color = _getOrganismColor(organism);
        }

        final paint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;

        canvas.drawRect(rect, paint);
      }
    }
  }

  Color _getOrganismColor(organism) {
    switch (colorMode) {
      case 'fitness':
        // Color by merit/fitness
        final normalized = (organism.merit / 500.0).clamp(0.0, 1.0) as double;
        return HSVColor.fromAHSV(1.0, 120.0 * normalized, 1.0, 0.9).toColor();

      case 'age':
        // Color by age
        final normalized = (organism.age / 500.0).clamp(0.0, 1.0) as double;
        return HSVColor.fromAHSV(1.0, 240.0 * (1.0 - normalized), 1.0, 0.9).toColor();

      case 'generation':
        // Color by generation
        final normalized = (organism.generation / 50.0).clamp(0.0, 1.0) as double;
        return HSVColor.fromAHSV(1.0, 300.0 * normalized, 1.0, 0.9).toColor();

      case 'tasks':
        // Color by number of tasks completed
        final taskCount = organism.completedTasks.length;
        if (taskCount == 0) {
          return Colors.grey.shade700;
        } else {
          final normalized = (taskCount / 7.0).clamp(0.0, 1.0) as double;
          return HSVColor.fromAHSV(1.0, 60.0 + 180.0 * normalized, 1.0, 0.9).toColor();
        }

      case 'lineage':
      default:
        // Color by lineage (hue)
        return HSVColor.fromAHSV(1.0, organism.hue, 0.8, 0.9).toColor();
    }
  }

  @override
  bool shouldRepaint(WorldGridPainter oldDelegate) => true;
}

class WorldGridWidget extends StatelessWidget {
  final World world;
  final String colorMode;
  final Function(int, int)? onCellTap;

  const WorldGridWidget({
    super.key,
    required this.world,
    required this.colorMode,
    this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        if (onCellTap != null) {
          final RenderBox box = context.findRenderObject() as RenderBox;
          final localPosition = box.globalToLocal(details.globalPosition);
          final cellWidth = box.size.width / world.width;
          final cellHeight = box.size.height / world.height;
          final x = (localPosition.dx / cellWidth).floor();
          final y = (localPosition.dy / cellHeight).floor();
          onCellTap!(x, y);
        }
      },
      child: CustomPaint(
        painter: WorldGridPainter(world, colorMode),
        child: Container(),
      ),
    );
  }
}
