import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:launch_review/launch_review.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mySobrero/common/skeleton.dart';
import 'package:mySobrero/cloud_connector/cloud.dart';
import 'package:mySobrero/expandedsection.dart';
import 'package:mySobrero/common/dialogs.dart';
import 'package:mySobrero/app_main/main.dart';
import 'package:mySobrero/reapi3.dart';
import 'package:mySobrero/feed/sobrero_feed.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:mySobrero/globals.dart' as globals;


class AppLogin extends StatefulWidget {
  AppLogin({Key key}) : super(key: key);

  @override
  _AppLoginState createState() => _AppLoginState();
}

class _AppLoginState extends State<AppLogin> with SingleTickerProviderStateMixin {
  final userController = TextEditingController();
  final loginPwdController = TextEditingController();
  final retypePwdController = TextEditingController();

  bool isLoginVisible = false;
  bool retypePassword = false;
  bool isProgressVisible = false;

  bool isBeta = false;

  String profilePicUrl, userID, userPassword, userFullName;

  @override
  void initState(){
    super.initState();
    initialProcedure().then((status) {
      // 0 = login in corso
      // 1 = credenziali non salvate
      // 2 = conferma password
      // -1 = versione non supportata
      switch(status){
        case 0:
          isLoginVisible = false;
          isProgressVisible = true;
          retypePassword = false;
          doLogin();
          break;
        case 1:
          isLoginVisible = true;
          isProgressVisible = false;
          retypePassword = false;
          break;
        case 2:
          isLoginVisible = false;
          isProgressVisible = false;
          retypePassword = true;
          break;
        default:
          isLoginVisible = false;
          isProgressVisible = false;
          retypePassword = false;
          break;
      }
      setState((){});
    });
  }



