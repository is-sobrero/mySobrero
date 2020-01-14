import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'ColorLoader5.dart';
import 'home.dart';
import 'dart:convert';
import 'reapi.dart';
import 'SobreroFeed.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:local_auth/local_auth.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light){
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
          statusBarIconBrightness: Brightness.dark
      ));
    }
    return MaterialApp(
      title: 'mySobrero',
      theme: ThemeData(
        primaryColor: Color(0xFF0360e7),
        accentColor: Color(0xFF0360e7),
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Color(0xFF0360e7),
          accentColor: Color(0xFF0360e7),
          scaffoldBackgroundColor: Color(0xFF212121)
      ),
      //home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light, // status bar icons' color
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
  bool loginCalled = false;
  bool initialCall = true;
  final userController = TextEditingController();
  final pwrdController = TextEditingController();

  final Shader sobreroGradient = LinearGradient(
    begin: FractionalOffset.topRight,
    end: FractionalOffset.bottomRight,
    colors: <Color>[Color(0xFF0287d1), Color(0xFF0335ff)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 30.0));

  var isLoginVisible = false;

  Future<bool> credSalvate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var localAuth = LocalAuthentication();
    bool canCheckBiometrics = await localAuth.canCheckBiometrics;
    bool salvate = prefs.getBool('savedCredentials') ?? false;
    String nomecognome = prefs.getString('user') ?? "[pref key non salvata]";
    if (canCheckBiometrics) {
      bool didAuthenticate = await localAuth.authenticateWithBiometrics(
          localizedReason: 'Autenticati per accedere a mySobrero come $nomecognome',
          stickyAuth: false,
          androidAuthStrings: AndroidAuthMessages(
            cancelButton: "Annulla",
            fingerprintHint: "",
            fingerprintNotRecognized: "Impronta non riconosciuta",
            fingerprintRequiredTitle: "Impronta richeista",
            fingerprintSuccess: "Autenticazione riuscita",
            signInTitle: "Accedi a mySobrero",
          ),
      );
      if (didAuthenticate) {
        return true;
      } else {
        return false;
      }
    }
    return salvate;
  }
  Future<void> loginSalvato() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = await prefs.getString('username') ?? "NO";
    final password = await prefs.getString('password') ?? "NO";
    requestMethod(username, password);
  }
  Future<http.Response> requestMethod(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = "https://reapistaging.altervista.org/api.php?uname=$username&password=$password";
    var feedUrl = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.sobrero.edu.it%2F%3Ffeed%3Drss2";
    Map<String,String> headers = {
      'Accept': 'application/json',
    };
    final responseHTTP = await http.get(url, headers: headers);
    Map responseMap = jsonDecode(responseHTTP.body);
    var response = reAPI.fromJson(responseMap);
    if (response.status.code == 0){
      print(response.user.nome);
      final feedHTTP = await http.get(feedUrl, headers: headers);
      Map feedMap = jsonDecode(feedHTTP.body);
      var feed = SobreroFeed.fromJson(feedMap);
      prefs.setBool('savedCredentials', true);
      prefs.setString('username', username);
      prefs.setString('password', password);
      prefs.setString('user', response.user.nome + " " + response.user.cognome);
      String systemPlatform = (Platform.isWindows ? "win32" : "") +
                              (Platform.isAndroid ? "android" : "") +
                              (Platform.isFuchsia ? "fuchsia" : "") +
                              (Platform.isIOS ? "iOS" : "") +
                              (Platform.isLinux ? "linux" : "") +
                              (Platform.isMacOS ? "macos" : "");

      FirebaseAnalytics analytics = FirebaseAnalytics();
      analytics.setUserProperty(name: "anno", value: response.user.classe);
      analytics.setUserProperty(name: "classe", value: response.user.classe + " " + response.user.sezione);
      analytics.setUserProperty(name: "corso", value: response.user.corso);
      analytics.setUserProperty(name: "indirizzo", value: response.user.corso.contains("Liceo") ? "liceo" : "itis");
      analytics.setUserProperty(name: "platform", value: systemPlatform);

      Firestore.instance.collection('utenti').document(username)
          .setData({
            'classe': response.user.classe + " " + response.user.sezione,
            'cognome': response.user.cognome,
            'nome': response.user.nome,
            'ultimo accesso' : DateTime.now().toIso8601String(),
            'platform': systemPlatform
          });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(response, feed)),
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
      loginCalled = true;
    });

    requestMethod(userController.text, pwrdController.text);
  }

  @override
  Widget build(BuildContext context) {
    if (initialCall){
      Future.delayed(const Duration(milliseconds: 1000), () {
        credSalvate().then((res){
          setState(() {
            initialCall = false;
            if (res && !loginCalled){
              loginSalvato();
              loginCalled = true;
              setState(() {
                isLoginVisible = false;
                loginCalled = true;
              });
            } else {
              isLoginVisible = true;
            }
          });
        });
      });
    }

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

              (!isLoginVisible && loginCalled) ? Padding(
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
