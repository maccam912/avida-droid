import 'dart:math';
import 'instruction.dart';

// CPU Registers
enum Register { ax, bx, cx }

// CPU Heads
enum Head { ip, read, write, flow }

class CPU {
  // Registers (32-bit integers)
  final Map<Register, int> registers = {
    Register.ax: 0,
    Register.bx: 0,
    Register.cx: 0,
  };

  // Heads (pointers into genome)
  final Map<Head, int> heads = {
    Head.ip: 0,
    Head.read: 0,
    Head.write: 0,
    Head.flow: 0,
  };

  // Stack
  final List<int> stack = [];

  // Input/Output buffers
  final List<int> inputBuffer = [];
  final List<int> outputBuffer = [];

  // Genome reference (circular array)
  List<Instruction> genome;

  // Offspring genome being built
  List<Instruction> offspring = [];

  // Allocated memory size for offspring
  int allocatedSize = 0;

  CPU(this.genome) {
    reset();
  }

  void reset() {
    registers[Register.ax] = 0;
    registers[Register.bx] = 0;
    registers[Register.cx] = 0;

    heads[Head.ip] = 0;
    heads[Head.read] = 0;
    heads[Head.write] = 0;
    heads[Head.flow] = 0;

    stack.clear();
    inputBuffer.clear();
    outputBuffer.clear();
    offspring.clear();
    allocatedSize = 0;
  }

  // Get register specified by following nop
  Register getRegisterFromNop(InstructionType nop) {
    switch (nop) {
      case InstructionType.nopA:
        return Register.ax;
      case InstructionType.nopB:
        return Register.bx;
      case InstructionType.nopC:
        return Register.cx;
      default:
        return Register.bx; // Default register
    }
  }

  // Get head specified by following nop
  Head getHeadFromNop(InstructionType nop) {
    switch (nop) {
      case InstructionType.nopA:
        return Head.ip;
      case InstructionType.nopB:
        return Head.read;
      case InstructionType.nopC:
        return Head.write;
      default:
        return Head.flow;
    }
  }

  // Get complement nop
  InstructionType getComplementNop(InstructionType nop) {
    switch (nop) {
      case InstructionType.nopA:
        return InstructionType.nopB;
      case InstructionType.nopB:
        return InstructionType.nopA;
      case InstructionType.nopC:
        return InstructionType.nopC;
      default:
        return InstructionType.nopA;
    }
  }

  // Peek at next instruction without advancing IP
  Instruction? peekNext() {
    if (genome.isEmpty) return null;
    int nextPos = (heads[Head.ip]! + 1) % genome.length;
    return genome[nextPos];
  }

  // Advance head with circular wrapping
  void advanceHead(Head head, [int steps = 1]) {
    if (genome.isEmpty) return;
    heads[head] = (heads[head]! + steps) % genome.length;
  }

