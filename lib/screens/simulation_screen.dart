import 'package:flutter/material.dart';
import 'dart:async';
import '../models/world.dart';
import '../widgets/world_grid_painter.dart';
import '../widgets/statistics_panel.dart';
import 'organism_detail_screen.dart';

class SimulationScreen extends StatefulWidget {
  const SimulationScreen({super.key});

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> {
  late World world;
  Timer? updateTimer;
  bool isRunning = false;
  String colorMode = 'lineage';
  double speed = 10; // Updates per second
  int gridSize = 60;

  @override
  void initState() {
    super.initState();
    world = World(width: gridSize, height: gridSize);
  }

  @override
  void dispose() {
    updateTimer?.cancel();
    super.dispose();
  }

  void toggleSimulation() {
    setState(() {
      isRunning = !isRunning;
      if (isRunning) {
        startSimulation();
      } else {
        stopSimulation();
      }
    });
  }

  void startSimulation() {
    final interval = Duration(milliseconds: (1000 / speed).round());
    updateTimer = Timer.periodic(interval, (timer) {
      setState(() {
        world.update();
      });
    });
  }

  void stopSimulation() {
    updateTimer?.cancel();
  }

  void resetSimulation() {
    setState(() {
      isRunning = false;
      updateTimer?.cancel();
      world.reset();
    });
  }

  void stepSimulation() {
    setState(() {
      world.update();
    });
  }

  void changeSpeed(double newSpeed) {
    setState(() {
      speed = newSpeed;
      if (isRunning) {
        updateTimer?.cancel();
        startSimulation();
      }
    });
  }

  void changeMutationRate(double newRate) {
    setState(() {
      world.mutationRate = newRate;
    });
  }

  void changeColorMode(String mode) {
    setState(() {
      colorMode = mode;
    });
  }

  void onCellTap(int x, int y) {
    final organism = world.getOrganism(x, y);
    if (organism != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrganismDetailScreen(organism: organism),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade900,
          title: const Text('Avida-Droid', style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
              icon: Icon(isRunning ? Icons.pause : Icons.play_arrow, color: Colors.white),
              onPressed: toggleSimulation,
              tooltip: isRunning ? 'Pause' : 'Play',
            ),
            IconButton(
              icon: const Icon(Icons.skip_next, color: Colors.white),
              onPressed: isRunning ? null : stepSimulation,
              tooltip: 'Step',
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: resetSimulation,
              tooltip: 'Reset',
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () => _showSettingsDialog(context),
              tooltip: 'Settings',
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.blue,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(icon: Icon(Icons.grid_on), text: 'Grid'),
              Tab(icon: Icon(Icons.bar_chart), text: 'Stats'),
              Tab(icon: Icon(Icons.tune), text: 'Controls'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Grid tab
            Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24),
              ),
              child: WorldGridWidget(
                world: world,
                colorMode: colorMode,
                onCellTap: onCellTap,
              ),
            ),
            // Statistics tab
            StatisticsPanel(stats: world.stats),
            // Controls tab
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Simulation Speed',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Speed:', style: TextStyle(color: Colors.white)),
                      Expanded(
                        child: Slider(
                          value: speed,
                          min: 1,
                          max: 100,
                          divisions: 99,
                          label: '${speed.round()} ups',
                          onChanged: changeSpeed,
                        ),
                      ),
                      Text('${speed.round()} ups',
                          style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Mutation Rate',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Mutation:', style: TextStyle(color: Colors.white)),
                      Expanded(
                        child: Slider(
                          value: world.mutationRate,
                          min: 0,
                          max: 0.05,
                          divisions: 100,
                          label: '${(world.mutationRate * 100).toStringAsFixed(1)}%',
                          onChanged: changeMutationRate,
                        ),
                      ),
                      Text('${(world.mutationRate * 100).toStringAsFixed(2)}%',
                          style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Color Mode',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildColorModeButton('Lineage', 'lineage'),
                      _buildColorModeButton('Fitness', 'fitness'),
                      _buildColorModeButton('Age', 'age'),
                      _buildColorModeButton('Generation', 'generation'),
                      _buildColorModeButton('Tasks', 'tasks'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorModeButton(String label, String mode) {
    final isSelected = colorMode == mode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: ElevatedButton(
        onPressed: () => changeColorMode(mode),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : Colors.grey.shade700,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          minimumSize: const Size(0, 0),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white),
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Grid Size'),
              subtitle: Text('Current: ${gridSize}x$gridSize'),
            ),
            const Divider(),
            const ListTile(
              title: Text('About Avida'),
              subtitle: Text(
                'Avida is a digital evolution platform where self-replicating '
                'computer programs evolve through mutation and natural selection.',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
