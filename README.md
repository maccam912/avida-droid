# Avida-Droid

A complete Flutter Android implementation of Avida, the digital evolution platform. Watch self-replicating digital organisms evolve through mutation and natural selection in real-time!

## About Avida

Avida is a sophisticated artificial life simulation platform originally developed for scientific research. Digital organisms (self-replicating computer programs) compete for space and CPU cycles on a 2D grid. They can evolve to perform logic tasks (NOT, AND, OR, XOR, etc.) which reward them with additional computational resources, creating evolutionary pressure toward increasing complexity.

## Features

This implementation includes all core Avida mechanics:

### Virtual CPU & Instruction Set
- **26 instructions** including no-ops, math operations, flow control, and biological operations
- **3 registers** (AX, BX, CX) for computation
- **4 heads** (IP, Read, Write, Flow) for genome manipulation
- Full stack operations and conditional execution
- Proper circular genome handling

### Digital Organisms
- Self-replicating organisms with variable-length genomes (typically 50-1000 instructions)
- CPU cycle allocation based on merit (task completion)
- Generation tracking and lineage visualization
- Task completion detection (7 logic operations)

### Population Dynamics
- 60x60 grid world (configurable)
- Spatial competition for resources
- Reproduction into adjacent cells
- Age-based death mechanics

### Mutation System
- Point mutations (random instruction changes)
- Insertion mutations
- Deletion mutations
- Adjustable mutation rate (0-5%)

### Visualizations
- **Lineage mode**: Color by evolutionary lineage
- **Fitness mode**: Color by merit/computational reward
- **Age mode**: Color by organism age
- **Generation mode**: Color by generation number
- **Tasks mode**: Color by number of logic tasks completed

### Statistics & Analysis
- Real-time population tracking
- Birth and death counts
- Average age, fitness, generation, and genome length
- Task completion counts for all 7 logic operations
- Historical data tracking

### Interactive Controls
- Play/Pause simulation
- Single-step execution
- Speed control (1-100 updates per second)
- Mutation rate adjustment
- Reset simulation
- Tap organisms to view detailed information
- Settings dialog

## Implementation Details

The app is built with clean architecture:

```
lib/
├── models/
│   ├── instruction.dart    # 26-instruction set with letter encoding
│   ├── cpu.dart            # Virtual CPU with registers, heads, and execution
│   ├── organism.dart       # Digital organism with genome and task checking
│   ├── world.dart          # Population grid and simulation engine
│   └── statistics.dart     # Stats tracking and history
├── widgets/
│   ├── world_grid_painter.dart   # Custom painter for grid visualization
│   └── statistics_panel.dart     # Stats display widget
├── screens/
│   ├── simulation_screen.dart     # Main simulation UI
│   └── organism_detail_screen.dart # Detailed organism inspector
└── main.dart               # App entry point
```

## Running the App

1. Ensure you have Flutter installed
2. Connect an Android device or start an emulator
3. Run:
```bash
flutter run
```

## How to Use

1. **Start**: Press the play button to begin the simulation
2. **Adjust Speed**: Use the speed slider to control updates per second
3. **Adjust Mutations**: Use the mutation slider to change evolutionary pressure
4. **Change View**: Select different color modes to visualize different aspects
5. **Inspect**: Tap any organism to see its genome, CPU state, and task completion
6. **Step**: Use the step button to advance one update at a time
7. **Reset**: Reset to start over with a fresh ancestor

## The Ancestor

The simulation starts with a single ancestor organism in the center of the grid with this genome:
```
wzcagcccccccccccccccccccccccccccccccccccccczvfcaxgab
```

This 50-instruction program contains the minimal code needed for self-replication. The abundant 'c' instructions (nop-C) serve as templates for the copy mechanism to locate specific genome positions.

## Observing Evolution

Watch for:
- **Population growth** as organisms successfully replicate
- **Lineage diversification** visible in lineage color mode
- **Task evolution** as organisms discover logic operations
- **Genome length changes** through insertions/deletions
- **Fitness increases** as advantageous mutations spread

## Technical Notes

- Landscape orientation enforced for better viewing
- Dark theme optimized for visualization
- Efficient CustomPainter-based rendering
- Proper null safety throughout
- Zero analysis issues

## License

This is an educational reimplementation inspired by the original Avida project from Michigan State University's Digital Evolution Laboratory.
