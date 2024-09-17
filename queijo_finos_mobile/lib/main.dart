import 'package:flutter/material.dart';
import 'package:queijo_finos_mobile/ui/screens/AgendaPage.dart';
import 'package:queijo_finos_mobile/ui/screens/DashboardPage.dart';
import 'package:queijo_finos_mobile/ui/screens/LoginPage.dart';
import 'package:queijo_finos_mobile/ui/screens/ProdutoresPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Simulação de autenticação
  bool isAuthenticated =
      false; // Altere isso para true quando o usuário estiver logado

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/dashboard' ||
            settings.name == '/agenda' ||
            settings.name == '/produtores') {
          // TODO - Implementar autenticação
          // if (!isAuthenticated) {
          //   return MaterialPageRoute(builder: (context) => LoginPage());
          // }
        }
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => LoginPage());
          case '/agenda':
            return MaterialPageRoute(builder: (context) => AgendaPage());
          case '/produtores':
            return MaterialPageRoute(builder: (context) => ProdutoresPage());
          case '/dashboard':
            return MaterialPageRoute(builder: (context) => DashboardPage());
          default:
            return MaterialPageRoute(builder: (context) => LoginPage());
        }
      },
    );
  }
}
