import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:mysobrero/ColorLoader5.dart';
import 'package:mysobrero/home.dart';
import 'dart:convert';
import 'reapi.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.orange,
        brightness: Brightness.dark,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF0360e7),
        accentColor: Color(0xFF0360e7),
        backgroundColor: Color(0xFF000000)
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
          body: AppLogin(title: 'mySobrero'),
        ),
      ),
    );
  }
}

class AppLogin extends StatefulWidget {
  AppLogin({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AppLoginState createState() => _AppLoginState();
}

class _AppLoginState extends State<AppLogin> {

  final userController = TextEditingController();
  final pwrdController = TextEditingController();

  final Shader sobreroGradient = LinearGradient(
    begin: FractionalOffset.topRight,
    end: FractionalOffset.bottomRight,
    colors: <Color>[Color(0xFF0287d1), Color(0xFF0335ff)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 30.0));

  var isLoginVisible = true;

  Future<http.Response> requestMethod() async {
    var username = userController.text;
    var password = pwrdController.text;
    var url = "https://reapistaging.altervista.org/api.php?uname=$username&password=$password";
    Map<String,String> headers = {
      'Accept': 'application/json',
    };
    final responseHTTP = await http.get(url, headers: headers);
    Map responseMap = jsonDecode(responseHTTP.body);
    var response = reAPI.fromJson(responseMap);
    if (response.status.code == 0){
      print(response.user.nome);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(response: response,)),
      );
    } else {
      setState(() {
        isLoginVisible = true;
      });
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
    setState(() {
      isLoginVisible = false;
    });

    requestMethod();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: isLoginVisible ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 70,
                height: 70,
                child: Image.asset('assets/images/logo_sobrero_grad.png'),
              ),
              isLoginVisible ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                        'Accedi a mySobrero',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          foreground: Paint()..shader = sobreroGradient,
                        ),
                      ),
                  ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'ID Studente'
                        ),
                        controller: userController,
                      ),
                    ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    controller: pwrdController,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Center(
                      child: RaisedButton(
                        padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                        onPressed: buttonLogin,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7.0))),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        child: const Text(
                          'LOGIN',
                        ),
                      ),
                    ),
                  ),
                ],
              ) : new Container(),

              !isLoginVisible ? Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ColorLoader5(
                  dotOneColor: Color(0xFF0287d1),
                  dotTwoColor: Color(0xFF0360e7),
                  dotThreeColor: Color(0xFF0335ff),
                  dotType: DotType.circle,
                  dotIcon: Icon(Icons.adjust),
                ),
              ) : new Container(),

            ],
          ),
        ),
      ),
    );
  }
}
