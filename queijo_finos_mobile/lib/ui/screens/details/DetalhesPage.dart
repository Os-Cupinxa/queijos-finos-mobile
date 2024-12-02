import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Importa o pacote
import '../../../models/ProprietyDTO.dart';

class DetalhesPage extends StatelessWidget {
  const DetalhesPage({Key? key, required this.item}) : super(key: key);
  final ProprietyDTO item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200),
                      border:
                          Border.all(color: const Color(0xFF8C8C8C), width: 8),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(Icons.person,
                          size: 150, color: Color(0xFF8C8C8C)),
                    ))),
            const SizedBox(height: 20),
            Text(item.name,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(item.onwer,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey)),
            const SizedBox(height: 16),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.location_on, color: Colors.grey, size: 28),
                ),
                Text('${item.city} - ${item.state}',
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _openMap(item.latitude, item.longitude),
                  icon: const Icon(Icons.location_on, color: Color(0xFF0D2434)),
                  label: const Text(
                    'Localização no mapa',
                    style: TextStyle(
                      color: Color(0xFF0D2434),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(item.status == 1 ? 'Produzindo' : 'Parado',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 234, 234, 234),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text('Contratos Ativos:',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: item.contractsActive.length,
                itemBuilder: (context, index) {
                  final contract = item.contractsActive[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black),
                            children: [
                              const TextSpan(
                                  text: 'Contrato de ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal)),
                              TextSpan(
                                  text: contract.tecnologia,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                          children: [
                            const TextSpan(
                                text: 'Contrato emitido dia ',
                                style:
                                    TextStyle(fontWeight: FontWeight.normal)),
                            TextSpan(
                                text: dateFormatted(contract.dataInicio),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const TextSpan(
                                text:
                                    ' com data de vencimento prevista para dia ',
                                style:
                                    TextStyle(fontWeight: FontWeight.normal)),
                            TextSpan(
                                text: dateFormatted(contract.dataFim),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFE0E0E0),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text('Tecnologias:',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
                child: ListView.builder(
                    itemCount: item.tecnologiasList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black),
                                children: [
                                  const TextSpan(
                                      text: 'Tecnologia ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal)),
                                  TextSpan(
                                      text: item.tecnologiasList[index].nome,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          const Divider(),
                        ],
                      );
                    }))
          ],
        ),
      ),
    );
  }

  void _openMap(String latitude, String longitude) async {
    final Uri url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

String dateFormatted(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}
