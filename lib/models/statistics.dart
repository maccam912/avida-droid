class Statistics {
  int updates = 0;
  int population = 0;
  int totalBirths = 0;
  int totalDeaths = 0;
  double averageAge = 0;
  double averageFitness = 0;
  double averageGeneration = 0;
  double averageGenomeLength = 0;
  Map<String, int> taskCounts = {};

  // Historical data for graphing
  final List<int> populationHistory = [];
  final List<double> fitnessHistory = [];
  final List<double> generationHistory = [];
  final List<double> genomeLengthHistory = [];
  final int maxHistoryLength = 1000;

  void update({
    required int updates,
    required int population,
    required int births,
    required int deaths,
    required double averageAge,
    required double averageFitness,
    required double averageGeneration,
    required double averageGenomeLength,
    required Map<String, int> taskCounts,
  }) {
    updates = updates;
    population = population;
    totalBirths += births;
    totalDeaths += deaths;
    this.averageAge = averageAge;
    this.averageFitness = averageFitness;
    this.averageGeneration = averageGeneration;
    this.averageGenomeLength = averageGenomeLength;
    this.taskCounts = Map.from(taskCounts);

    // Update histories
    populationHistory.add(population);
    fitnessHistory.add(averageFitness);
    generationHistory.add(averageGeneration);
    genomeLengthHistory.add(averageGenomeLength);

    // Trim histories if too long
    if (populationHistory.length > maxHistoryLength) {
      populationHistory.removeAt(0);
      fitnessHistory.removeAt(0);
      generationHistory.removeAt(0);
      genomeLengthHistory.removeAt(0);
    }
  }

  void reset() {
    updates = 0;
    population = 0;
    totalBirths = 0;
    totalDeaths = 0;
    averageAge = 0;
    averageFitness = 0;
    averageGeneration = 0;
    averageGenomeLength = 0;
    taskCounts = {};
    populationHistory.clear();
    fitnessHistory.clear();
    generationHistory.clear();
    genomeLengthHistory.clear();
  }
}
