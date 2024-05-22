import 'package:calculadora_app/display.dart';
import 'package:calculadora_app/keypad.dart';
import 'package:flutter/material.dart';

class MinhaCalculadora extends StatefulWidget {
  const MinhaCalculadora({super.key});

  @override
  State<MinhaCalculadora> createState() => _MinhaCalculadoraState();
}

class _MinhaCalculadoraState extends State<MinhaCalculadora> {
  String userData = '';
  String result = "";

  // Array com os botões da calculadora
  // A lista foi dividida em 4 linhas
  List<String> buttons = [
    '7',
    '8',
    '9',
    '/',
    '4',
    '5',
    '6',
    'x',
    '1',
    '2',
    '3',
    '-',
    '.',
    '0',
    'C',
    '+',
    '=',
    'DEL',
    '⚙️',
    '😁',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora Flutter'),
      ),
      backgroundColor: Colors.white38,
      body: Column(
        children: <Widget>[
          // Cria o campo para exibir os dados digitados
          Display(result: result, userData: userData),
          // Cria o campo para exibir as teclas para o usuário
          Keypad(buttons: buttons),
        ],
      ),
    );
  }
}


