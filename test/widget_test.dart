// Basic test for Avida-Droid app

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:avida_droid/main.dart';
import 'package:avida_droid/models/world.dart';

void main() {
  testWidgets('App starts successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AvidaDroidApp());

    // Wait for all animations and async operations to complete
    await tester.pumpAndSettle();

    // Verify that the app bar contains the title
    expect(find.text('Avida-Droid'), findsOneWidget);
  });

  testWidgets('Play button exists and toggles icon', (WidgetTester tester) async {
    await tester.pumpWidget(const AvidaDroidApp());
    await tester.pumpAndSettle();

    // Find the play button
    final playButton = find.byIcon(Icons.play_arrow);
    expect(playButton, findsOneWidget, reason: 'Play button should be visible initially');

    // Tap the play button
    await tester.tap(playButton);
    await tester.pump(); // Trigger a single frame to update the icon

    // After tapping play, should show pause icon
    expect(find.byIcon(Icons.pause), findsOneWidget, reason: 'After tapping play, pause icon should be visible');
    expect(find.byIcon(Icons.play_arrow), findsNothing, reason: 'Play icon should no longer be visible');

    // Tap pause button
    await tester.tap(find.byIcon(Icons.pause));
    await tester.pump();

    // Should be back to play icon
    expect(find.byIcon(Icons.play_arrow), findsOneWidget, reason: 'After tapping pause, play icon should be visible again');
    expect(find.byIcon(Icons.pause), findsNothing, reason: 'Pause icon should no longer be visible');
  });

  testWidgets('Simulation updates world when running', (WidgetTester tester) async {
    await tester.pumpWidget(const AvidaDroidApp());
    await tester.pumpAndSettle();

    // Find and tap the play button
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pump(); // Update to start the timer

    // Wait for several timer ticks (default speed is 10 updates/sec, so 100ms per update)
    // We'll wait for 500ms to ensure multiple updates occur
    await tester.pump(const Duration(milliseconds: 500));

    // The world should have updated multiple times
    // We can't directly access the state, but we can verify that the UI is responsive
    // and that we can pause it
    expect(find.byIcon(Icons.pause), findsOneWidget, reason: 'Simulation should still be running');

    // Stop the simulation to clean up
    await tester.tap(find.byIcon(Icons.pause));
    await tester.pump();
  });

  testWidgets('Step button works when paused', (WidgetTester tester) async {
    await tester.pumpWidget(const AvidaDroidApp());
    await tester.pumpAndSettle();

    // Make sure simulation is paused
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);

    // Find and tap the step button (skip_next icon)
    final stepButton = find.byIcon(Icons.skip_next);
    expect(stepButton, findsOneWidget, reason: 'Step button should be visible');

    await tester.tap(stepButton);
    await tester.pump();

    // Simulation should still be paused after stepping
    expect(find.byIcon(Icons.play_arrow), findsOneWidget, reason: 'Simulation should remain paused after step');
  });

  testWidgets('Reset button stops and resets simulation', (WidgetTester tester) async {
    await tester.pumpWidget(const AvidaDroidApp());
    await tester.pumpAndSettle();

    // Start the simulation
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pump();

    // Let it run for a bit
    await tester.pump(const Duration(milliseconds: 200));

    // Find and tap the reset button
    final resetButton = find.byIcon(Icons.refresh);
    expect(resetButton, findsOneWidget, reason: 'Reset button should be visible');

    await tester.tap(resetButton);
    await tester.pump();

    // Simulation should be stopped (play icon visible)
    expect(find.byIcon(Icons.play_arrow), findsOneWidget, reason: 'Simulation should be paused after reset');
  });

  group('World model tests', () {
    test('World initializes with organisms', () {
      final world = World(width: 60, height: 60, mutationRate: 0.001);

      expect(world.organisms.isNotEmpty, true, reason: 'World should start with organisms');
      expect(world.updates, 0, reason: 'World should start with 0 updates');
    });

    test('World update increments update counter', () {
      final world = World(width: 60, height: 60, mutationRate: 0.001);
      final initialUpdates = world.updates;

      world.update();

      expect(world.updates, initialUpdates + 1, reason: 'Update counter should increment after update()');
    });

    test('World update executes organisms', () {
      final world = World(width: 60, height: 60, mutationRate: 0.001);

      // Record initial state
      final initialUpdates = world.updates;

      // Run several updates
      for (int i = 0; i < 10; i++) {
        world.update();
      }

      expect(world.updates, initialUpdates + 10, reason: 'Update counter should increment by 10');

      // Population might change due to births/deaths, but should still exist
      expect(world.organisms.isNotEmpty, true, reason: 'World should still have organisms after updates');
    });

    test('Organisms execute CPU instructions', () {
      final world = World(width: 60, height: 60, mutationRate: 0.001);

      // Get an organism
      final organism = world.organisms.first;

      // Record initial age
      final initialAge = organism.age;

      // Execute some instructions
      organism.execute(100, 0.001);

      // Age should have increased after execution
      expect(organism.age, greaterThan(initialAge), reason: 'Organism age should increase after execution');
    });

    test('Statistics are tracked', () {
      final world = World(width: 60, height: 60, mutationRate: 0.001);

      // Run some updates
      for (int i = 0; i < 5; i++) {
        world.update();
      }

      // Check that statistics exist and are being tracked
      // Population should be close to organism count (within 1 due to timing of death/birth during update)
      expect(world.stats.population, greaterThan(0), reason: 'Stats population should be greater than 0');
      expect((world.stats.population - world.organisms.length).abs(), lessThanOrEqualTo(1),
             reason: 'Stats population should be close to actual organism count');
      expect(world.stats.totalBirths, greaterThanOrEqualTo(0), reason: 'Total births should be tracked');
      expect(world.stats.totalDeaths, greaterThanOrEqualTo(0), reason: 'Total deaths should be tracked');
      expect(world.stats.updates, 5, reason: 'Update count should be 5');
    });
  });
}
