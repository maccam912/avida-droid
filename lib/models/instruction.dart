// Avida Instruction Set Implementation

enum InstructionType {
  // No-ops
  nopA, nopB, nopC,

  // Flow control
  ifNEqu, ifLess, ifLabel, movHead, jmpHead, getHead, setFlow,

  // Single argument math
  shiftR, shiftL, inc, dec, push, pop, swapStk, swap,

  // Double argument math
  add, sub, nand,

  // Biological operations
  hCopy, hAlloc, hDivide, hSearch,

  // I/O
  io,
}

class Instruction {
  final InstructionType type;

  const Instruction(this.type);

  @override
  String toString() {
    return type.toString().split('.').last;
  }

  // Convert string to instruction
  static Instruction? fromString(String str) {
    try {
      final type = InstructionType.values.firstWhere(
        (e) => e.toString().split('.').last.toLowerCase() == str.toLowerCase()
      );
      return Instruction(type);
    } catch (e) {
      return null;
    }
  }

  // Convert letter to instruction (simplified encoding)
  static Instruction fromLetter(String letter) {
    const Map<String, InstructionType> letterMap = {
      'a': InstructionType.nopA,
      'b': InstructionType.nopB,
      'c': InstructionType.nopC,
      'd': InstructionType.ifNEqu,
      'e': InstructionType.ifLess,
      'f': InstructionType.ifLabel,
      'g': InstructionType.movHead,
      'h': InstructionType.jmpHead,
      'i': InstructionType.getHead,
      'j': InstructionType.setFlow,
      'k': InstructionType.shiftR,
      'l': InstructionType.shiftL,
      'm': InstructionType.inc,
      'n': InstructionType.dec,
      'o': InstructionType.push,
      'p': InstructionType.pop,
      'q': InstructionType.swapStk,
      'r': InstructionType.swap,
      's': InstructionType.add,
      't': InstructionType.sub,
      'u': InstructionType.nand,
      'v': InstructionType.hCopy,
      'w': InstructionType.hAlloc,
      'x': InstructionType.hDivide,
      'y': InstructionType.hSearch,
      'z': InstructionType.io,
    };

    return Instruction(letterMap[letter.toLowerCase()] ?? InstructionType.nopA);
  }

  // Convert instruction to letter
  String toLetter() {
    const Map<InstructionType, String> typeToLetter = {
      InstructionType.nopA: 'a',
      InstructionType.nopB: 'b',
      InstructionType.nopC: 'c',
      InstructionType.ifNEqu: 'd',
      InstructionType.ifLess: 'e',
      InstructionType.ifLabel: 'f',
      InstructionType.movHead: 'g',
      InstructionType.jmpHead: 'h',
      InstructionType.getHead: 'i',
      InstructionType.setFlow: 'j',
      InstructionType.shiftR: 'k',
      InstructionType.shiftL: 'l',
      InstructionType.inc: 'm',
      InstructionType.dec: 'n',
      InstructionType.push: 'o',
      InstructionType.pop: 'p',
      InstructionType.swapStk: 'q',
      InstructionType.swap: 'r',
      InstructionType.add: 's',
      InstructionType.sub: 't',
      InstructionType.nand: 'u',
      InstructionType.hCopy: 'v',
      InstructionType.hAlloc: 'w',
      InstructionType.hDivide: 'x',
      InstructionType.hSearch: 'y',
      InstructionType.io: 'z',
    };

    return typeToLetter[type] ?? 'a';
  }
}
