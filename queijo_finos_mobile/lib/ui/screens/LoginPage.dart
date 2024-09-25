import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  Future<void> _login() async {
    String login = _loginController.text;
    String senha = _senhaController.text;

    if (login.isNotEmpty && senha.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      print('Preencha os campos de login e senha.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // Envolvendo o conteúdo em um SingleChildScrollView
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: const Color(0xFFF6F3F1),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(
                            16.0), // Adicionando padding para garantir espaço
                        child: Text(
                          "Queijos Finos",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize:
                                40.0, // Diminuindo o tamanho do texto para caber na tela
                            color: Color(0xFF9D8E61),
                            fontFamily: 'Bellefair',
                          ),
                          textAlign: TextAlign.center, // Centralizando o texto
                        ),
                      ),
                      Image.asset(
                        'assets/images/seloQJF.png',
                        width: 300,
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(
                      16.0), // Adicionando padding ao redor do texto
                  child: Text(
                    'Login',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _loginController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Login',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _senhaController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Senha',
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                  value: false, onChanged: (bool? value) {}),
                              const Text(
                                'Lembrar-me',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/recuperar-senha');
                            },
                            child: const Text(
                              'Esqueceu a senha?',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Color(0xFF9D8E61),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 70,
                              vertical:
                                  12), // Garantir que o botão tenha espaçamento correto
                          backgroundColor: const Color(0xFF0D2434),
                        ),
                        onPressed: _login,
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: const Color(0xFF0D2434),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          Image.asset('assets/images/logoBPK.png'),
                          const Text(
                            '© Copyright 2024',
                            style:
                                TextStyle(color: Colors.white, fontSize: 10.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
