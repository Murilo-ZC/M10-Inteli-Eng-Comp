import 'dart:convert';

import 'package:calculadora_app/display.dart';
import 'package:calculadora_app/keypad.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:http/http.dart' as http;

class MinhaCalculadora extends StatefulWidget {
  const MinhaCalculadora({super.key});

  @override
  State<MinhaCalculadora> createState() => _MinhaCalculadoraState();
}

class _MinhaCalculadoraState extends State<MinhaCalculadora> {
  String userData = '0';
  String result = "";

  void appendUserData(String data) {
    setState(() {
      userData += data;
    });
  }

  void setUserData(String data){
    setState(() {
      userData = data;
    });
  }

  bool checkIfZero(){
    if (userData == '0'){
      return true;
    }
    return false;
  }

  bool checkIfContainsDot(){
    if (userData.contains('.')){
      return true;
    }
    return false;
  }

  void removeLast(){
    if (userData.length > 1){
      setState(() {
        userData = userData.substring(0, userData.length - 1);
      });
    } else {
      setState(() {
        userData = '0';
      });
    }
  }

  bool checkIfOperation(){
    if (userData[userData.length - 1] == '+' || userData[userData.length - 1] == '-' || userData[userData.length - 1] == 'x' || userData[userData.length - 1] == '/'){
      return true;
    }
    return false;
  }

  void setResult(String data){
    setState(() {
      result = data;
    });
  }

  String avaliarExpressao(){
    String finaluserinput = userData;
    finaluserinput = finaluserinput.replaceAll('x', '*');
 
    Parser p = Parser();
    Expression exp = p.parse(finaluserinput);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    return eval.toString();
  }

  Future<String> avaliarExpressaoServidor() async{
    String finaluserinput = userData;
    finaluserinput = finaluserinput.replaceAll('x', '*');
    print({"expressao":"$finaluserinput"});
    // Realiza a requisição utilizando o http
    // O servidor deve estar rodando para que a requisição funcione
    var resultado = await http.post(Uri.http("10.152.0.144:8000", "/evaluate"), body: {'expressao':'$finaluserinput'});
    print(resultado.body);
    var saida = jsonDecode(resultado.body) as Map;
    return saida["resultado"];
  }
  // Array com os botões da calculadora
  // A lista foi dividida em 4 linhas
  List<Map> buttons = [];

  void init_list(){
    buttons = [
    {'text': '7', 'backcolor': Colors.black, 'textcolor': Colors.white, "action":(){if (checkIfZero()) setUserData('7'); else appendUserData('7');}},
    {'text': '8', 'backcolor': Colors.black, 'textcolor': Colors.white, "action":(){if (checkIfZero()) setUserData('8'); else appendUserData('8');}},
    {'text': '9', 'backcolor': Colors.black, 'textcolor': Colors.white, "action":(){if (checkIfZero()) setUserData('9'); else appendUserData('9');}},
    {'text': '/', 'backcolor': Colors.orange, 'textcolor': Colors.white, "action":(){if(!checkIfOperation()) appendUserData('/');}},
    {'text': '4', 'backcolor': Colors.black, 'textcolor': Colors.white, "action":(){if (checkIfZero()) setUserData('4'); else appendUserData('4');}},
    {'text': '5', 'backcolor': Colors.black, 'textcolor': Colors.white, "action":(){if (checkIfZero()) setUserData('5'); else appendUserData('5');}},
    {'text': '6', 'backcolor': Colors.black, 'textcolor': Colors.white, "action":(){if (checkIfZero()) setUserData('6'); else appendUserData('6');}},
    {'text': 'x', 'backcolor': Colors.orange, 'textcolor': Colors.white, "action":(){if(!checkIfOperation()) appendUserData('x');}},
    {'text': '1', 'backcolor': Colors.black, 'textcolor': Colors.white, "action":(){if (checkIfZero()) setUserData('1'); else appendUserData('1');}},
    {'text': '2', 'backcolor': Colors.black, 'textcolor': Colors.white, "action":(){if (checkIfZero()) setUserData('2'); else appendUserData('2');}},
    {'text': '3', 'backcolor': Colors.black, 'textcolor': Colors.white, "action":(){if (checkIfZero()) setUserData('3'); else appendUserData('3');}},
    {'text': '-', 'backcolor': Colors.orange, 'textcolor': Colors.white, "action":(){if(!checkIfOperation()) appendUserData('-');}},
    {'text': '.', 'backcolor': Colors.black, 'textcolor': Colors.white, "action":(){if (!checkIfContainsDot()) appendUserData('.');}},
    {'text': '0', 'backcolor': Colors.black, 'textcolor': Colors.white, "action":(){if (!checkIfZero()) appendUserData('0');}},
    {'text': 'C', 'backcolor': Colors.red, 'textcolor': Colors.white, "action":(){setUserData('0'); setResult("0");}},
    {'text': '+', 'backcolor': Colors.orange, 'textcolor': Colors.white, "action":(){if(!checkIfOperation()) appendUserData('+');}},
    {'text': '=', 'backcolor': Colors.orange, 'textcolor': Colors.white, "action": (){setResult(avaliarExpressao()); setUserData("0");}},
    {'text': 'DEL', 'backcolor': Colors.red, 'textcolor': Colors.white, "action":(){removeLast();}},
    {'text': '⚙️', 'backcolor': Colors.blue, 'textcolor': Colors.white},
    {'text': '😁', 'backcolor': Colors.blue, 'textcolor': Colors.white, "action":()async{setResult(await avaliarExpressaoServidor()); setUserData("0");}},
  ];
  }

  @override
  Widget build(BuildContext context) {
    init_list();
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


