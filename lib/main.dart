import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_python_login_test/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _isLoading = false;
  void _tryLogin(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    var jsonTokenData;
    var tokenUrl = "http://192.168.0.116:8800/userApi/token/";
    var userInfoUrl = "http://192.168.0.116:8800/userApi/user/";
    var sharedPreferences = await SharedPreferences.getInstance();
    Map loginInfo = {'email': 'shanto@admin.com', 'password': '123'};


    var tokenResponse = await http.post(tokenUrl,
        headers: {'Content-type': 'application/x-www-form-urlencoded'},
        body: loginInfo);

    if (tokenResponse.statusCode == 200) {
      print(tokenResponse.body);

      jsonTokenData = json.decode(tokenResponse.body);
      sharedPreferences.setString('access_token', jsonTokenData['access']);

      print('access_token: ${sharedPreferences.getString('access_token')}');
    } else {
      print('didnt got the result ${tokenResponse.body}');
    }

    var newResponse = await http.get(
      userInfoUrl,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer ${sharedPreferences.getString('access_token')}"
      },
    );

    if (newResponse.statusCode == 200) {
      print(newResponse.body);

      setState(() {
        _isLoading = false;
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeScreen()));
      });
    } else {
      print('didnt got the result ${newResponse.body}');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Login test'),
      ),
      body: _isLoading ? CircularProgressIndicator() : Center(
        child: InkWell(
          child: RaisedButton(
            child: Text('LOGIN'),
            onPressed: () => _tryLogin(context),
          ),
        ),
      ),
    );
  }
}
