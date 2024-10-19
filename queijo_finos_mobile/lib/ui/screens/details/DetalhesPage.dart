import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Importa o pacote
import '../../../models/ProprietyDTO.dart';

class DetalhesPage extends StatelessWidget {
  final ProprietyDTO item;

  const DetalhesPage({Key? key, required this.item}) : super(key: key);

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
            const Text("Contratos Ativos:",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),
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
                                  text: '${contract.tecnologia}',
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
                                text: '${dateFormatted(contract.dataInicio)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const TextSpan(
                                text:
                                    ' com data de vencimento prevista para dia ',
                                style:
                                    TextStyle(fontWeight: FontWeight.normal)),
                            TextSpan(
                                text: '${dateFormatted(contract.dataFim)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const Divider(),
                    ],
                  );
                },
              ),
            ),
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
