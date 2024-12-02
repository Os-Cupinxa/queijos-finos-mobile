import 'package:flutter/material.dart';
import 'package:queijo_finos_mobile/ui/screens/AgendaPage.dart';
import 'package:queijo_finos_mobile/ui/screens/DashboardPage.dart';
import 'package:queijo_finos_mobile/ui/screens/LoginPage.dart';
import 'package:queijo_finos_mobile/ui/screens/ProdutoresPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Erro ao carregar o arquivo .env: $e");
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isAuthenticated = false;

  Future<void> checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    setState(() {
      isAuthenticated = token != null;
    });
  }

  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      initialRoute: isAuthenticated ? '/dashboard' : '/login',
      onGenerateRoute: (settings) {
        if ((settings.name == '/dashboard' ||
                settings.name == '/agenda' ||
                settings.name == '/produtores') &&
            !isAuthenticated) {
          // Redirecionar para Login se não estiver autenticado
          return createRoute(const LoginPage());
        }

        switch (settings.name) {
          case '/login':
            return createRoute(const LoginPage());
          case '/agenda':
            return createRoute(const AuthenticatedLayout(
              selectedIndex: 1,
            ));
          case '/produtores':
            return createRoute(const AuthenticatedLayout(
              selectedIndex: 2,
            ));
          case '/dashboard':
            return createRoute(const AuthenticatedLayout(
              selectedIndex: 0,
            ));
          default:
            return createRoute(const LoginPage());
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
  const AuthenticatedLayout({super.key, required this.selectedIndex});
  final int selectedIndex;

  @override
  _AuthenticatedLayoutState createState() => _AuthenticatedLayoutState();
}

class _AuthenticatedLayoutState extends State<AuthenticatedLayout> {
  int _selectedIndex = 0;

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

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const DashboardPage();
      case 1:
        return const AgendaPage();
      case 2:
        return const ProdutoresPage();
      default:
        return const DashboardPage();
    }
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
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _getPage(_selectedIndex),
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
