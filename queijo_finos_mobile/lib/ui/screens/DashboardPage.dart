import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http; // Adicionado para fazer requisições HTTP
import 'dart:convert'; // Para decodificar JSON
import 'package:queijo_finos_mobile/models/DataInsight.dart';
import 'package:queijo_finos_mobile/ui/components/charts/LineChartSample2.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Importado para formatar datas, caso necessário

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isWeekly = true;
  late DataInsight insightData =
      DataInsight(active: 0, activeInContemplation: 0, dropout: 0);
  late DataPoint weeklyData = DataPoint(curData: [], pastData: [], time: []);
  late DataPoint monthlyData = DataPoint(curData: [], pastData: [], time: []);
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData(); // Buscar dados ao iniciar a página
  }

  // Função para buscar dados da API
  Future<void> fetchData() async {
    try {
      // Recupera o token JWT do SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token não encontrado. Faça login novamente.');
      }

      // Headers com o token JWT
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final futures = [
        http.get(Uri.parse('http://10.0.2.2:8080/dataInsight'),
            headers: headers),
        http.get(Uri.parse('http://10.0.2.2:8080/dataPoint'), headers: headers),
        http.get(Uri.parse('http://10.0.2.2:8080/dataPointYear'),
            headers: headers),
      ];

      // Aguarda a conclusão de todas as requisições
      final responses = await Future.wait(futures);

      // Agora você pode acessar cada resposta pela lista `responses`
      final insightResponse = responses[0];
      final weeklyResponse = responses[1];
      final monthlyResponse = responses[2];

      if (insightResponse.statusCode == 200 &&
          weeklyResponse.statusCode == 200 &&
          monthlyResponse.statusCode == 200) {
        final insightJson = json.decode(insightResponse.body);
        final weeklyJson = json.decode(weeklyResponse.body);
        final monthlyJson = json.decode(monthlyResponse.body);

        setState(() {
          // Atualizando o estado com os dados recebidos
          insightData = DataInsight(
            active: insightJson['active'],
            activeInContemplation: insightJson['activeInContemplation'],
            dropout: insightJson['dropout'],
          );

          weeklyData = DataPoint(
            curData: List<double>.from(weeklyJson['curData']),
            pastData: List<double>.from(weeklyJson['pastData']),
            time: List<String>.from(weeklyJson['timeCurWeek']),
          );

          monthlyData = DataPoint(
            curData: List<double>.from(monthlyJson['curYear']),
            pastData: List<double>.from(monthlyJson['pastYear']),
            time: List<String>.from(monthlyJson['time']),
          );

          isLoading = false; // Dados carregados
        });
      } else {
        throw Exception('Erro ao buscar os dados.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erro ao buscar dados: $e'); // Para depuração
    }
  }

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
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Exibir um loading enquanto os dados são buscados
          : Center(
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
                          const Text(
                            'Quantidade de produção (p/L)',
                            style: TextStyle(
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
                                    label: 'Semanal',
                                    isSelected: isWeekly,
                                    onTap: () =>
                                        setState(() => isWeekly = true),
                                  ),
                                  _buildToggleButton(
                                    label: 'Mensal',
                                    isSelected: !isWeekly,
                                    onTap: () =>
                                        setState(() => isWeekly = false),
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
                      offset: const Offset(0, -30),
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
                              'Insights',
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            const Text(
                              'Quantidade de propriedades por status',
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
                                  buildInsightRow(
                                      'Ativos',
                                      insightData.active,
                                      insightData
                                          .calculatePercentages()['active']!),
                                  buildInsightRow(
                                      'Ativos em contemplação',
                                      insightData.activeInContemplation,
                                      insightData.calculatePercentages()[
                                          'activeInContemplation']!),
                                  buildInsightRow(
                                      'Desistentes',
                                      insightData.dropout,
                                      insightData
                                          .calculatePercentages()['dropout']!),
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

  Widget buildInsightRow(String label, int value, double percentage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(getFormattedDate(),
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                ))
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '$value', // Usando dados da API
              style: const TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%', // Porcentagem
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            )
          ],
        )
      ],
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
          borderRadius: 'Semanal' == label
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
