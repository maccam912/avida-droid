import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/simulation_engine.dart';
import '../widgets/grid_view.dart' as avida;
import '../widgets/statistics_panel.dart';
import '../widgets/control_panel.dart';
import '../widgets/charts_panel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avida-Droid'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<SimulationEngine>(
        builder: (context, engine, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              // Responsive layout: single column on small screens, two columns on larger screens
              if (constraints.maxWidth < 800) {
                return _buildMobileLayout(engine);
              } else {
                return _buildTabletLayout(engine);
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(SimulationEngine engine) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: avida.GridView(engine: engine),
          ),
          ControlPanel(engine: engine),
          StatisticsPanel(engine: engine),
          ChartsPanel(engine: engine),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(SimulationEngine engine) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: avida.GridView(engine: engine),
                ),
              ),
              ControlPanel(engine: engine),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: Column(
              children: [
                StatisticsPanel(engine: engine),
                ChartsPanel(engine: engine),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
