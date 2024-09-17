import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bem-vindo ao Dashboard!'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/agenda');
              },
              child: Text('Ir para Agenda'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/produtores');
              },
              child: Text('Ir para Produtores'),
            ),
          ],
        ),
      ),
    );
  }
}