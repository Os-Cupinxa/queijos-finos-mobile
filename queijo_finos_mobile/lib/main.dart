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
          return createRoute(LoginPage());
        }

        switch (settings.name) {
          case '/login':
            return createRoute(LoginPage());
          case '/agenda':
            return createRoute(AuthenticatedLayout(
              selectedIndex: 1,
            ));
          case '/produtores':
            return createRoute(AuthenticatedLayout(
              selectedIndex: 2,
            ));
          case '/dashboard':
            return createRoute(AuthenticatedLayout(
              selectedIndex: 0,
            ));
          default:
            return createRoute(LoginPage());
        }
      },
    );
  }
}

// Função para criar rota com animação de transição personalizada
Route createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

class AuthenticatedLayout extends StatefulWidget {
  final int selectedIndex;

  const AuthenticatedLayout({required this.selectedIndex});

  @override
  _AuthenticatedLayoutState createState() => _AuthenticatedLayoutState();
}

class _AuthenticatedLayoutState extends State<AuthenticatedLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardPage(),
    AgendaPage(),
    ProdutoresPage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D2434),
        title: const Hero(
          tag: 'appBarTitle',
          child: Text(
            'QUEIJOS FINOS',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Bellefair',
              fontSize: 24.0,
            ),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0D2434),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        currentIndex: _selectedIndex,
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
        onTap: _onItemTapped,
      ),
    );
  }
}
