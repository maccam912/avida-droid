import 'instruction.dart';
import 'dart:math';

class Organism {
  final List<Instruction> genome;
  final int age;
  final int generation;
  final double fitness;
  final int x;
  final int y;
  int instructionPointer;
  final List<int> stack;
  final Map<String, int> registers;
  int energy;

  Organism({
    required this.genome,
    this.age = 0,
    this.generation = 0,
    this.fitness = 1.0,
    required this.x,
    required this.y,
    this.instructionPointer = 0,
    List<int>? stack,
    Map<String, int>? registers,
    this.energy = 100,
  })  : stack = stack ?? [],
        registers = registers ?? {'AX': 0, 'BX': 0, 'CX': 0};

  // Create offspring with potential mutations
  Organism replicate(int newX, int newY, double mutationRate) {
    final newGenome = List<Instruction>.from(genome);
    final random = Random();

    // Apply mutations
    if (random.nextDouble() < mutationRate) {
      final mutationType = random.nextInt(3);
      if (newGenome.isNotEmpty) {
        switch (mutationType) {
          case 0: // Substitution
            final pos = random.nextInt(newGenome.length);
            newGenome[pos] = Instruction.random();
            break;
          case 1: // Insertion
            final pos = random.nextInt(newGenome.length + 1);
            newGenome.insert(pos, Instruction.random());
            break;
          case 2: // Deletion
            if (newGenome.length > 10) {
              // Keep minimum genome size
              final pos = random.nextInt(newGenome.length);
              newGenome.removeAt(pos);
            }
            break;
        }
      }
    }

    // Calculate offspring fitness based on genome efficiency
    final newFitness = _calculateFitness(newGenome);

    return Organism(
      genome: newGenome,
      age: 0,
      generation: generation + 1,
      fitness: newFitness,
      x: newX,
      y: newY,
      energy: 100,
    );
  }

  // Simple fitness calculation based on genome size and efficiency
  double _calculateFitness(List<Instruction> genome) {
    if (genome.isEmpty) return 0.1;

    // Shorter genomes that can still replicate are more fit
    final sizeFactor = 100.0 / genome.length.clamp(10, 200);

    // Bonus for having diverse instructions
    final uniqueInstructions = genome.map((i) => i.type).toSet().length;
    final diversityFactor = uniqueInstructions / InstructionType.values.length;

    return (sizeFactor * 0.7 + diversityFactor * 0.3).clamp(0.1, 10.0);
  }

  Organism copyWith({
    List<Instruction>? genome,
    int? age,
    int? generation,
    double? fitness,
    int? x,
    int? y,
    int? instructionPointer,
    List<int>? stack,
    Map<String, int>? registers,
    int? energy,
  }) {
    return Organism(
      genome: genome ?? this.genome,
      age: age ?? this.age,
      generation: generation ?? this.generation,
      fitness: fitness ?? this.fitness,
      x: x ?? this.x,
      y: y ?? this.y,
      instructionPointer: instructionPointer ?? this.instructionPointer,
      stack: stack ?? List.from(this.stack),
      registers: registers ?? Map.from(this.registers),
      energy: energy ?? this.energy,
    );
  }

  // Create the ancestor organism
  static Organism createAncestor(int x, int y) {
    // Simple initial genome with basic replication capability
    final genome = [
      Instruction(InstructionType.nop0),
      Instruction(InstructionType.nop1),
      Instruction(InstructionType.copy),
      Instruction(InstructionType.copy),
      Instruction(InstructionType.copy),
      Instruction(InstructionType.alloc),
      Instruction(InstructionType.divide),
      Instruction(InstructionType.nop2),
    ];

    return Organism(
      genome: genome,
      x: x,
      y: y,
      fitness: 1.0,
      energy: 100,
    );
  }
}
