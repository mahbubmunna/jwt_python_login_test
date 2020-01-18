import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              var shredPref = await SharedPreferences.getInstance();
              var accessToken = shredPref.getString('access_token');

              if (!(accessToken == null || accessToken == '') ){
                shredPref.setString('access_token', '');
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
      drawer: Drawer(),

    );
  }
}
