class DataInsight {

  DataInsight({
    required this.active,
    required this.activeInContemplation,
    required this.dropout,
  });
  int active;
  int activeInContemplation;
  int dropout;

  // Método para calcular a porcentagem
  Map<String, double> calculatePercentages() {
    int total = active + activeInContemplation + dropout;
    return {
      'active': (active / total) * 100,
      'activeInContemplation': (activeInContemplation / total) * 100,
      'dropout': (dropout / total) * 100,
    };
  }
}
