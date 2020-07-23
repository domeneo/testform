import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Job {
  String eDEP;
  String ePCODE;
  String eName;
  double allWorktime;
  double allSTDworktime;
  double worktime;
  double nONWORKA;
  double nONWORKB;
  double sTDNONWORK;
  double sTDWork;
  String eFF;

  Job(
      {this.eDEP,
      this.ePCODE,
      this.eName,
      this.allWorktime,
      this.allSTDworktime,
      this.worktime,
      this.nONWORKA,
      this.nONWORKB,
      this.sTDNONWORK,
      this.sTDWork,
      this.eFF});

  Job.fromJson(Map<String, dynamic> json) {
    eDEP = json['E_DEP'];
    ePCODE = json['E_PCODE'];
    eName = json['e_name'];
    allWorktime = json['AllWorktime'];
    allSTDworktime = json['AllSTDworktime'];
    worktime = json['Worktime'];
    nONWORKA = json['NONWORKA'];
    nONWORKB = json['NONWORKB'];
    sTDNONWORK = json['STDNONWORK'];
    sTDWork = json['STDWork'];
    eFF = json['EFF'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['E_DEP'] = this.eDEP;
    data['E_PCODE'] = this.ePCODE;
    data['e_name'] = this.eName;
    data['AllWorktime'] = this.allWorktime;
    data['AllSTDworktime'] = this.allSTDworktime;
    data['Worktime'] = this.worktime;
    data['NONWORKA'] = this.nONWORKA;
    data['NONWORKB'] = this.nONWORKB;
    data['STDNONWORK'] = this.sTDNONWORK;
    data['STDWork'] = this.sTDWork;
    data['EFF'] = this.eFF;
    return data;
  }
}

String dep = '241';
DateTime dateTime;

class JobsListView extends StatefulWidget {
  @override
  _JobsListView createState() => _JobsListView();
}

class _JobsListView extends State {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Job>>(
      future: _fetchJobs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Job> data = snapshot.data;
//data.where((e) => e.allWorktime == 0).toList()
          return _jobsListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else {
          return SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<List<Job>> _fetchJobs() async {
    final jobsListAPIUrl =
        'http://183.89.221.25:8080/efflist?fromdate=${DateFormat('yyyyMMdd').format(dateTime)}&todate=${DateFormat('yyyyMMdd').format(dateTime)}&dep=' +
            dep;

    var response;
    try {
      response = await http.get(jobsListAPIUrl);
    } catch (e) {
      throw Exception(e.toString());
    }

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => new Job.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  var f = new NumberFormat("###.0#", "en_US");

  SingleChildScrollView _jobsListView(data) {
    return SingleChildScrollView(
        child: SizedBox(
            height: 500,
            child: new RefreshIndicator(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return _tile(
                        data[index].ePCODE + ' ' + data[index].eName,
                        'worktime:' +
                            NumberFormat("##").format(data[index].allWorktime) +
                            ' stdwork:' +
                            f.format(data[index].sTDWork).toString() +
                            ' eff:' +
                            f
                                .format(double.parse(data[index].eFF) ?? 0)
                                .toString(),
                        Icons.work);
                  }),
              onRefresh: () async {
                setState(() {});
              },
            )));
  }

  ListTile _tile(String title, String subtitle, IconData icon) => ListTile(
        title: Text(title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            )),
        subtitle: Text(subtitle),
        leading: Icon(
          icon,
          color: Colors.blue[500],
        ),
      );
}
