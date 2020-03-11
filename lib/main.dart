import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:mySobrero/expandedsection.dart';
import 'package:mySobrero/reapi2.dart';
import 'package:mySobrero/reapi3.dart';
import 'home.dart';
import 'dart:convert';
import 'SobreroFeed.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info/package_info.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'globals.dart' as globals;
import 'package:flutter/scheduler.dart' show timeDilation;

void main() {
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  //timeDilation = 3.0;
  runApp( MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'mySobrero',
      theme: ThemeData(
        primaryColor: Color(0xFF0360e7),
        accentColor: Color(0xFF0360e7),
        scaffoldBackgroundColor: Colors.white
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF0360e7),
        accentColor: Color(0xFF0360e7),
        scaffoldBackgroundColor: Color(0xff121212),
        backgroundColor: Colors.blue,
        cardColor: Color(0xff212121),
        bottomAppBarColor: Color(0xff242424),
        canvasColor: Color(0xff242424)
      ),
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark),
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

  bool get isInDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  Future<bool> credSalvate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var localAuth = LocalAuthentication();
    bool useBiometrics = prefs.getBool('biometric_auth') ?? false;
    bool canCheckBiometrics = await localAuth.canCheckBiometrics;
    bool salvate = prefs.getBool('savedCredentials') ?? false;
    List<BiometricType> availableBiometrics = await localAuth.getAvailableBiometrics();
    String nomecognome = prefs.getString('user') ?? "[pref key non salvata]";
    if (canCheckBiometrics && salvate && useBiometrics && availableBiometrics.length > 0) {
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

  bool isBeta = false;

  versionCheck(context) async {

    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion = double.parse(info.buildNumber);
    print("Versione app corrente: $currentVersion");
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    await remoteConfig.fetch(expiration: const Duration(seconds: 0));
    await remoteConfig.activateFetched();
    final serverVersion = double.parse(remoteConfig.getString('verupdate_prompt'));
    print("Versione app disponibile sul server: $serverVersion");
    if (serverVersion < currentVersion) isBeta = true;
    if (serverVersion > currentVersion){
      print("Aggiornamento disponibile");
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)), //this right here
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 200),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                        borderRadius: new BorderRadius.circular(8.0),
                        child: Image.asset('assets/images/update.png')),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Aggiornamento dell'app disponibile",
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
                                    "Una nuova versione di mySobrero è disponibile sullo store, aggiorna per avere le ultime funzionalità subito.",
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Theme.of(context).platform != TargetPlatform.iOS ? Expanded(
                                  flex: 1,
                                  child: OutlineButton(
                                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    onPressed: () {
                                      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(7.0))),
                                    color: Theme.of(context).primaryColor,
                                    child: const AutoSizeText(
                                      'CHIUDI APP',
                                      maxLines: 1,
                                    ),
                                  ),
                                ) : new Container(),
                                Container(width: Theme.of(context).platform != TargetPlatform.iOS ? 10 : 0,),
                                Expanded(
                                  flex: 1,
                                  child: OutlineButton(
                                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    onPressed: () {
                                      LaunchReview.launch();
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(7.0))),
                                    color: Theme.of(context).primaryColor,
                                    child: const Text(
                                      'AGGIORNA',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    } else {
      ragionaLogin();
    }
  }

  final Shader sobreroGradient = LinearGradient(
    begin: FractionalOffset.topRight,
    end: FractionalOffset.bottomRight,
    colors: <Color>[Color(0xFF0287d1), Color(0xFF0335ff)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 30.0));

  var isLoginVisible = false;

  ragionaLogin() async {
    bool cred = await credSalvate();
    if (cred) {
      setState(() {
        loginCalled = true;
        isLoginVisible = false;
      });
      loginSalvato();
    } else {
      setState(() {
        isLoginVisible = true;
      });
    }
  }

  bool _controlloSB = true;

  Future<void> loginSalvato() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = await prefs.getString('username') ?? "NO";
    final password = await prefs.getString('password') ?? "NO";
    reapi3Login(username, password);
  }

  Future<void> reapi3Login(String username, String password) async {
    reAPI3 apiInstance = new reAPI3();
    UnifiedLoginStructure loginStructure = await apiInstance.retrieveStartupData(username, password);
    if (loginStructure.statusHeader.code != 0){
      setState(() {isLoginVisible = true;});
      showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 200),
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
                                    loginStructure.statusHeader.description,
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
                            onPressed: () => Navigator.of(context).pop(),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7.0))),
                            color: Theme.of(context).primaryColor,
                            child: const Text('RIPROVA'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ),
          )
      );
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('savedCredentials', true);
    prefs.setString('username', username);
    prefs.setString('password', password);
    prefs.setString('user', loginStructure.user.nomeCompleto);
    String systemPlatform = (Platform.isWindows ? "win32" : "") +
        (Platform.isAndroid ? "android" : "") +
        (Platform.isFuchsia ? "fuchsia" : "") +
        (Platform.isIOS ? "iOS" : "") +
        (Platform.isLinux ? "linux" : "") +
        (Platform.isMacOS ? "macos" : "");
    final cognome = loginStructure.user.cognome;
    FirebaseAnalytics analytics = FirebaseAnalytics();
    analytics.setUserId("UID$username$cognome");
    analytics.setUserProperty(name: "anno", value: loginStructure.user.classe.toString());
    analytics.setUserProperty(name: "classe", value: "${loginStructure.user.classe} ${loginStructure.user.sezione.trim()}");
    analytics.setUserProperty(name: "corso", value: loginStructure.user.corso);
    analytics.setUserProperty(name: "indirizzo", value: loginStructure.user.corso.contains("Liceo") ? "liceo" : "itis");
    analytics.setUserProperty(name: "platform", value: systemPlatform);

    final PackageInfo info = await PackageInfo.fromPlatform();

    Firestore.instance.collection('utenti').document(username).setData({
      'classe': "${loginStructure.user.classe} ${loginStructure.user.sezione.trim()}",
      'cognome': loginStructure.user.cognome,
      'nome': loginStructure.user.nome,
      'ultimo accesso': DateTime.now().toIso8601String(),
      'platform': systemPlatform,
      'build flavour': isInDebugMode ? 'internal' : 'production',
      'version' : info.buildNumber
    }, merge: true);

    final DocumentSnapshot dataRetrieve = await Firestore.instance.collection('utenti').document(username).get();
    final profileImageUrl = dataRetrieve.data["profileImage"];
    print("profilo: $profileImageUrl");
    globals.profileURL = profileImageUrl;

    final feedUrl = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.sobrero.edu.it%2F%3Ffeed%3Drss2";
    final feedHTTP = await http.get(feedUrl);
    Map feedMap = jsonDecode(feedHTTP.body);
    var feed = SobreroFeed.fromJson(feedMap);

    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___)  =>
              HomeScreen(
                unifiedLoginStructure: loginStructure,
                apiInstance: apiInstance,
                profileUrl: profileImageUrl,
                feed: feed,
                isBeta: isBeta,
              ),
          transitionDuration: Duration(milliseconds: 700),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(0.0, 1.0);
            var end = Offset.zero;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOutExpo));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },

        )
    );
    _controlloSB = false;
  }
