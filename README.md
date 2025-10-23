# Avida-Droid

A Flutter recreation of the Avida digital life evolution simulation for Android.

## About Avida

Avida is a software platform for digital evolution research where self-replicating computer programs compete, evolve, and adapt over thousands of generations.

## Features

- **Grid-based Visualization**: 60×60 grid displaying the population of digital organisms
- **Digital Organisms**: Self-replicating programs with instruction-based genomes
- **Evolution Simulation**: Watch organisms replicate, mutate, and evolve in real-time
- **Statistics Dashboard**: Track population, average fitness, mutations, and generations
- **Interactive Controls**: Play/pause, adjust simulation speed, and reset
- **Real-time Charts**: Visualize population and fitness trends over time

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Android SDK for Android builds

### Installation

```bash
flutter pub get
flutter run
```

## How It Works

Each organism in Avida has:
- A genome made of computational instructions
- The ability to replicate itself
- A fitness value based on its efficiency
- Mutations that occur during replication (substitution, insertion, deletion)

The simulation runs on a grid where organisms compete for space, with more fit organisms having better chances of successful replication.

## License

MIT License
