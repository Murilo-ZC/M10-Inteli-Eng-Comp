---
sidebar_position: 3
title: Aprimorando o Layout
---

import useBaseUrl from '@docusaurus/useBaseUrl';
import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

## Continuando a construção do aplicativo

Até aqui pessoal, nossa calculadora básica depende da inserção dos valores manualmente. Vimos que o usuário pode inserir um valor inválido e a aplicação não consegue tratar isso. Vamos modificar nosso layout agora. Vamos adicionar botões para que o usuário possa inserir os valores e as operações. Vamos adicionar botões para as operações de soma, subtração, multiplicação e divisão. Além de um botão que irá realizar a operação e outro que irá limpar a tela.

Vamos começar modificando o arquivo `main.dart`:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MinhaCalculadora(),
    );
  }
}

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
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.centerRight,
                  child: Text(
                    result,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  alignment: Alignment.centerRight,
                  child: Text(
                    userData,
                    style: const TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Cria o campo para exibir as teclas para o usuário
          Expanded(
            flex: 3,
            child: GridView.builder(
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemBuilder: (BuildContext context, int index) {
                // Cria um botão
                return GestureDetector(
                  onTap: (){},
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        color: Colors.white70,
                        child: Center(
                          child: Text(
                            buttons[index],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

```