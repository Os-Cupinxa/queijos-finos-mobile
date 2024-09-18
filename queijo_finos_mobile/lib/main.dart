import 'package:flutter/material.dart';
import 'package:queijo_finos_mobile/ui/screens/AgendaPage.dart';
import 'package:queijo_finos_mobile/ui/screens/DashboardPage.dart';
import 'package:queijo_finos_mobile/ui/screens/LoginPage.dart';
import 'package:queijo_finos_mobile/ui/screens/ProdutoresPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool isAuthenticated = true; // Simulação de autenticação

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        if ((settings.name == '/dashboard' ||
                settings.name == '/agenda' ||
                settings.name == '/produtores') &&
            !isAuthenticated) {
          // Redirecionar para Login se não estiver autenticado
          return MaterialPageRoute(builder: (context) => LoginPage());
        }

        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (context) => LoginPage());
          case '/agenda':
            return MaterialPageRoute(
                builder: (context) => AuthenticatedLayout(
                      child: AgendaPage(),
                      selectedIndex: 1,
                    ));
          case '/produtores':
            return MaterialPageRoute(
                builder: (context) => AuthenticatedLayout(
                      child: ProdutoresPage(),
                      selectedIndex: 2,
                    ));
          case '/dashboard':
            return MaterialPageRoute(
                builder: (context) => AuthenticatedLayout(
                      child: DashboardPage(),
                      selectedIndex: 0,
                    ));
          default:
            return MaterialPageRoute(builder: (context) => LoginPage());
        }
      },
    );
  }
}

class AuthenticatedLayout extends StatelessWidget {
  final Widget child;
  final int selectedIndex;

  const AuthenticatedLayout({
    required this.child,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D2434),
        title: const Text(
          'Queijos Finos',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Bellefair',
            fontSize: 32.0,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0D2434),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        currentIndex: selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Agenda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Produtores',
          ),
        ],
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/dashboard');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/agenda');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/produtores');
              break;
          }
        },
      ),
    );
  }
}
