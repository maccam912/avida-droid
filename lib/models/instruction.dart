enum InstructionType {
  nop0,    // No operation A
  nop1,    // No operation B
  nop2,    // No operation C
  ifNEqu,  // If not equal
  ifLess,  // If less than
  pop,     // Pop from stack
  push,    // Push to stack
  swapStk, // Swap stack
  swap,    // Swap registers
  shiftR,  // Shift right
  shiftL,  // Shift left
  inc,     // Increment
  dec,     // Decrement
  add,     // Add
  sub,     // Subtract
  nand,    // NAND operation
  copy,    // Copy instruction
  alloc,   // Allocate memory
  divide,  // Divide organism
  call,    // Call procedure
  ret,     // Return from procedure
}

class Instruction {
  final InstructionType type;

  const Instruction(this.type);

  @override
  String toString() {
    return type.name;
  }

  static Instruction random() {
    final types = InstructionType.values;
    return Instruction(types[DateTime.now().microsecondsSinceEpoch % types.length]);
  }
}
