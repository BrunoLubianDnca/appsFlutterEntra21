import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _contador = 0;

  void _incrementarPessoa() {
    setState(() {
      if (_contador < 10) {
        _contador++;
      }
    });
  }

  void _decrementarPessoa() {
    setState(() {
      if (_contador > 0) {
        _contador--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Contador de Pessoas')),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/app.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Número de Pessoas:',
                style: TextStyle(color: Colors.white, fontSize: 36),
              ),
              Text(
                '$_contador',
                style: TextStyle(color: Colors.white, fontSize: 68),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: _decrementarPessoa,
            style: ElevatedButton.styleFrom(
              primary: _contador == 0 ? Colors.grey : Colors.blue,
            ),
            child: Icon(Icons.remove),
          ),
          SizedBox(width: 20.0),
          ElevatedButton(
            onPressed: _incrementarPessoa,
            style: ElevatedButton.styleFrom(
              primary: _contador == 10 ? Colors.red : Colors.blue,
            ),
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
