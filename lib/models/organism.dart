import 'dart:math';
import 'instruction.dart';
import 'cpu.dart';

class Organism {
  List<Instruction> genome;
  CPU cpu;
  int age = 0;
  int merit = 1000; // Energy/merit pool (was 100, increased to allow reproduction)
  int fitness = 100;
  int generation = 0;
  int childCount = 0;
  int gestationTime = 0; // Time since last reproduction

  // Task completion tracking
  final Set<String> completedTasks = {};

  // Colors for visualization
  double hue = 0.0;

  Organism(this.genome, {this.generation = 0})
      : cpu = CPU(genome) {
    hue = Random().nextDouble() * 360;
  }

  // Create default ancestor organism
  // Original Avida default-heads.org ancestor (50 instructions)
  // w=h-alloc, y=h-search, c=nop-C, a=nop-A, g=mov-head, v=h-copy, f=if-label, x=h-divide, b=nop-B
  static Organism createAncestor() {
    const ancestorGenome = "wycagccccccccccccccccccccccccccccccccccccyvfcaxgab";
    final genome = ancestorGenome.split('').map((c) => Instruction.fromLetter(c)).toList();
    return Organism(genome);
  }

  // Create organism with random genome
  static Organism createRandom({int genomeLength = 50}) {
    final random = Random();
    final genome = List<Instruction>.generate(
      genomeLength,
      (_) {
        final randomType = InstructionType.values[random.nextInt(InstructionType.values.length)];
        return Instruction(randomType);
      },
    );
    return Organism(genome);
  }

  // Execute N instructions
  Organism? execute(int steps, double mutationRate) {
    for (int i = 0; i < steps; i++) {
      age++;
      gestationTime++;

      // Consume merit/energy for each instruction executed
      // This matches real Avida where organisms use resources over time
      merit--;

      // Death by energy starvation
      if (merit <= 0) {
        return null;
      }

      if (genome.isEmpty) break;

      // Check for task completion based on I/O
      checkTasks();

      // Execute instruction
      bool shouldDivide = cpu.executeInstruction();

      if (shouldDivide) {
        return divide(mutationRate);
      }
    }
    return null;
  }

  // Check if organism has completed any logic tasks
  void checkTasks() {
    if (cpu.outputBuffer.isNotEmpty && cpu.outputBuffer.length >= 2) {
      final input1 = cpu.inputBuffer.isNotEmpty ? cpu.inputBuffer[0] : 0;
      final input2 = cpu.inputBuffer.length > 1 ? cpu.inputBuffer[1] : 0;
      final output = cpu.outputBuffer.last;

      // Check various logic operations
      if (output == (~input1 & 0xFFFFFFFF)) {
        completedTasks.add('NOT');
        merit += 20;
      }
      if (output == (~(input1 & input2) & 0xFFFFFFFF)) {
        completedTasks.add('NAND');
        merit += 30;
      }
      if (output == (input1 & input2)) {
        completedTasks.add('AND');
        merit += 40;
      }
      if (output == (input1 | input2)) {
        completedTasks.add('OR');
        merit += 40;
      }
      if (output == (~(input1 | input2) & 0xFFFFFFFF)) {
        completedTasks.add('NOR');
        merit += 40;
      }
      if (output == (input1 ^ input2)) {
        completedTasks.add('XOR');
        merit += 50;
      }
      if (output == (~(input1 ^ input2) & 0xFFFFFFFF)) {
        completedTasks.add('EQU');
        merit += 50;
      }
    }
  }

  // Divide and produce offspring
  Organism? divide(double mutationRate) {
    if (cpu.offspring.isEmpty || cpu.allocatedSize == 0) {
      return null;
    }

    // Trim offspring to actual written size
    int writtenSize = min(cpu.heads[Head.write]!, cpu.offspring.length);
    List<Instruction> childGenome = cpu.offspring.sublist(0, max(1, writtenSize));

    // Apply mutations
    final random = Random();
    for (int i = 0; i < childGenome.length; i++) {
      if (random.nextDouble() < mutationRate) {
        // Point mutation - random instruction
        final randomType = InstructionType.values[random.nextInt(InstructionType.values.length)];
        childGenome[i] = Instruction(randomType);
      }
    }

    // Insertion mutations
    if (random.nextDouble() < mutationRate * 0.05) {
      final pos = random.nextInt(childGenome.length);
      final randomType = InstructionType.values[random.nextInt(InstructionType.values.length)];
      childGenome.insert(pos, Instruction(randomType));
    }

    // Deletion mutations
    if (childGenome.length > 10 && random.nextDouble() < mutationRate * 0.05) {
      final pos = random.nextInt(childGenome.length);
      childGenome.removeAt(pos);
    }

    // Create offspring
    final child = Organism(childGenome, generation: generation + 1);
    child.hue = (hue + random.nextDouble() * 30 - 15) % 360; // Similar color to parent

    // Update fitness based on gestation time (matches real Avida)
    // Faster reproduction = higher fitness
    if (gestationTime > 0) {
      fitness = (1000 * 100) ~/ gestationTime; // Base merit / gestation time
    }

    // Split merit between parent and child (matches real Avida resource distribution)
    // Parent keeps half, child gets half of parent's current merit
    final childMerit = merit ~/ 2;
    merit = merit - childMerit;
    child.merit = childMerit;

    // Reset gestation timer
    gestationTime = 0;

    // Reset parent's CPU for next reproduction
    cpu.offspring.clear();
    cpu.allocatedSize = 0;
    cpu.heads[Head.read] = 0;
    cpu.heads[Head.write] = 0;

    childCount++;
    return child;
  }

  // Copy organism
  Organism copy() {
    final copy = Organism(List.from(genome), generation: generation);
    copy.age = age;
    copy.merit = merit;
    copy.fitness = fitness;
    copy.childCount = childCount;
    copy.hue = hue;
    copy.completedTasks.addAll(completedTasks);
    return copy;
  }

  String get genomeString {
    return genome.map((i) => i.toLetter()).join();
  }

  int get genomeLength => genome.length;
}
