import 'package:flutter/material.dart';
import 'package:queijo_finos_mobile/models/DataInsight.dart';
import 'package:queijo_finos_mobile/ui/components/charts/LineChartSample2.dart';
import 'package:intl/intl.dart'; // Importado para formatar datas, caso necessário

// Criar um mock de dados
final DataInsight insightData = DataInsight(
  active: 243,
  activeInContemplation: 130,
  dropout: 87,
);

// Calcular porcentagens
final percentages = insightData.calculatePercentages();

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isWeekly = true;

  // Dados para o gráfico semanal
  final DataPoint weeklyData = DataPoint(
    curData: [3, 4, 2, 5, 6, 4, 3],
    pastData: [2, 3, 4, 3, 4, 2, 1],
    time: ['08/10', '09/10', '10/10', '11/10', '12/10', '13/10', '14/10'],
  );

  // Dados para o gráfico mensal
  final DataPoint monthlyData = DataPoint(
    curData: [20, 30, 40, 80, 60, 20, 30, 65, 100, 80, 20, 100],
    pastData: [15, 25, 35, 30, 40, 80, 55, 20, 65, 75, 85, 40],
    time: [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ],
  );

  // Função para obter a data formatada
  String getFormattedDate() {
    final DateTime now = DateTime.now();
    final List<String> months = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];
    return '${now.day} de ${months[now.month - 1]} de ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xFF0D2434),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quantidade de produção (p/U)',
                      style: const TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getFormattedDate(), // Exibe a data formatada
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            _buildToggleButton(
                              label: "Semanal",
                              isSelected: isWeekly,
                              onTap: () => setState(() => isWeekly = true),
                            ),
                            _buildToggleButton(
                              label: "Mensal",
                              isSelected: !isWeekly,
                              onTap: () => setState(() => isWeekly = false),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    LineChartSample2(
                      dataPoint: isWeekly ? weeklyData : monthlyData,
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Transform.translate(
                offset: Offset(0, -30),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Insights",
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        "Quantidade de propriedades por status",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            // Ativos
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Ativos",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text("20/08/2024",
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.grey,
                                        ))
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${insightData.active.toInt()}", // Usando dados da classe
                                      style: const TextStyle(
                                        fontSize: 32.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "${percentages['active']!.toStringAsFixed(1)}%", // Porcentagem
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.grey,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            // Ativos em contemplação
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Ativos em contemplação",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text("20/08/2024",
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.grey,
                                        ))
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${insightData.activeInContemplation.toInt()}", // Usando dados da classe
                                      style: const TextStyle(
                                        fontSize: 32.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "${percentages['activeInContemplation']!.toStringAsFixed(1)}%", // Porcentagem
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.grey,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            // Desistentes
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Desistentes",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text("20/08/2024",
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.grey,
                                        ))
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${insightData.dropout.toInt()}", // Usando dados da classe
                                      style: const TextStyle(
                                        fontSize: 32.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "${percentages['dropout']!.toStringAsFixed(1)}%", // Porcentagem
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.grey,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Função para construir o botão de alternância
  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF9D8E61) : const Color(0xFFF5F4F6),
          borderRadius: isSelected
              ? const BorderRadius.horizontal(left: Radius.circular(20))
              : const BorderRadius.horizontal(right: Radius.circular(20)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.brown[400],
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
