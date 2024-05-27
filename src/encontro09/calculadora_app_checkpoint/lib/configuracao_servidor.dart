// configuracao_servidor.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class configuracao_servidor extends StatefulWidget {
  const configuracao_servidor({super.key});

  @override
  State<configuracao_servidor> createState() => _configuracao_servidorState();
}

class _configuracao_servidorState extends State<configuracao_servidor> {
  final TextEditingController _controller = TextEditingController();
  String _url = '';

  Future<void> recuperarUrl() async{
    // Recupera a instância do SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    // Recupera o valor da chave 'serverUrl'
    _url = prefs.getString('serverUrl') ?? '';
    setState(() {
      _controller.text = _url;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recuperarUrl();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Configuração do Servidor'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'URL do Servidor',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Salva a URL no SharedPreferences
                final prefs = await SharedPreferences.getInstance();
                _url = _controller.text;
                prefs.setString('serverUrl', _url);
                // Exibe um SnackBar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('URL do servidor salva com sucesso!'),
                  ),
                );
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      )
    );
  }
}