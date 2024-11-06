import 'package:flutter/material.dart';
import 'package:queijo_finos_mobile/models/ActiveContracts.dart';
import 'package:queijo_finos_mobile/models/ProprietyDTO.dart';
import 'package:queijo_finos_mobile/ui/screens/details/DetalhesPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProdutoresPage extends StatefulWidget {
  const ProdutoresPage({super.key});

  @override
  _ProdutoresPageState createState() => _ProdutoresPageState();
}

class _ProdutoresPageState extends State<ProdutoresPage> {
  final List<ProprietyDTO> _proprieties = [];
  int _currentPage = 0;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _currentSearchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadMoreData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading) {
        _loadMoreData();
      }
    });
  }

  Future<void> _loadMoreData({String nameProducer = ""}) async {
    setState(() {
      _isLoading = true;
    });

    // Usa _currentPage diretamente
    final List<ProprietyDTO> newProprieties =
        await fetchProprieties(page: _currentPage, nameProducer: nameProducer);

    setState(() {
      _proprieties.addAll(newProprieties);
      _isLoading = false;
      _currentPage += 1;
    });
  }

  Future<List<ProprietyDTO>> fetchProprieties(
      {int page = 0, String nameProducer = ""}) async {
    var response = await http.get(
      Uri.parse(
          'http://10.0.2.2:8080/propriedadesDTO/producerName?nameProducer=$nameProducer&page=$page'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      return (data['content'] as List)
          .map((json) => ProprietyDTO(
                name: json['name'],
                city: json['city'],
                state: json['state'],
                onwer: json['owner'],
                latitude: json['latitude'],
                longitude: json['longitude'],
                status: json['status'],
                contractsActive: (json['contractsActive'] as List)
                    .map((contract) => ActiveContracts(
                          tecnologia: contract['nome'],
                          dataFim: DateTime(2022, 12, 31),
                          dataInicio: DateTime(2022, 12, 31),
                        ))
                    .toList(),
              ))
          .toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _searchProducers() {
    setState(() {
      _currentPage = 0;
      _proprieties.clear();
      _currentSearchQuery = _searchController.text;
    });
    _loadMoreData(nameProducer: _currentSearchQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Pesquisar produtores',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(16.0),
              ),
              onSubmitted: (value) {
                _searchProducers();
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _proprieties.length + 1,
              itemBuilder: (context, index) {
                if (index == _proprieties.length) {
                  return _isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox.shrink();
                }

                final item = _proprieties[index];

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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.name.length > 10
                                    ? '${item.name.substring(0, 10)}..'
                                    : item.name,
                                style: const TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Text('${item.city} - ${item.state}',
                                      style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Color(0xFF8C8C8C))),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.location_on,
                                      color: Color(0xFF8C8C8C)),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.person_pin, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(item.onwer,
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Color(0xFF8C8C8C))),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                      item.status == 1
                                          ? Icons.play_arrow
                                          : Icons.pause,
                                      color: const Color(0xFF8C8C8C)),
                                  const SizedBox(width: 8),
                                  Text(
                                    item.status == 1 ? 'Produzindo' : 'Parado',
                                    style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Color(0xFF8C8C8C)),
                                  ),
                                ],
                              ),
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: Color(0xFF79747E), width: 2.0)),
                                icon: const Icon(Icons.arrow_right_outlined,
                                    color: Color(0xFF79747E), size: 24.0),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetalhesPage(item: item),
                                    ),
                                  );
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
            ),
          ),
        ],
      ),
    );
  }
}
