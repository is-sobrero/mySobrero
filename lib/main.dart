import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:mySobrero/reapi2.dart';
import 'ColorLoader5.dart';
import 'home.dart';
import 'dart:convert';
import 'SobreroFeed.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

void main() {
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
        scaffoldBackgroundColor: Color(0xFF212121),
      ),
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark
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
    if (canCheckBiometrics && salvate) {
      bool didAuthenticate = await localAuth.authenticateWithBiometrics(
        localizedReason:
            'Autenticati per accedere a mySobrero come $nomecognome',
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
    //var url = "https://reapistaging.altervista.org/api.php?uname=$username&password=$password";
    var url = "https://reapistaging.altervista.org/reapi2.php";
    var feedUrl =
        "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.sobrero.edu.it%2F%3Ffeed%3Drss2";
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    final responseHTTP = await http.post(url,
        headers: headers, body: {'stud_id': username, 'password': password});
    Map responseMap = jsonDecode(responseHTTP.body);
    var response = reAPI2.fromJson(responseMap);
    if (response.status.code == 0) {
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
      analytics.setUserProperty(
          name: "anno", value: response.user.classe.toString());
      analytics.setUserProperty(
          name: "classe",
          value: response.user.classe.toString() + " " + response.user.sezione);
      analytics.setUserProperty(name: "corso", value: response.user.corso);
      analytics.setUserProperty(
          name: "indirizzo",
          value: response.user.corso.contains("Liceo") ? "liceo" : "itis");
      analytics.setUserProperty(name: "platform", value: systemPlatform);

      Firestore.instance.collection('utenti').document(username).setData({
        'classe': response.user.classe.toString() + " " + response.user.sezione,
        'cognome': response.user.cognome,
        'nome': response.user.nome,
        'ultimo accesso': DateTime.now().toIso8601String(),
        'platform': systemPlatform,
        'build flavour': 'production'
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
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)), //this right here
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                      borderRadius: new BorderRadius.circular(8.0),
                      child: Image.asset('assets/images/errore.png')),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Errore durante il Login",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 16, bottom: 16),
                                child: Text(
                                  response.status.description,
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Text(
                                "Per fortuna abbiamo messo il pulsante riprova",
                                style: TextStyle(fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        OutlineButton(
                          padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.0))),
                          color: Theme.of(context).primaryColor,
                          child: const Text(
                            'RIPROVA',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
    }
    return responseHTTP;
  }

  void buttonLogin() {
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
    if (initialCall) {
      if (Theme.of(context).brightness == Brightness.dark)
        FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
      else
        FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
      Future.delayed(const Duration(milliseconds: 1000), () {
        credSalvate().then((res) {
          setState(() {
            initialCall = false;
            if (res && !loginCalled) {
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
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: isLoginVisible
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 70,
                height: 70,
                child: Image.asset('assets/images/logo_sobrero_grad.png'),
              ),
              isLoginVisible
                  ? Column(
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
                                labelText: 'ID Studente'),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7.0))),
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              child: const Text(
                                'ACCEDI',
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : new Container(),
              (!isLoginVisible && loginCalled)
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ColorLoader5(
                        dotOneColor: Color(0xFF0287d1),
                        dotTwoColor: Color(0xFF0360e7),
                        dotThreeColor: Color(0xFF0335ff),
                        dotType: DotType.circle,
                        dotIcon: Icon(Icons.adjust),
                      ),
                    )
                  : new Container(),
            ],
          ),
        ),
      ),
    );
  }
}
