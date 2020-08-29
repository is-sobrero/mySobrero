import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launch_review/launch_review.dart';
import 'package:line_icons/line_icons.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mySobrero/agreement/agreement_dialog.dart';
import 'package:mySobrero/cloud_connector/ConfigData.dart';
import 'package:mySobrero/cloud_connector/cloud2.dart';
import 'package:mySobrero/common/skeleton.dart';
import 'package:mySobrero/common/ui.dart';
import 'package:mySobrero/common/utilities.dart';
import 'package:mySobrero/expandedsection.dart';
import 'package:mySobrero/app_main/app_main.dart';
import 'package:mySobrero/intent/handler.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/reapi3.dart';
import 'package:mySobrero/feed/sobrero_feed.dart';
import 'package:mySobrero/intent/intent.dart';
import 'package:mySobrero/sso/authentication_qr.dart';
import 'package:mySobrero/sso/authorize.dart';
import 'package:mySobrero/sso/intent_page.dart';
import 'package:mySobrero/ui/button.dart';
import 'package:mySobrero/ui/dialogs.dart';
import 'package:mySobrero/ui/helper.dart';
import 'package:mySobrero/globals.dart' as globals;

import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


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
  //bool isProgressVisible = false;

  bool isBeta = false;

  String profilePicUrl, userID, userPassword, userFullName;

  StreamSubscription _sub;
  IntentHandler _handler;
  reAPI3 apiInstance;

  bool _askedAuth = false;

  @override
  void initState(){
    super.initState();
    apiInstance = new reAPI3();
    _handler = new IntentHandler (
      context: context,
      apiInstance: apiInstance
    );

    if (!Platform.isMacOS) {
      _sub = getLinksStream().listen(
        _handler.handle,
        onError: (err) => print("err uri"),
      );
    }



    initialProcedure().then((status) {
      // 0 = login in corso
      // 1 = credenziali non salvate
      // 2 = conferma password
      // 3 = SSO in corso
      // -1 = versione non supportata
      // -2 = errore app
      // -3 = SSO non loggato
      switch(status){
        case 0:
          isLoginVisible = false;
          retypePassword = false;
          _logoAnimName = "start";
          doLogin();
          break;
        case 1:
          isLoginVisible = true;
          _logoAnimName = "idle";
          retypePassword = false;
          break;
        case 2:
          isLoginVisible = false;
          _logoAnimName = "end";
          retypePassword = true;
          break;
        default:
          isLoginVisible = false;
          _logoAnimName = "idle";
          retypePassword = false;
          break;
      }
      setState((){});
    });
  }

  AuthenticationQR _req;

  Future<int> initialProcedure () async {
    if (!kIsWeb && !Platform.isMacOS) {
      String invokedURL;
      try {
        invokedURL = await getInitialLink();
      } on PlatformException {
        return 0; // return errore ?
      }
      print("1");
      if (invokedURL != null) {
        if (UriIntent.isInvokingMethod(invokedURL)) {
          if (UriIntent.isMethodSupported(invokedURL)) {
            switch (UriIntent.getMethodName(invokedURL)){
              case "idp":
                print("IdP Richiesto, inizio convalida");
                var reqBytes = base64Decode(UriIntent.getArgument(
                  invokedURL, "idp",
                ));
                var str = String.fromCharCodes(reqBytes);
                print(reqBytes);
                print(str);
                _req = SSOAuthorize.getDetails(data: str);
                _askedAuth = _req != null;
                break;
              default:
                print("?");
                break;
            }
          }
          else
            print("metodo non supportato");
        }
      }
    }
    ConfigData _config = await CloudConnector.getServerConfig();
    if (!kIsWeb) {
      final PackageInfo info = await PackageInfo.fromPlatform();
      int currentVersion = int.parse(info.buildNumber);
      if (_config.data.latestVersion > currentVersion){
        // Se la versione dell'app non è aggiornata, obbliga l'utente ad aggiornare
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => SobreroDialogSingle(
              headingImage: 'assets/images/update.png',
              title: AppLocalizations.of(context).translate('appUpdateAvailable'),
              content: Text(
                AppLocalizations.of(context).translate('appUpdateDesc'),
              ),
              buttonText: AppLocalizations.of(context).translate('appUpdateButton'),
              buttonCallback: () => LaunchReview.launch(),
            ),
        );
        return -1;
      }
      if (_config.data.latestVersion < currentVersion)
        isBeta = true;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool areCredentialsSaved = prefs.getBool('savedCredentials') ?? false;
    userFullName = prefs.getString('user') ?? "";
    userID = prefs.getString('username') ?? "";
    userPassword = prefs.getString('password') ?? "";
    if (!areCredentialsSaved) return 1; // Le credenziali non sono salvate
    if (kIsWeb || Platform.isMacOS) return 0; // Se su web accedi con le cred salvate
    else {
      profilePicUrl = await CloudConnector.getProfilePicture(userID);
      globals.profileURL = profilePicUrl;
      var localAuth = LocalAuthentication();
      bool useBiometrics = prefs.getBool('biometric_auth') ?? false;
      bool canCheckBiometrics = await localAuth.canCheckBiometrics;
      List<BiometricType> availableBiometrics = await localAuth.getAvailableBiometrics();
      if (canCheckBiometrics && useBiometrics && availableBiometrics.length > 0) {
        print("cancheck");
        bool didAuthenticate = await localAuth.authenticateWithBiometrics(
          localizedReason:
              Utilities.formatLocalized(
                AppLocalizations.of(context).translate('authenticateToLogin'),
                userFullName
              ),
          stickyAuth: false,
          androidAuthStrings: AndroidAuthMessages(
            cancelButton: AppLocalizations.of(context).translate('cancelButton'),
            fingerprintHint: "",
            fingerprintNotRecognized: AppLocalizations.of(context).translate('fingerprintNotRecognized'),
            fingerprintRequiredTitle: AppLocalizations.of(context).translate('fingerprintRequired'),
            fingerprintSuccess: AppLocalizations.of(context).translate('fingerprintSuccess'),
            signInTitle: AppLocalizations.of(context).translate('loginToMySobrero'),
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
    UnifiedLoginStructure loginStructure = await apiInstance.retrieveStartupData(userID, userPassword);
    if (loginStructure.statusHeader.code != 0){
      setState(() {
        _logoAnimName = "end";
        isLoginVisible = true;
        //isProgressVisible = false;
        retypePassword = false;
      });
      showDialog(
        context: context,
        builder: (context) => SobreroDialogSingle(
          headingImage: 'assets/images/errore.png',
          title: AppLocalizations.of(context).translate('loginError'),
          content: Text(loginStructure.statusHeader.description),
          buttonText: AppLocalizations.of(context).translate('retryButton'),
          buttonCallback: () => Navigator.of(context).pop(),
        )
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('agreementAccepted') != true) {
      await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___)  => AgreementScreen(),
          transitionDuration: Duration(milliseconds: UIHelper.pageAnimDuration),
          transitionsBuilder: (ctx, prim, sec, child) => SharedAxisTransition(
            animation: prim,
            secondaryAnimation: sec,
            transitionType: SharedAxisTransitionType.scaled,
            child: child,
          ),
        ),
      );
    }
    prefs.setBool('agreementAccepted', true);
    prefs.setBool('savedCredentials', true);
    prefs.setString('username', userID);
    prefs.setString('password', userPassword);
    prefs.setString('user', loginStructure.user.nomeCompleto);

    final accountType = loginStructure.user.livello == "4" ? "student" : "parent";
    final userClasse = "${loginStructure.user.classe} ${loginStructure.user.sezione}";

    await CloudConnector.registerSession(
      uid: userID,
      name: loginStructure.user.nome,
      surname: loginStructure.user.cognome,
      currentClass: userClasse,
      level: accountType,
      token: apiInstance.getSession(),
    );

    final feedUrl = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.sobrero.edu.it%2F%3Ffeed%3Drss2";
    final feedHTTP = await http.get(feedUrl);
    Map feedMap = jsonDecode(feedHTTP.body);
    var feed = SobreroFeed.fromJson(feedMap);

    profilePicUrl = await CloudConnector.getProfilePicture(userID);
    globals.profileURL = profilePicUrl;

    if (_askedAuth)
      await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___)  => SSOIntentPage(
            request: _req,
            session: apiInstance.getSession(),
          ),
          transitionDuration: Duration(
            milliseconds: UIHelper.pageAnimDuration,
          ),
          transitionsBuilder: (_, p, s, c) => SharedAxisTransition(
            animation: p,
            secondaryAnimation: s,
            transitionType: SharedAxisTransitionType.scaled,
            child: c,
          ),
        ),
      );

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
          transitionDuration: Duration(milliseconds: UIHelper.pageAnimDuration),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              child: child,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.scaled,
            );
          },

        )
    );
  }

  void buttonLoginOnClick(String user, String password) {
    FocusScope.of(context).unfocus();
    userID = user;
    userPassword = password;
    setState(() {
      isLoginVisible = false;
      //isProgressVisible = true;
      _logoAnimName = "start";
      retypePassword = false;
    });
    doLogin();
  }

  String _logoAnimName = "idle";

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Theme.of(context).brightness,
      ),
      child: Scaffold(
        body: Center(
          child: SizedBox(
            width: 340,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: "main_logosobre",
                  child: Container(
                    width: retypePassword ? 37 : 65,
                    height: retypePassword ? 37 : 65,
                    child: FlareActor(
                      "assets/animations/soloader.flr",
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      animation: _logoAnimName,
                      callback: (name) {
                        if (name == "start")
                          setState(() {
                            _logoAnimName = "loading";
                          });
                        if (name == "end")
                          setState(() {
                            _logoAnimName = "idle";
                          });
                      },
                    ),
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
                        child: Text(
                          Utilities.formatLocalized(
                            AppLocalizations.of(context).translate('loginAs'),
                            userFullName ?? "",
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SobreroTextField(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        hintText: AppLocalizations.of(context).translate('password'),
                        controller: retypePwdController,
                        obscureText: true,
                      ),
                      SobreroButton(
                        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        text: AppLocalizations.of(context).translate('loginButton'),
                        suffixIcon: Icon(LineIcons.unlock),
                        color: Theme.of(context).primaryColor,
                        onPressed: () => buttonLoginOnClick(
                          userID,
                          retypePwdController.text,
                        ),
                      ),
                      InkWell(
                        onTap: () => setState((){
                          retypePassword = false;
                          isLoginVisible = true;
                        }),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppLocalizations.of(context).translate('loginWithAnotherAccount'),
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
                          AppLocalizations.of(context).translate('loginToMySobrero'),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      SobreroTextField(
                        margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                        hintText: AppLocalizations.of(context).translate('studentID'),
                        controller: userController,
                      ),
                      SobreroTextField(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        hintText: AppLocalizations.of(context).translate('password'),
                        controller: loginPwdController,
                        obscureText: true,
                      ),
                      SobreroButton(
                        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        text: AppLocalizations.of(context).translate('loginButton'),
                        suffixIcon: Icon(LineIcons.unlock),
                        color: Theme.of(context).primaryColor,
                        onPressed: () => buttonLoginOnClick(
                          userController.text,
                          loginPwdController.text,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }

}