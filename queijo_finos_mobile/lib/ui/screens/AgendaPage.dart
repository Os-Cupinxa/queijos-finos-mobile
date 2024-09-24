import 'package:flutter/material.dart';

// Classe que representa cada item da agenda (contrato ou visita)
class AgendaItem {
  final String nome;
  final String descricao;
  final String data;
  final String tipo; // 'contrato' ou 'visita'

  AgendaItem({
    required this.nome,
    required this.descricao,
    required this.data,
    required this.tipo,
  });
}

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  _AgendaPageState createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  final List<AgendaItem> agendaItems = [
    AgendaItem(
      nome: 'Claudio Arruda',
      descricao: 'Tecnologia Gorgonzola',
      data: '11/09/2024',
      tipo: 'contrato',
    ),
    AgendaItem(
      nome: 'Pedro Roberto Ferreira',
      descricao: '',
      data: '05/09/2024',
      tipo: 'visita',
    ),
    AgendaItem(
      nome: 'Izaura Nunes de Visconde',
      descricao: 'Tecnologia Gorgonzola',
      data: '11/09/2024',
      tipo: 'contrato',
    ),
  ];

  String selectedFilter = 'todos';

  List<AgendaItem> _filteredItems() {
    if (selectedFilter == 'contratos') {
      return agendaItems.where((item) => item.tipo == 'contrato').toList();
    } else if (selectedFilter == 'visitas') {
      return agendaItems.where((item) => item.tipo == 'visita').toList();
    }
    return agendaItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                                  text: ' possui um ',
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: item.tipo == 'contrato'
                                      ? 'contrato de '
                                      : 'visita agendada para o dia ',
                                  style: const TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: item.descricao,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                if (item.tipo == 'contrato')
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