  Future<int> initialProcedure () async {
    if (!kIsWeb) {
      final PackageInfo info = await PackageInfo.fromPlatform();
      int currentVersion = int.parse(info.buildNumber);
      final int onlineAppVer = await getOnlineAppVersion();
      if (onlineAppVer > currentVersion){
        // Se la versione dell'app non è aggiornata, obbliga l'utente ad aggiornare
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => singleButtonDialog(
                headingImage: 'assets/images/update.png',
                title: "Aggiornamento dell'app disponibile",
                content: "Una nuova versione di mySobrero è disponibile sullo store, aggiorna per avere le ultime funzionalità subito.",
                buttonText: "AGGIORNA",
                buttonCallback: () => LaunchReview.launch(),
                context: context
            )
        );
        return -1;
      }
      if (onlineAppVer < currentVersion){
        // Versione beta
        isBeta = true;
      }
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool areCredentialsSaved = prefs.getBool('savedCredentials') ?? false;
    print(areCredentialsSaved);
    userFullName = prefs.getString('user') ?? "";
    userID = prefs.getString('username') ?? "";
    userPassword = prefs.getString('password') ?? "";
    if (!areCredentialsSaved) return 1; // Le credenziali non sono salvate
    if (kIsWeb) return 0; // Se su web accedi con le cred salvate
    else {
      profilePicUrl = await getProfilePicture(userID: userID);
      globals.profileURL = profilePicUrl;
      var localAuth = LocalAuthentication();
      bool useBiometrics = prefs.getBool('biometric_auth') ?? false;
      bool canCheckBiometrics = await localAuth.canCheckBiometrics;
      List<BiometricType> availableBiometrics = await localAuth.getAvailableBiometrics();
      if (canCheckBiometrics && useBiometrics && availableBiometrics.length > 0) {
        print("cancheck");
        bool didAuthenticate = await localAuth.authenticateWithBiometrics(
          localizedReason:
          'Autenticati per accedere a mySobrero come $userFullName',
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
        if (didAuthenticate) return 0;
        else return 2;
      }
      else {
        return 0;
      }
    }
  }

  Future<void> doLogin() async {
    print("$userID $userPassword");
    reAPI3 apiInstance = new reAPI3();
    UnifiedLoginStructure loginStructure = await apiInstance.retrieveStartupData(userID, userPassword);
    if (loginStructure.statusHeader.code != 0){
      setState(() {
        isLoginVisible = true;
        isProgressVisible = false;
        retypePassword = false;
      });
      showDialog(
        context: context,
        builder: (context) => singleButtonDialog(
          headingImage: 'assets/images/errore.png',
          title: "Errore durante il login",
          content: loginStructure.statusHeader.description,
          buttonText: "RIPROVA",
          buttonCallback: () => Navigator.of(context).pop(),
          context: context
        )
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('savedCredentials', true);
    prefs.setString('username', userID);
    prefs.setString('password', userPassword);
    prefs.setString('user', loginStructure.user.nomeCompleto);

    final accountType = loginStructure.user.livello == "4" ? "studente" : "genitore";
    final userClasse = "${loginStructure.user.classe} ${loginStructure.user.sezione}";

    await saveAccountData(
      userID: userID,
      name: loginStructure.user.nome,
      surname: loginStructure.user.cognome,
      classe: userClasse,
      accountLevel: accountType,
    );
    setAnalyticsData(
      userID: userID,
      surname: loginStructure.user.cognome,
      classe: loginStructure.user.classe,
      sezione: loginStructure.user.sezione,
      accountLevel: accountType,
      corso: loginStructure.user.corso
    );

    final feedUrl = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.sobrero.edu.it%2F%3Ffeed%3Drss2";
    final feedHTTP = await http.get(feedUrl);
    Map feedMap = jsonDecode(feedHTTP.body);
    var feed = SobreroFeed.fromJson(feedMap);

    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___)  => AppMain(
            unifiedLoginStructure: loginStructure,
            apiInstance: apiInstance,
            profileUrl: profilePicUrl,
            feed: feed,
            isBeta: isBeta,
          ),
          transitionDuration: Duration(milliseconds: 1000),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              child: child,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.vertical,
            );
          },

        )
    );
  }

  void buttonLoginOnClick(String user, String password) {
    userID = user;
    userPassword = password;
    setState(() {
      isLoginVisible = false;
      isProgressVisible = true;
      retypePassword = false;
    });
    doLogin();
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
            children: [
              Hero(
                tag: "main_logosobre",
                child: Container(
                  width: retypePassword ? 37 : 65,
                  height: retypePassword ? 37 : 65,
                  child: Image.asset('assets/images/logo_sobrero_grad.png'),
                ),
              ),
              // Retype Password Screen
              ExpandedSection(
                expand: retypePassword,
                child: Column(
                  children: [
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
                              child: profilePicUrl != null ? CachedNetworkImage(
                                imageUrl: profilePicUrl,
                                placeholder: (context, url) => Skeleton(),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                                fit: BoxFit.cover,
                              ) : Image.asset("assets/images/profile.jpg")
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 15.0),
                      child: Text("Accedi a mySobrero come $userFullName",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Password',
                      ),
                      controller: retypePwdController,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: RaisedButton(
                        padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                        onPressed: () => buttonLoginOnClick(userID, retypePwdController.text),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7.0))),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        child: const Text('ACCEDI'),
                      )
                    ),
                    InkWell(
                      onTap: () => setState((){
                        retypePassword = false;
                        isLoginVisible = true;
                      }),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Accedi con un altro account",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Login screen
              ExpandedSection(
                expand: isLoginVisible,
                child: Column(
                  children: [
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
                    ),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Password',
                      ),
                      controller: loginPwdController,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Center(
                        child: RaisedButton(
                          padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                          onPressed: () => buttonLoginOnClick(userController.text, loginPwdController.text),
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
                  ],
                ),
              ),
              // Loading screen
              ExpandedSection(
                expand: isProgressVisible,
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
      )
    );
  }

}