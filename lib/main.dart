import 'package:flutter/material.dart';
import 'nav-drawer.dart';
import 'package:intl/intl.dart';
//Custom widgets
import 'JobsListView.dart';

void main() {
  runApp(MaterialApp(home: App2()));
}

class App2 extends StatefulWidget {
  @override
  _App2State createState() => _App2State();
}

class _App2State extends State<App2> {
  @override
  void initState() {
    super.initState();
    dateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'dd',
        home: Scaffold(
          drawer: NavDrawer(),
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('Effiency'),
          ),
          body: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.10,
                child: Row(children: [
                  SizedBox(
                    width: 200,
                    child: showDate(context),
                  ),
                  Text(
                    'Dep: ',
                    style: TextStyle(color: Colors.cyan),
                  ),
                  dd1(),
                ]),
              ),
              SizedBox(
                  //height: MediaQuery.of(context).size.height * 0.8,
                  child: JobsListView()),
            ],
          )),
        ));
  }

  DropdownButton<String> dd1() {
    return DropdownButton<String>(
      value: dep,
      onChanged: (String newValue) {
        setState(() {
          dep = newValue;
        });
      },
      items: <String>['241', '242', '243', '244']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget showDate(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.date_range),
      title: Text('${DateFormat('yyyyMMdd').format(dateTime)}'),
      trailing: Icon(Icons.keyboard_arrow_down),
      onTap: () {
        chooseDate();
      },
    );
  }

  Future<void> chooseDate() async {
    DateTime chooseDateTime = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: dateTime,
    );

    if (chooseDateTime != null) {
      setState(() {
        dateTime = chooseDateTime;
      });
    }
  }
}
