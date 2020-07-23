import 'package:flutter/material.dart';

import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'nav-drawer.dart';

class Prdtscan extends StatefulWidget {
  @override
  _PrdtscanState createState() => _PrdtscanState();
}

class _PrdtscanState extends State<Prdtscan> {
  int _cameraOcr = FlutterMobileVision.CAMERA_BACK;
  bool _autoFocusOcr = true;
  bool _torchOcr = false;
  bool _multipleOcr = false;
  bool _waitTapOcr = true;
  bool _showTextOcr = true;
  Size _previewOcr;
  List<OcrText> _textsOcr = [];

  List<DropdownMenuItem<int>> _getCameras() {
    List<DropdownMenuItem<int>> cameraItems = [];

    cameraItems.add(DropdownMenuItem(
      child: Text('BACK'),
      value: FlutterMobileVision.CAMERA_BACK,
    ));

    cameraItems.add(DropdownMenuItem(
      child: Text('FRONT'),
      value: FlutterMobileVision.CAMERA_FRONT,
    ));

    return cameraItems;
  }

  Future<Null> _read() async {
    List<OcrText> texts = [];
    try {
      texts = await FlutterMobileVision.read(
        flash: _torchOcr,
        autoFocus: _autoFocusOcr,
        multiple: _multipleOcr,
        waitTap: _waitTapOcr,
        showText: _showTextOcr,
        preview: _previewOcr,
        camera: _cameraOcr,
        fps: 2.0,
      );
    } on Exception {
      texts.add(OcrText('Failed to recognize text.'));
    }

    if (!mounted) return;

    setState(() => {
          _textsOcr = texts,
          if (_textsOcr.length > 0) txt1.text = _textsOcr[0].value
        });
  }

  Future<List<Prdt>> _fetchdata() async {
    var prdtindex = txt1.text.toLowerCase().indexOf('prdt:');
    if (prdtindex > -1) {
      txt1.text = txt1.text.substring(prdtindex + 5).replaceAll(' ', '');
    }

    if (txt1.text.length > 11) txt1.text = txt1.text.substring(0, 11);

    final jobsListAPIUrl =
        'http://183.89.221.25:8080/PrdtDetail?PRDT=' + txt1.text;
    var response;
    try {
      response = await http.get(jobsListAPIUrl);
    } catch (e) {
      throw Exception(e.toString());
    }

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => new Prdt.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  @override
  void initState() {
    super.initState();
    FlutterMobileVision.start().then((previewSizes) => setState(() {
          _previewOcr = previewSizes[_cameraOcr].first;
        }));
  }

  final txt1 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.lightBlue[800],
          accentColor: Colors.cyan[600],
          textTheme: TextTheme(
              bodyText2: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan))),
      home: Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Text('Prdt Detail'),
        ),
        body: Column(
          children: <Widget>[
            new Container(
                margin: const EdgeInsets.symmetric(horizontal: 50.0),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: txt1,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: _read,
                  child: Text('Camera'),
                ),
                SizedBox(
                  width: 20,
                ),
                RaisedButton(
                  onPressed: () async {
                    setState(() {});
                  },
                  child: Text('Show'),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            FutureBuilder<List<Prdt>>(
                future: _fetchdata(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Prdt> data = snapshot.data;
//data.where((e) => e.allWorktime == 0).toList()

                    if (data.length > 0) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("name=${data[0].pEname}",
                              style: Theme.of(context).textTheme.bodyText2),
                          Text("Thai=${data[0].pTname}",
                              style: Theme.of(context).textTheme.bodyText2),
                          Text("spec=${data[0].pSpec}",
                              style: Theme.of(context).textTheme.bodyText2),
                          Text("BAL_BOI=${data[0].pBalboi}",
                              style: Theme.of(context).textTheme.bodyText2),
                          Text("BAL_TAX=${data[0].pBal}",
                              style: Theme.of(context).textTheme.bodyText2)
                        ],
                      );
                    } else
                      return Text("");
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else {
                    return SizedBox(
                      width: 10,
                      height: 10,
                      child: CircularProgressIndicator(),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}

class Prdt {
  String pPrdt;
  String pEname;
  String pTname;
  String pSpec;
  double pBal;
  double pBalboi;
  Null pMtnbal;

  Prdt(
      {this.pPrdt,
      this.pEname,
      this.pTname,
      this.pSpec,
      this.pBal,
      this.pBalboi,
      this.pMtnbal});

  Prdt.fromJson(Map<String, dynamic> json) {
    pPrdt = json['p_prdt'];
    pEname = json['p_ename'];
    pTname = json['p_tname'];
    pSpec = json['p_spec'];
    pBal = json['p_bal'];
    pBalboi = json['bal_boi'];
    pMtnbal = json['p_mtnbal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['p_prdt'] = this.pPrdt;
    data['p_ename'] = this.pEname;
    data['p_tname'] = this.pTname;
    data['p_spec'] = this.pSpec;
    data['p_bal'] = this.pBal;
    data['bal_boi'] = this.pBalboi;
    data['p_mtnbal'] = this.pMtnbal;
    return data;
  }
}
