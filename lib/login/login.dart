import 'dart:async';
import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
import 'package:mySobrero/common/dialogs.dart';
import 'package:mySobrero/app_main/app_main.dart';
import 'package:mySobrero/intent/handler.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/reapi3.dart';
import 'package:mySobrero/feed/sobrero_feed.dart';
import 'package:mySobrero/intent/intent.dart';
import 'package:mySobrero/ui/helper.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:mySobrero/globals.dart' as globals;

import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;



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

  StreamSubscription _sub;
  IntentHandler _handler;
  reAPI3 apiInstance;

  @override
  void initState(){
    super.initState();
    apiInstance = new reAPI3();
    _handler = new IntentHandler (
      context: context,
      apiInstance: apiInstance
    );

    _sub = getLinksStream().listen(
      _handler.handle,
      onError: (err) => print("err uri"),
    );

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
    String invokedURL;
    try {
      invokedURL = await getInitialLink();
    } on PlatformException {
      return 0; // return errore ?
    }
    if (invokedURL != null) {
      if (UriIntent.isInvokingMethod(invokedURL)){
        if (UriIntent.isMethodSupported(invokedURL)){
          switch(UriIntent.getMethodName(invokedURL)){
            case "idp":

              break;

          }
        }
        else
          print("metodo non supportato");
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
            builder: (context) => singleButtonDialog(
                headingImage: 'assets/images/update.png',
                title: AppLocalizations.of(context).translate('appUpdateAvailable'),
                content: AppLocalizations.of(context).translate('appUpdateDesc'),
                buttonText: AppLocalizations.of(context).translate('appUpdateButton'),
                buttonCallback: () => LaunchReview.launch(),
                context: context
            )
        );
        return -1;
      }
      if (_config.data.latestVersion < currentVersion){
        // Versione beta
        isBeta = true;
      }
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool areCredentialsSaved = prefs.getBool('savedCredentials') ?? false;
    userFullName = prefs.getString('user') ?? "";
    userID = prefs.getString('username') ?? "";
    userPassword = prefs.getString('password') ?? "";
    if (!areCredentialsSaved) return 1; // Le credenziali non sono salvate
    if (kIsWeb) return 0; // Se su web accedi con le cred salvate
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
        isLoginVisible = true;
        isProgressVisible = false;
        retypePassword = false;
      });
      showDialog(
        context: context,
        builder: (context) => singleButtonDialog(
          headingImage: 'assets/images/errore.png',
          title: AppLocalizations.of(context).translate('loginError'),
          content: loginStructure.statusHeader.description,
          buttonText: AppLocalizations.of(context).translate('retryButton'),
          buttonCallback: () => Navigator.of(context).pop(),
          context: context
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