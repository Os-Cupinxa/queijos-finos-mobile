import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:queijo_finos_mobile/models/AgendaItem.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  _AgendaPageState createState() => _AgendaPageState();
}

Future<int?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('userId');
}

class _AgendaPageState extends State<AgendaPage> {
  List<AgendaItem> agendaItems = [];
  String selectedFilter = 'todos';
  bool isLoading = true;

  // Método para buscar os dados da API
  Future<void> fetchAgendaItems() async {
    try {
      final response = await http.get(Uri.parse(
          'http://10.0.2.2:8080/agendaAndExpiringContracts?userId=${await getUserId()}'));

      if (response.statusCode == 200) {
        // Decodifica o corpo da resposta usando UTF-8
        String responseBody = utf8.decode(response.bodyBytes);
        // Parseando o JSON para uma lista de objetos AgendaItem
        List<dynamic> data = json.decode(responseBody);
        List<AgendaItem> fetchedItems =
            data.map((item) => AgendaItem.fromJson(item)).toList();

        setState(() {
          agendaItems = fetchedItems;
          isLoading = false;
        });
      } else {
        throw Exception('Falha ao carregar dados da agenda');
      }
    } catch (e) {
      print('Erro: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAgendaItems(); // Chama o método ao inicializar a página
  }

  List<AgendaItem> _filteredItems() {
    if (selectedFilter == 'contratos') {
      return agendaItems.where((item) => item.tipo == 'Contrato').toList();
    } else if (selectedFilter == 'visitas') {
      return agendaItems.where((item) => item.tipo == 'Visita').toList();
    }
    return agendaItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Exibe um loading enquanto carrega
          : Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFE0E0E0),
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildFilterButton('Todos', 'todos'),
                        _buildFilterButton('Visitas', 'visitas'),
                        _buildFilterButton('Contratos', 'contratos'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF6F3F1),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredItems().length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems()[index];

                        return Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFFE0E0E0),
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 16.0),
                                    children: [
                                      TextSpan(
                                        text: item.nome,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: ' possui uma ',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: item.tipo == 'Contrato'
                                            ? 'contrato de '
                                            : 'visita agendada para o dia ',
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      if (item.tipo == 'Contrato')
                                        TextSpan(
                                          text: item.descricao,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      if (item.tipo == 'Contrato')
                                        const TextSpan(
                                          text: ' para vencer dia ',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      TextSpan(
                                        text: item.data,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: '.',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              subtitle: Text(
                                item.data,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 14.0),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // Widget para construir cada botão de filtro
  Widget _buildFilterButton(String label, String filterType) {
    final bool isSelected = selectedFilter == filterType;
    return TextButton(
      onPressed: () {
        setState(() {
          selectedFilter = filterType;
        });
      },
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF9D8E61)
                  : const Color(0xFF697386),
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4.0),
              height: 2.0,
              width: 60.0,
              color: const Color(0xFF9D8E61),
            ),
        ],
      ),
    );
  }
}
