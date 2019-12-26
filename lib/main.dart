import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';

import 'reapi.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // transparent status bar
          systemNavigationBarColor: Colors.black, // navigation bar color
          statusBarIconBrightness: Brightness.dark, // status bar icons' color
          systemNavigationBarIconBrightness: Brightness.dark, //navigation bar icons' color
        ),
        child: Scaffold(
          body: MyHomePage(title: 'Flutter Demo Home Page'),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextField username;
  TextField password;

  Future<http.Response> requestMethod() async {
    var username = "3845";
    var password = "--password--";
    var url = "https://reapistaging.altervista.org/api.php?uname=$username&password=$password";
    Map<String,String> headers = {
      'Accept': 'application/json',
    };
    final responseHTTP = await http.get(url, headers: headers);
    Map responseMap = jsonDecode(responseHTTP.body);
    var response = reAPI.fromJson(responseMap);
    if (response.status.code == 0){
      print(response.user.nome);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Errore durante il login"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0))),
            content: new Text(response.status.description),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new OutlineButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    return responseHTTP;
  }



  void buttonLogin(){
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    requestMethod();


  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Accedi a mySobrero',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22
              ),
            ),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'ID Studente'
              ),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),

            ),
            RaisedButton(
              onPressed: buttonLogin,
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              child: const Text(
                  'ACCEDI',
              ),
            ),

          ],
        ),
      ),
    );
  }
}
