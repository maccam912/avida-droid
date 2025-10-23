import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/organism.dart';

class SimulationEngine extends ChangeNotifier {
  static const int gridWidth = 60;
  static const int gridHeight = 60;
  static const double baseMutationRate = 0.02; // 2% mutation rate per replication

  List<List<Organism?>> grid = [];
  int generation = 0;
  int totalOrganisms = 0;
  double averageFitness = 1.0;
  int totalMutations = 0;
  bool isRunning = false;
  int ticksPerSecond = 10;

  Timer? _timer;
  final Random _random = Random();

  // Statistics for charts
  final List<int> populationHistory = [];
  final List<double> fitnessHistory = [];
  final int maxHistoryLength = 100;

  SimulationEngine() {
    _initializeGrid();
  }

  void _initializeGrid() {
    grid = List.generate(
      gridHeight,
      (y) => List.generate(gridWidth, (x) => null),
    );

    // Seed with one ancestor in the center
    final centerX = gridWidth ~/ 2;
    final centerY = gridHeight ~/ 2;
    grid[centerY][centerX] = Organism.createAncestor(centerX, centerY);
    totalOrganisms = 1;
    generation = 0;
    averageFitness = 1.0;
    totalMutations = 0;

    populationHistory.clear();
    fitnessHistory.clear();
    populationHistory.add(totalOrganisms);
    fitnessHistory.add(averageFitness);
  }

  void start() {
    if (isRunning) return;
    isRunning = true;

    final intervalMs = (1000 / ticksPerSecond).round();
    _timer = Timer.periodic(Duration(milliseconds: intervalMs), (_) {
      _tick();
    });

    notifyListeners();
  }

  void pause() {
    isRunning = false;
    _timer?.cancel();
    _timer = null;
    notifyListeners();
  }

  void reset() {
    pause();
    _initializeGrid();
    notifyListeners();
  }

  void setSpeed(int newTicksPerSecond) {
    ticksPerSecond = newTicksPerSecond.clamp(1, 60);
    if (isRunning) {
      pause();
      start();
    }
  }

  void _tick() {
    // Update each organism
    final organismPositions = <(int, int)>[];

    for (int y = 0; y < gridHeight; y++) {
      for (int x = 0; x < gridWidth; x++) {
        if (grid[y][x] != null) {
          organismPositions.add((x, y));
        }
      }
    }

    // Shuffle to randomize execution order
    organismPositions.shuffle(_random);

    for (final (x, y) in organismPositions) {
      final organism = grid[y][x];
      if (organism == null) continue;

      // Age the organism
      final aged = organism.copyWith(
        age: organism.age + 1,
        energy: organism.energy - 1,
      );

      // Organism dies if energy depleted
      if (aged.energy <= 0) {
        grid[y][x] = null;
        totalOrganisms--;
        continue;
      }

      grid[y][x] = aged;

      // Attempt replication based on fitness
      if (_random.nextDouble() < (aged.fitness * 0.1) && aged.age > 5) {
        _attemptReplication(aged);
      }
    }

    // Update statistics
    _updateStatistics();
    notifyListeners();
  }

  void _attemptReplication(Organism parent) {
    // Find empty neighbor cell
    final neighbors = _getEmptyNeighbors(parent.x, parent.y);
    if (neighbors.isEmpty) return;

    final (newX, newY) = neighbors[_random.nextInt(neighbors.length)];

    // Create offspring with potential mutations
    final offspring = parent.replicate(newX, newY, baseMutationRate);

    // Track if mutation occurred
    if (!_genomesEqual(parent.genome, offspring.genome)) {
      totalMutations++;
    }

    grid[newY][newX] = offspring;
    totalOrganisms++;

    if (offspring.generation > generation) {
      generation = offspring.generation;
    }
  }

  bool _genomesEqual(List<dynamic> g1, List<dynamic> g2) {
    if (g1.length != g2.length) return false;
    for (int i = 0; i < g1.length; i++) {
      if (g1[i].type != g2[i].type) return false;
    }
    return true;
  }

  List<(int, int)> _getEmptyNeighbors(int x, int y) {
    final neighbors = <(int, int)>[];
    final offsets = [
      (-1, -1), (0, -1), (1, -1),
      (-1, 0), (1, 0),
      (-1, 1), (0, 1), (1, 1),
    ];

    for (final (dx, dy) in offsets) {
      final newX = x + dx;
      final newY = y + dy;

      if (newX >= 0 &&
          newX < gridWidth &&
          newY >= 0 &&
          newY < gridHeight &&
          grid[newY][newX] == null) {
        neighbors.add((newX, newY));
      }
    }

    return neighbors;
  }

  void _updateStatistics() {
    if (totalOrganisms == 0) {
      averageFitness = 0;
      return;
    }

    double totalFitness = 0;
    int count = 0;

    for (int y = 0; y < gridHeight; y++) {
      for (int x = 0; x < gridWidth; x++) {
        final organism = grid[y][x];
        if (organism != null) {
          totalFitness += organism.fitness;
          count++;
        }
      }
    }

    averageFitness = count > 0 ? totalFitness / count : 0;

    // Update history
    populationHistory.add(totalOrganisms);
    fitnessHistory.add(averageFitness);

    if (populationHistory.length > maxHistoryLength) {
      populationHistory.removeAt(0);
      fitnessHistory.removeAt(0);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
