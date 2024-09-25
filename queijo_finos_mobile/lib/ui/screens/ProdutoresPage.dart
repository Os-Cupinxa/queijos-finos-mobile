import 'package:flutter/material.dart';

class ProprietyDTO {
  final String name;
  final String onwer;
  final String city;
  final String state;
  final Status status;

  ProprietyDTO({
    required this.name,
    required this.onwer,
    required this.city,
    required this.state,
    required this.status,
  });
}

enum Status { PRODUZINDO, PARADO }

class ProdutoresPage extends StatelessWidget {
  final List<ProprietyDTO> _proprietes = [
    ProprietyDTO(
      name: 'Fazenda Boa Vista',
      onwer: 'José da Silva',
      city: 'São Paulo',
      state: 'SP',
      status: Status.PRODUZINDO,
    ),
    ProprietyDTO(
      name: 'Fazenda São José',
      onwer: 'Maria de Souza',
      city: 'São Paulo',
      state: 'SP',
      status: Status.PRODUZINDO,
    ),
    ProprietyDTO(
      name: 'Fazenda Esperança',
      onwer: 'João Pereira',
      city: 'São Paulo',
      state: 'SP',
      status: Status.PARADO,
    ),
  ];

  @override
  final TextEditingController _searchController = TextEditingController();

  Future<void> _search() async {
    String search = _searchController.text;

    if (search.isNotEmpty) {
      print('Pesquisando produtores com o termo: $search');
    } else {
      print('Preencha o campo de pesquisa.');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              color: Colors.white,
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Pesquisar produtores',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(16.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _proprietes.length,
                    itemBuilder: (context, index) {
                      final item = _proprietes[index];

                      return Padding(
                        padding: const EdgeInsets.only(
                            right: 4.0, left: 4.0, bottom: 16.0),
                        child: Container(
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F2F2),
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(item.name,
                                            style: const TextStyle(
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(item.city + ' - ' + item.state,
                                            style: const TextStyle(
                                                fontSize: 16.0,
                                                color: Color(0xFF8C8C8C))),
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.location_on,
                                          color: Color(0xFF8C8C8C),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.person_pin,
                                        color: Colors
                                            .grey), 
                                    const SizedBox(width: 8),
                                    Text(item.onwer,
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            color: Color(0xFF8C8C8C))),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                            item.status == Status.PRODUZINDO
                                                ? Icons.play_arrow
                                                : Icons.pause,
                                            color: Color(0xFF8C8C8C)),
                                        SizedBox(width: 8),
                                        Text(
                                          item.status == Status.PRODUZINDO
                                              ? 'Produzindo'
                                              : 'Parado',
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              color: Color(0xFF8C8C8C)),
                                        ),
                                      ],
                                    ),
                                    OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                        color: Color(0xFF79747E),
                                        width: 2.0,
                                      )),
                                      icon: const Icon(
                                          Icons.arrow_right_outlined,
                                          color: Color(0xFF79747E),
                                          size: 24.0),
                                      onPressed: () {
                                        print('Ver detalhes do produtor');
                                      },
                                      label: const Text(
                                        'Ver Mais',
                                        style: TextStyle(
                                            color: Color(0xFF79747E),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
