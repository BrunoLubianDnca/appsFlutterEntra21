import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController pesoController = TextEditingController();
  TextEditingController alturaController = TextEditingController();
  String resultado = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
        backgroundColor: Colors.green, //
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/2.gif',
                  height: 300,fit:BoxFit.fill ,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(style: TextStyle(fontSize: 30,  ),'Informe seus dados'),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('IMC'),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: pesoController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Peso (kg)'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextField(
                        controller: alturaController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Altura (m)'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _calcularIMC,
                        child: const Text('Calcular'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  resultado,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _calcularIMC() {
    double peso = double.tryParse(pesoController.text) ?? 0;
    double altura = double.tryParse(alturaController.text) ?? 0;

    if (peso > 0 && altura > 0) {
      double imc = peso / (altura * altura);
      String classificacao = '';

      if (imc < 18.5) {
        classificacao = 'Abaixo do peso ❌';
      } else if (imc < 24.9) {
        classificacao = 'Peso normal✅';
      } else if (imc < 29.9) {
        classificacao = 'Sobrepeso ⚠';
      } else if (imc < 34.9) {
        classificacao = 'Obesidade Grau 1';
      } else if (imc < 39.9) {
        classificacao = 'Obesidade Grau 2';
      } else {
        classificacao = 'Obesidade Grau 3';
      }

      setState(() {
        resultado = 'IMC: ${imc.toStringAsFixed(2)}\n Classificação: $classificacao';
      });
    } else {
      setState(() {
        resultado = 'Informe os dados corretamente';
      });
    }
  }
}
