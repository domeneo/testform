import 'package:flutter/material.dart';
import 'nav-drawer.dart';

class MyApp3 extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

int v = 0;

class _MyAppState extends State<MyApp3> {
  void setv() {
    setState(() {
      v = int.parse(txt1.text) + int.parse(txt2.text);
    });
  }

  final txt1 = TextEditingController();
  final txt2 = TextEditingController();

  List<String> _number = ['1', '2', '3', '4', '5'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'test',
        home: Scaffold(
            drawer: NavDrawer(),
            appBar: AppBar(
              title: Text('test'),
            ),
            body: Column(
              children: <Widget>[
                dd1(),
                TextField(
                  controller: txt1,
                ),
                TextField(
                  controller: txt2,
                ),
                RaisedButton(
                  onPressed: setv,
                  child: Text('Button $v'),
                ),
                Text('$v')
              ],
            )));
  }

  DropdownButton<String> dd1() {
    return new DropdownButton<String>(
      onChanged: (newValue) {
        txt1.text = newValue;
      },
      items: _number.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
