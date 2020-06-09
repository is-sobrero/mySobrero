import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:mySobrero/expandedsection.dart';
import 'package:animations/animations.dart';
import 'package:mySobrero/reapi3.dart';
import 'package:mySobrero/skeleton.dart';
import 'package:quick_actions/quick_actions.dart';
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
  runApp(MyApp());
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
        scaffoldBackgroundColor: Colors.white,
        //fontFamily: "ARSMaquettePro"
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF0360e7),
        //fontFamily: "Open Sans",
        accentColor: Color(0xFF0360e7),
        scaffoldBackgroundColor: Color(0xff121212),
        backgroundColor: Colors.blue,
        cardColor: Color(0xff212121),
        bottomAppBarColor: Color(0xff242424),
        canvasColor: Color(0xff242424),
      ),
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Theme.of(context).brightness
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

class _AppLoginState extends State<AppLogin> with SingleTickerProviderStateMixin {
  bool loginCalled = false;
  bool initialCall = true;
  final userController = TextEditingController();
  final pwrdController = TextEditingController();

  bool get isInDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }




  bool savedNotAuth = false;
  String profileUrl;
  String uname, realName;
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
        uname = prefs.getString('username') ?? "";
        final DocumentSnapshot dataRetrieve = await Firestore.instance.collection('utenti').document(uname).get();
        profileUrl = dataRetrieve.data["profileImage"];
        print("Profilo: $profileUrl");
        savedNotAuth = true;
        realName = nomecognome;
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), //this right here
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
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7.0))),
                                    color: Theme.of(context).primaryColor,
                                    child: const AutoSizeText('CHIUDI APP', maxLines: 1,),
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
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7.0))),
                                    color: Theme.of(context).primaryColor,
                                    child: const Text('AGGIORNA',),
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
    final QuickActions quickActions = QuickActions();
    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(type: 'action_voti', localizedTitle: 'Valutazioni'),
      const ShortcutItem(type: 'action_comm', localizedTitle: 'Comunicazioni')
    ]);
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
    final tipoAccount = loginStructure.user.livello == "4" ? "studente" : "genitore";
    analytics.setUserId("UID$username$cognome");
    analytics.setUserProperty(name: "anno", value: loginStructure.user.classe.toString());
    analytics.setUserProperty(name: "classe", value: "${loginStructure.user.classe} ${loginStructure.user.sezione.trim()}");
    analytics.setUserProperty(name: "corso", value: loginStructure.user.corso);
    analytics.setUserProperty(name: "indirizzo", value: loginStructure.user.corso.contains("Liceo") ? "liceo" : "itis");
    analytics.setUserProperty(name: "platform", value: systemPlatform);
    analytics.setUserProperty(name: "livelloAccount", value: tipoAccount);

    final PackageInfo info = await PackageInfo.fromPlatform();

    Firestore.instance.collection('utenti').document(username).setData({
      'classe': "${loginStructure.user.classe} ${loginStructure.user.sezione.trim()}",
      'cognome': loginStructure.user.cognome,
      'nome': loginStructure.user.nome,
      'ultimo accesso': DateTime.now().toIso8601String(),
      'platform': systemPlatform,
      'build flavour': isInDebugMode ? 'internal' : 'production',
      'version' : info.buildNumber,
      'livelloAccount' : tipoAccount
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
          pageBuilder: (_, __, ___)  => HomeScreen(
                unifiedLoginStructure: loginStructure,
                apiInstance: apiInstance,
                profileUrl: profileImageUrl,
                feed: feed,
                isBeta: isBeta,
              ),
          transitionDuration: Duration(milliseconds: 1000),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(0.0, 1.0);
            var end = Offset.zero;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOutExpo));
            var offsetAnimation = animation.drive(tween);
            /*return SlideTransition(
              position: offsetAnimation,
              child: child,
            );*/
            return SharedAxisTransition(
              child: child,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.vertical,
            );
          },

        )
    );
    _controlloSB = false;
  }

  void buttonLogin() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    final String finalUser = savedNotAuth ? uname : userController.text;
    setState(() {
      isLoginVisible = false;
      loginCalled = true;
      savedNotAuth = false;
    });
    reapi3Login(finalUser, pwrdController.text);
  }

  @override
  void initState() {
    super.initState();
    versionCheck(context);
    final QuickActions quickActions = QuickActions();
    quickActions.initialize((shortcutType) {
      if (shortcutType == 'action_voti') {
        print('Preload su voti');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                child: Container(
                  width: savedNotAuth ? 37 : 65,
                  height: savedNotAuth ? 37 : 65,
                  child: Image.asset('assets/images/logo_sobrero_grad.png'),
                ),
              ),
              ExpandedSection(
                expand: isLoginVisible,
                child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ExpandedSection(
                        expand: savedNotAuth,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Container(
                                decoration: new BoxDecoration(
                                  boxShadow: [BoxShadow(
                                      color: Colors.black.withAlpha(50),
                                      offset: Offset(0, 5),
                                      blurRadius: 10
                                  )],
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: new Container(
                                      width: 80,
                                      height: 80,
                                      color: Theme.of(context).scaffoldBackgroundColor,
                                      child: profileUrl != null ? CachedNetworkImage(
                                        imageUrl: profileUrl,
                                        placeholder: (context, url) =>
                                            Skeleton(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        fit: BoxFit.cover,
                                      ) : Image.asset("assets/images/profile.jpg")
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 15.0),
                              child: Text("Accedi a mySobrero come $realName",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        )
                      ),
                      ExpandedSection(
                        expand: !savedNotAuth,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                'Accedi a mySobrero',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    filled: true,
                                    labelText: 'ID Studente'),
                                controller: userController,
                              ),
                            )
                          ],
                        ),
                      ),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          labelText: 'Password',
                        ),
                        controller: pwrdController,
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
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
                            child: const Text('ACCEDI'),
                          ),
                        ),
                      ),
                      ExpandedSection(
                        expand: savedNotAuth,
                        child: Center(
                          child: InkWell(
                            onTap: () => setState((){
                              savedNotAuth = false;
                            }),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Accedi con un altro account", style: TextStyle(decoration: TextDecoration.underline, color: Theme.of(context).primaryColor), ),
                            ),
                          ),
                        )
                      )
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
