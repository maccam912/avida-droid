import 'dart:math';
import 'organism.dart';
import 'statistics.dart';

class World {
  final int width;
  final int height;
  late List<List<Organism?>> grid;
  double mutationRate;
  int updates = 0;
  final Statistics stats = Statistics();
  final Random random = Random();

  World({
    this.width = 60,
    this.height = 60,
    this.mutationRate = 0.0075,
  }) {
    grid = List.generate(height, (_) => List.filled(width, null));
    _initialize();
  }

  void _initialize() {
    // Seed with viable ancestor organisms that can self-replicate
    // This matches real Avida which starts with a working replicator
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        grid[y][x] = Organism.createAncestor();
      }
    }
    stats.reset();
  }

  // Get organism at position
  Organism? getOrganism(int x, int y) {
    if (x < 0 || x >= width || y < 0 || y >= height) return null;
    return grid[y][x];
  }

  // Set organism at position
  void setOrganism(int x, int y, Organism? organism) {
    if (x < 0 || x >= width || y < 0 || y >= height) return;
    grid[y][x] = organism;
  }

  // Get all organisms in the world
  List<Organism> get organisms {
    final List<Organism> result = [];
    for (final row in grid) {
      for (final org in row) {
        if (org != null) {
          result.add(org);
        }
      }
    }
    return result;
  }

  // Find empty adjacent cell
  Point<int>? findEmptyAdjacent(int x, int y) {
    final positions = [
      Point(x - 1, y),
      Point(x + 1, y),
      Point(x, y - 1),
      Point(x, y + 1),
      Point(x - 1, y - 1),
      Point(x + 1, y - 1),
      Point(x - 1, y + 1),
      Point(x + 1, y + 1),
    ];

    positions.shuffle(random);

    for (final pos in positions) {
      if (pos.x >= 0 && pos.x < width && pos.y >= 0 && pos.y < height) {
        if (grid[pos.y][pos.x] == null) {
          return pos;
        }
      }
    }

    // If no empty adjacent, pick a random adjacent to replace
    final pos = positions.firstWhere(
      (p) => p.x >= 0 && p.x < width && p.y >= 0 && p.y < height,
      orElse: () => Point(x, y),
    );
    return pos;
  }

  // Single update step
  void update() {
    updates++;
    int aliveCount = 0;
    int births = 0;
    int deaths = 0;

    // Shuffle execution order for fairness
    final positions = <Point<int>>[];
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        if (grid[y][x] != null) {
          positions.add(Point(x, y));
        }
      }
    }
    positions.shuffle(random);

    // Execute each organism
    for (final pos in positions) {
      final organism = grid[pos.y][pos.x];
      if (organism == null) continue;

      aliveCount++;

      // Give organism random inputs for task checking
      if (organism.cpu.inputBuffer.isEmpty) {
        organism.cpu.inputBuffer.add(random.nextInt(0xFFFF));
        organism.cpu.inputBuffer.add(random.nextInt(0xFFFF));
      }

      // Execute based on merit (more merit = more CPU cycles)
      final cpuCycles = max(1, organism.merit ~/ 10);
      final offspring = organism.execute(cpuCycles, mutationRate);

      // Check for death by energy starvation (matches real Avida)
      if (organism.merit <= 0) {
        grid[pos.y][pos.x] = null;
        deaths++;
        aliveCount--;
        continue; // Skip reproduction and age checks for dead organism
      }

      // Handle reproduction
      if (offspring != null) {
        final emptyPos = findEmptyAdjacent(pos.x, pos.y);
        if (emptyPos != null) {
          // Check if replacing an organism
          if (grid[emptyPos.y][emptyPos.x] != null) {
            deaths++;
          }
          grid[emptyPos.y][emptyPos.x] = offspring;
          births++;
        }
      }

      // Death by old age
      if (organism.age > organism.genome.length * 20) {
        grid[pos.y][pos.x] = null;
        deaths++;
        aliveCount--;
      }
    }

    // Update statistics
    stats.update(
      updates: updates,
      population: aliveCount,
      births: births,
      deaths: deaths,
      averageAge: _calculateAverageAge(),
      averageFitness: _calculateAverageFitness(),
      averageGeneration: _calculateAverageGeneration(),
      averageGenomeLength: _calculateAverageGenomeLength(),
      taskCounts: _countTasks(),
    );
  }

  double _calculateAverageAge() {
    int total = 0;
    int count = 0;
    for (final row in grid) {
      for (final org in row) {
        if (org != null) {
          total += org.age;
          count++;
        }
      }
    }
    return count > 0 ? total / count : 0;
  }

  double _calculateAverageFitness() {
    int total = 0;
    int count = 0;
    for (final row in grid) {
      for (final org in row) {
        if (org != null) {
          total += org.merit;
          count++;
        }
      }
    }
    return count > 0 ? total / count : 0;
  }

  double _calculateAverageGeneration() {
    int total = 0;
    int count = 0;
    for (final row in grid) {
      for (final org in row) {
        if (org != null) {
          total += org.generation;
          count++;
        }
      }
    }
    return count > 0 ? total / count : 0;
  }

  double _calculateAverageGenomeLength() {
    int total = 0;
    int count = 0;
    for (final row in grid) {
      for (final org in row) {
        if (org != null) {
          total += org.genomeLength;
          count++;
        }
      }
    }
    return count > 0 ? total / count : 0;
  }

  Map<String, int> _countTasks() {
    final counts = <String, int>{};
    for (final row in grid) {
      for (final org in row) {
        if (org != null) {
          for (final task in org.completedTasks) {
            counts[task] = (counts[task] ?? 0) + 1;
          }
        }
      }
    }
    return counts;
  }

  void reset() {
    grid = List.generate(height, (_) => List.filled(width, null));
    updates = 0;
    stats.reset();
    _initialize();
  }
}
