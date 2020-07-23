import 'dart:async';

import 'package:flutter/material.dart';
import 'nav-drawer.dart';

void main() => runApp(new RefreshIND());

class RefreshIND extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: NavDrawer(),
      appBar: new AppBar(
        title: new Text("Home Page"),
      ),
      body: new RefreshIndicator(
        child: new ListView(
          children: _getItems(),
        ),
        onRefresh: _handleRefresh,
      ),
    );
  }

  List<Widget> _getItems() {
    var items = <Widget>[];
    for (int i = _count; i < _count + 4; i++) {
      var item = new Column(
        children: <Widget>[
          new ListTile(
            title: new Text("Item $i"),
          ),
          new Divider(
            height: 2.0,
          )
        ],
      );

      items.add(item);
    }
    return items;
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 3));

    setState(() {
      _count += 5;
    });

    return null;
  }
}
