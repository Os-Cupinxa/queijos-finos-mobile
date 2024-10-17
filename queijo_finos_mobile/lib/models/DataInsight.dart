class DataInsight {
  double active;
  double activeInContemplation;
  double dropout;

  DataInsight({
    required this.active,
    required this.activeInContemplation,
    required this.dropout,
  });

  // Método para calcular a porcentagem
  Map<String, double> calculatePercentages() {
    double total = active + activeInContemplation + dropout;
    return {
      'active': (active / total) * 100,
      'activeInContemplation': (activeInContemplation / total) * 100,
      'dropout': (dropout / total) * 100,
    };
  }
}