/*
  Future<http.Response> requestMethod(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = "https://reapistaging.altervista.org/reapi2.php";
    var feedUrl = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.sobrero.edu.it%2F%3Ffeed%3Drss2";
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    final responseHTTP = await http.post(
        url,
        headers: headers,
        body: {'stud_id': username, 'password': password});
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
      final cognome = response.user.cognome;
      FirebaseAnalytics analytics = FirebaseAnalytics();
      analytics.setUserId("UID$username$cognome");
      analytics.setUserProperty(
          name: "anno", value: response.user.classe.toString());
      analytics.setUserProperty(
          name: "classe",
          value: response.user.classe.toString() +
              " " +
              response.user.sezione.trim());
      analytics.setUserProperty(name: "corso", value: response.user.corso);
      analytics.setUserProperty(
          name: "indirizzo",
          value: response.user.corso.contains("Liceo") ? "liceo" : "itis");
      analytics.setUserProperty(name: "platform", value: systemPlatform);
      final PackageInfo info = await PackageInfo.fromPlatform();
      Firestore.instance.collection('utenti').document(username).setData({
        'classe': response.user.classe.toString() +
            " " +
            response.user.sezione.trim(),
        'cognome': response.user.cognome,
        'nome': response.user.nome,
        'ultimo accesso': DateTime.now().toIso8601String(),
        'platform': systemPlatform,
        'build flavour': isInDebugMode ? 'internal' : 'production',
        'version' : info.buildNumber
      }, merge: true);
      final DocumentSnapshot dataRetrieve = await Firestore.instance
          .collection('utenti')
          .document(username)
          .get();
      final profileImageUrl = dataRetrieve.data["profileImage"];
      print("profilo: $profileImageUrl");
      globals.profileURL = profileImageUrl;
      _controlloSB = false;
      Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___)  =>
                HomeScreen(
                  response: response,
                  profileUrl: profileImageUrl,
                  feed: feed,
                  isBeta: isBeta,
                ),
            transitionDuration: Duration(milliseconds: 700),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var begin = Offset(0.0, 1.0);
              var end = Offset.zero;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOutExpo));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },

        )
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
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 200),
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
              ),
            );
          });
    }
    return responseHTTP;
  }
*/
  void buttonLogin() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    setState(() {
      isLoginVisible = false;
      loginCalled = true;
    });

    reapi3Login(userController.text, pwrdController.text);
  }

  @override
  void initState() {
    super.initState();
    versionCheck(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_controlloSB) FlutterStatusbarcolor.setStatusBarWhiteForeground(Theme.of(context).brightness == Brightness.dark);
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: "main_logosobre",
                child: SizedBox(
                  width: 70,
                  height: 70,
                  child: Image.asset('assets/images/logo_sobrero_grad.png'),
                ),
              ),
              ExpandedSection(
                expand: isLoginVisible,
                child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                          keyboardType: TextInputType.number,
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
              ),
              ExpandedSection(
                expand: (!isLoginVisible && loginCalled),
                child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 5),
                    child: SpinKitDualRing(
                        color: Theme.of(context).primaryColor,
                        size: 30,
                        lineWidth: 5,
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
