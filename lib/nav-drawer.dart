import 'package:flutter/material.dart';
import 'main.dart';
import 'main3.dart';
import 'RefreshInd.dart';
import 'prdtScan.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Side menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/cover.jpg'))),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Welcome'),
            onTap: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => App2())),
            },
          ),
          ListTile(
              leading: Icon(Icons.verified_user),
              title: Text('Profile'),
              onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyApp3())),
                  }),
          ListTile(
            leading: Icon(Icons.web_asset),
            title: Text('RefreshIndicatorTest'),
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RefreshIND())),
            },
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('PRDTscan'),
            onTap: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Prdtscan())),
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}
