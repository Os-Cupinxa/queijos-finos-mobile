import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controladores para capturar login e senha
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  // Função para enviar dados para a API
  Future<void> _login() async {
    String login = _loginController.text;
    String senha = _senhaController.text;

    // Aqui você pode fazer uma requisição HTTP usando um pacote como 'http'
    // Exemplo:
    /*
    var response = await http.post(
      Uri.parse('https://sua-api.com/login'),
      body: {'login': login, 'senha': senha},
    );

    if (response.statusCode == 200) {
      // Sucesso, navegue para o dashboard ou faça outra ação
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      // Trate o erro
      print('Erro ao fazer login');
    }
    */

    // Por enquanto, apenas simula a navegação
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: const Color(0xFFF6F3F1),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 52.0,
                        color: Color(0xFF9D8E61),
                        fontFamily: 'Bellefair',
                      ),
                      "Queijos Finos",
                    ),
                    Image.asset(
                      'assets/images/seloQJF.png',
                      width: 300,
                    ),
                  ],
                ),
              ),
              const Text(
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w400),
                'Login',
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
                            Checkbox(value: false, onChanged: (bool? value) {}),
                            const Text(
                              style: TextStyle(fontSize: 16.0),
                              'Lembrar-me',
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/recuperar-senha');
                          },
                          child: const Text(
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Color(0xFF9D8E61),
                            ),
                            'Esqueceu a senha?',
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.only(left: 70, right: 70),
                        backgroundColor: const Color(0xFF0D2434),
                      ),
                      onPressed: _login,
                      child: const Text(
                        style: TextStyle(color: Colors.white),
                        'LOGIN',
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
                          style: TextStyle(color: Colors.white, fontSize: 10.0),
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
    );
  }
}
