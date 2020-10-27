import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:launch_review/launch_review.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:mySobrero/agreement/agreement_dialog.dart';
import 'package:mySobrero/cloud_connector/ConfigData.dart';
import 'package:mySobrero/cloud_connector/cloud.dart';
import 'package:mySobrero/ui/skeleton.dart';
import 'package:mySobrero/common/utilities.dart';
import 'package:mySobrero/expandedsection.dart';
import 'package:mySobrero/app_main/app_main.dart';
import 'package:mySobrero/intent/handler.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/feed/sobrero_feed.dart';
import 'package:mySobrero/intent/intent.dart';
import 'package:mySobrero/sso/authentication_qr.dart';
import 'package:mySobrero/sso/authorize.dart';
import 'package:mySobrero/sso/intent_page.dart';
import 'package:mySobrero/ui/button.dart';
import 'package:mySobrero/ui/dialogs.dart';
import 'package:mySobrero/ui/helper.dart';
import 'package:mySobrero/reAPI/reapi.dart';
import 'package:mySobrero/reAPI/types.dart';
import 'package:mySobrero/ui/textfield.dart';
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

  bool isBeta = false;

  String profilePicUrl, userID, userPassword, userFullName;

  StreamSubscription _sub;
  IntentHandler _handler;

  bool _askedAuth = false;

  Future<void> initAutomaticSync() async {
    BackgroundFetch.configure(BackgroundFetchConfig(
      minimumFetchInterval: 5,
      stopOnTerminate: false,
      enableHeadless: false,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresStorageNotLow: false,
      requiresDeviceIdle: false,
      requiredNetworkType: NetworkType.ANY,
    ), (taskID) async {
      Utilities.initNotifications(); // <- trovare un modo per non richiamarlo
      if (Utilities.isInternalBuild){
        Utilities.sendNotification(
          title: "[⚙️ DEBUG] BGTask triggerato",
          body: "Il sistema operativo ha richiesto una sincronizzazione in background di mySobrero, Task ID: $taskID",
        );
      }
      print("[reSYNC] Richiesto aggiornamento dal SO, inizio procedura");

      // rifacciamo il login a prescindere
      // TODO: implementare in reAPI i metodi getCompiti, getVoti, getComunicazioni
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool areCredentialsSaved = prefs.getBool('savedCredentials') ?? false;
      if (!areCredentialsSaved) {
        print("[reSYNC] Credenziali non salvate, procedura terminata");
        BackgroundFetch.finish(taskID);
        return;
      }
      userID = prefs.getString('username') ?? "";
      userPassword = prefs.getString('password') ?? "";
      loginStructure = await reAPI4.instance.getStartupData(
        username: userID,
        password: userPassword,
      );

      int mark1Count = prefs.getInt("marks1Count") ?? 0;
      int mark2Count = prefs.getInt("marks2Count") ?? 0;
      int assignmentsCount = prefs.getInt("assignmentsCount") ?? 0;
      int noticesCount = prefs.getInt("noticesCount") ?? 0;
      //print("[reSYNC] Session id: ${apiInstance.getSession()}");
      if (loginStructure.marks_firstperiod.length > mark1Count){
        print("[reSYNC] Nuovi voti 1Q presenti, invio LN");
        String _prof = loginStructure.marks_firstperiod[0].professor;
        String _subject = loginStructure.marks_firstperiod[0].subject;
        double _mark = loginStructure.marks_firstperiod[0].mark;
        Utilities.sendNotification(
          title: "Nuovo voto di $_subject inserito",
          body: "$_prof ti ha assegnato il voto $_mark nella materia $_subject",
          channelID: "it.edu.mysobrero.nc.marks",
          channelName: "Nuovi voti",
          channelDesc: "Invia notifiche ogni volta che un nuovo voto è inserito",
        );
      }
      if (loginStructure.marks_finalperiod.length > mark2Count){
        print("[reSYNC] Nuovi voti 2Q presenti, invio LN");
        String _prof = loginStructure.marks_finalperiod[0].professor;
        String _subject = loginStructure.marks_finalperiod[0].subject;
        double _mark = loginStructure.marks_finalperiod[0].mark;
        Utilities.sendNotification(
          title: "Nuovo voto di $_subject inserito",
          body: "$_prof ti ha assegnato il voto $_mark nella materia $_subject",
          channelID: "it.edu.mysobrero.nc.marks",
          channelName: "Nuovi voti",
          channelDesc: "Invia notifiche ogni volta che un nuovo voto è inserito",
        );
      }
      // TODO: Evidentemente le comunicazioni scompaiono... implementare un hashing
      if (loginStructure.assignments.length > assignmentsCount){
        print("[reSYNC] Nuovi compiti presenti, invio LN");
        String _subject = loginStructure.assignments[0].subject;
        Utilities.sendNotification(
          title: "Nuovo compito assegnato",
          body: "Hai un nuovo compito assegnato di $_subject",
          channelID: "it.edu.mysobrero.nc.assignments",
          channelName: "Nuovi compiti",
          channelDesc: "Invia notifiche ogni volta che un nuovo compito è stato assegnato",
        );
      }
      if (loginStructure.notices.length > noticesCount){
        print("[reSYNC] Nuove comunicazioni presenti, invio LN");
        String _sender = loginStructure.notices[0].sender;
        String _title = loginStructure.notices[0].object;
        Utilities.sendNotification(
          title: "Nuova comunicazione ricevuta",
          body: "$_sender ha inviato una nuova comunicazione: $_title",
          channelID: "it.edu.mysobrero.nc.notices",
          channelName: "Nuove comunicazione",
          channelDesc: "Invia notifiche ogni volta che ricevi una comunicazione",
        );
      }

      prefs.setInt('marks1Count', loginStructure.marks_firstperiod.length);
      prefs.setInt('marks2Count', loginStructure.marks_finalperiod.length);
      prefs.setInt('assignmentsCount', loginStructure.assignments.length);
      prefs.setInt('noticesCount', loginStructure.notices.length);

      BackgroundFetch.finish(taskID);
    });
  }

  ConfigData _config;

  @override
  void initState(){
    super.initState();
    initAutomaticSync();

    _handler = new IntentHandler (
      context: context,
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
      // -1 = versione non supportata
      // -2 = errore app
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
  StartupData loginStructure;

  Future<int> initialProcedure () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool areCredentialsSaved = prefs.getBool('savedCredentials') ?? false;
    if (!kIsWeb && !Platform.isMacOS) {
      String invokedURL;
      try {
        invokedURL = await getInitialLink();
      } on PlatformException {
        return 0; // return errore ?
      }
      if (invokedURL != null) {
        if (UriIntent.isInvokingMethod(invokedURL)) {
          if (UriIntent.isMethodSupported(invokedURL)) {
            switch (UriIntent.getMethodName(invokedURL)) {
              case "idp":
                print("IdP Richiesto, inizio convalida");
                var reqBytes = base64Decode(UriIntent.getArgument(
                  invokedURL, "idp",
                ));
                var str = String.fromCharCodes(reqBytes);
                print(reqBytes);
                print(str);
                _req = SSOAuthorize.getDetails(data: str);
                _askedAuth = _req != null && areCredentialsSaved;
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
    _config = await CloudConnector.getServerConfig();
    int currentVersion = 0;
    if (!kIsWeb){
      final PackageInfo info = await PackageInfo.fromPlatform();
      currentVersion = int.parse(info.buildNumber);
      if (_config.data.latestVersion < currentVersion)
        isBeta = true;
    }
    if (!kIsWeb) {
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

    }

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
              Utilities.formatArgumentString(
                AppLocalizations.of(context).translate('authenticateToLogin'),
                arg: userFullName
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

  bool _isUserExcludedFromStop (String user)
    => _config.data.stopExceptions.indexOf(int.parse(userID)) >= 0;

  Future<void> doLogin() async {
    if (_config.data.stopEnabled == "1"
        && !_isUserExcludedFromStop(userID)){
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => SobreroDialogNoAction(
          headingWidget: Icon(
            TablerIcons.info_circle,
            color: Theme.of(context).primaryColor,
            size: 35,
          ),
          title: "mySobrero è ${_config.data.stopType}",
          content: Text(
              _config.data.stopDescription
          ),
        ),
      );
      return;
    }

    loginStructure = await reAPI4.instance.getStartupData(
      username: userID,
      password: userPassword,
    );
    if (loginStructure.status.code != 0){
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
          content: Text(loginStructure.status.description),
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
    prefs.setString('user', loginStructure.user.fullname);
    prefs.setInt('marks1Count', loginStructure.marks_firstperiod.length);
    prefs.setInt('marks2Count', loginStructure.marks_finalperiod.length);
    prefs.setInt('assignmentsCount', loginStructure.assignments.length);
    prefs.setInt('noticesCount', loginStructure.notices.length);

    final accountType = loginStructure.user.level == "4" ? "student" : "parent";

    await CloudConnector.registerSession(
      uid: userID,
      name: loginStructure.user.name,
      surname: loginStructure.user.surname,
      currentClass: loginStructure.user.fullclass,
      course: loginStructure.user.course,
      level: accountType,
      token: reAPI4.instance.getSession(),
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
            session: reAPI4.instance.getSession(),
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
            //unifiedLoginStructure: loginStructure,
            //apiInstance: apiInstance,
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
                          Utilities.formatArgumentString(
                            AppLocalizations.of(context).translate('loginAs'),
                            arg: userFullName ?? "",
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
                        suffixIcon: Icon(TablerIcons.lock_open),
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
                        suffixIcon: Icon(TablerIcons.lock_open),
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