  // Execute single instruction and return if organism should divide
  bool executeInstruction() {
    if (genome.isEmpty) return false;

    final inst = genome[heads[Head.ip]!];
    bool shouldDivide = false;

    // Check for nop modifier on next instruction
    final nextInst = peekNext();
    Register workReg = Register.bx;
    Head workHead = Head.flow;

    if (nextInst != null &&
        (nextInst.type == InstructionType.nopA ||
         nextInst.type == InstructionType.nopB ||
         nextInst.type == InstructionType.nopC)) {
      workReg = getRegisterFromNop(nextInst.type);
      workHead = getHeadFromNop(nextInst.type);
    }

    switch (inst.type) {
      // No-ops do nothing
      case InstructionType.nopA:
      case InstructionType.nopB:
      case InstructionType.nopC:
        break;

      // Math operations
      case InstructionType.inc:
        final regValue = registers[workReg] ?? 0;
        registers[workReg] = (regValue + 1) & 0xFFFFFFFF;
        if (nextInst?.type == InstructionType.nopA ||
            nextInst?.type == InstructionType.nopB ||
            nextInst?.type == InstructionType.nopC) {
          advanceHead(Head.ip);
        }
        break;

      case InstructionType.dec:
        final regValue = registers[workReg] ?? 0;
        registers[workReg] = (regValue - 1) & 0xFFFFFFFF;
        if (nextInst?.type == InstructionType.nopA ||
            nextInst?.type == InstructionType.nopB ||
            nextInst?.type == InstructionType.nopC) {
          advanceHead(Head.ip);
        }
        break;

      case InstructionType.shiftR:
        final regValue = registers[workReg] ?? 0;
        registers[workReg] = regValue >> 1;
        if (nextInst?.type == InstructionType.nopA ||
            nextInst?.type == InstructionType.nopB ||
            nextInst?.type == InstructionType.nopC) {
          advanceHead(Head.ip);
        }
        break;

      case InstructionType.shiftL:
        final regValue = registers[workReg] ?? 0;
        registers[workReg] = (regValue << 1) & 0xFFFFFFFF;
        if (nextInst?.type == InstructionType.nopA ||
            nextInst?.type == InstructionType.nopB ||
            nextInst?.type == InstructionType.nopC) {
          advanceHead(Head.ip);
        }
        break;

      case InstructionType.add:
        registers[Register.bx] = (registers[Register.ax]! + registers[Register.bx]!) & 0xFFFFFFFF;
        break;

      case InstructionType.sub:
        registers[Register.bx] = (registers[Register.bx]! - registers[Register.cx]!) & 0xFFFFFFFF;
        break;

      case InstructionType.nand:
        registers[Register.bx] = ~(registers[Register.ax]! & registers[Register.bx]!) & 0xFFFFFFFF;
        break;

      // Stack operations
      case InstructionType.push:
        stack.add(registers[workReg] ?? 0);
        if (nextInst?.type == InstructionType.nopA ||
            nextInst?.type == InstructionType.nopB ||
            nextInst?.type == InstructionType.nopC) {
          advanceHead(Head.ip);
        }
        break;

      case InstructionType.pop:
        if (stack.isNotEmpty) {
          registers[workReg] = stack.removeLast();
        }
        if (nextInst?.type == InstructionType.nopA ||
            nextInst?.type == InstructionType.nopB ||
            nextInst?.type == InstructionType.nopC) {
          advanceHead(Head.ip);
        }
        break;

      case InstructionType.swap:
        final temp = registers[Register.ax] ?? 0;
        final bxVal = registers[Register.bx] ?? 0;
        registers[Register.ax] = bxVal;
        registers[Register.bx] = temp;
        break;

      case InstructionType.swapStk:
        if (stack.isNotEmpty) {
          final temp = registers[workReg] ?? 0;
          registers[workReg] = stack.last;
          stack[stack.length - 1] = temp;
        }
        if (nextInst?.type == InstructionType.nopA ||
            nextInst?.type == InstructionType.nopB ||
            nextInst?.type == InstructionType.nopC) {
          advanceHead(Head.ip);
        }
        break;

      // Flow control
      case InstructionType.ifNEqu:
        if ((registers[Register.bx] ?? 0) == (registers[Register.cx] ?? 0)) {
          advanceHead(Head.ip); // Skip next instruction
        }
        break;

      case InstructionType.ifLess:
        if ((registers[Register.bx] ?? 0) >= (registers[Register.cx] ?? 0)) {
          advanceHead(Head.ip); // Skip next instruction
        }
        break;

      case InstructionType.movHead:
        heads[workHead] = heads[Head.ip] ?? 0;
        if (nextInst?.type == InstructionType.nopA ||
            nextInst?.type == InstructionType.nopB ||
            nextInst?.type == InstructionType.nopC) {
          advanceHead(Head.ip);
        }
        break;

      case InstructionType.jmpHead:
        heads[Head.ip] = heads[workHead] ?? 0;
        if (nextInst?.type == InstructionType.nopA ||
            nextInst?.type == InstructionType.nopB ||
            nextInst?.type == InstructionType.nopC) {
          advanceHead(Head.ip);
        }
        return false; // Don't advance IP again

      // Biological operations
      case InstructionType.hAlloc:
        allocatedSize = max(1, min(registers[Register.ax] ?? 50, genome.length * 2));
        offspring = List<Instruction>.filled(allocatedSize, const Instruction(InstructionType.nopA), growable: true);
        break;

      case InstructionType.hCopy:
        if (offspring.isNotEmpty && heads[Head.write]! < offspring.length) {
          offspring[heads[Head.write]!] = genome[heads[Head.read]!];
        }
        advanceHead(Head.read);
        advanceHead(Head.write);
        break;

      case InstructionType.hDivide:
        shouldDivide = offspring.isNotEmpty && allocatedSize > 0;
        break;

      case InstructionType.hSearch:
        // Search for complement template
        if (nextInst != null &&
            (nextInst.type == InstructionType.nopA ||
             nextInst.type == InstructionType.nopB ||
             nextInst.type == InstructionType.nopC)) {
          final target = getComplementNop(nextInst.type);
          // Simple search forward
          for (int i = 1; i < genome.length; i++) {
            int pos = (heads[Head.flow]! + i) % genome.length;
            if (genome[pos].type == target) {
              heads[Head.flow] = pos;
              registers[Register.bx] = i;
              registers[Register.cx] = i;
              break;
            }
          }
          advanceHead(Head.ip);
        }
        break;

      // I/O
      case InstructionType.io:
        if (inputBuffer.isNotEmpty) {
          registers[Register.bx] = inputBuffer.removeAt(0);
        }
        outputBuffer.add(registers[Register.bx] ?? 0);
        break;

      default:
        break;
    }

    // Advance instruction pointer
    advanceHead(Head.ip);

    return shouldDivide;
  }
}
