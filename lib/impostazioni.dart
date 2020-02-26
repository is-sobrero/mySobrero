import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mySobrero/reapi2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'fade_slide_transition.dart';
import 'skeleton.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart' as globals;
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';


class ImpostazioniView extends StatefulWidget {
  reAPI2 response;
  String profileURL;
  Function(String url) profileCallback;
  @override
  _ImpostazioniState createState() => _ImpostazioniState(response, profileURL, profileCallback);

  ImpostazioniView (reAPI2 response, String profileURL, Function(String url) profileCallback){
    this.response = response;
    this.profileURL = profileURL;
    this.profileCallback = profileCallback;
  }
}

class _ImpostazioniState extends State<ImpostazioniView> with SingleTickerProviderStateMixin {
  final double _listAnimationIntervalStart = 0.65;
  final double _preferredAppBarHeight = 56.0;
  Function(String url) profileCallback;

  AnimationController _fadeSlideAnimationController;
  ScrollController _scrollController;
  double _appBarElevation = 0.0;
  double _appBarTitleOpacity = 0.0;

  _ImpostazioniState (reAPI2 response, String profileURL, Function(String url) profileCallback){
    this.response = response;
    _profileURL = profileURL;
    this.profileCallback = profileCallback;
  }

  @override
  void initState() {
    super.initState();
    _configuraSalvate();
    _fadeSlideAnimationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _appBarElevation = _scrollController.offset > _scrollController.initialScrollOffset ? 4.0 : 0.0;
          _appBarTitleOpacity = _scrollController.offset > _scrollController.initialScrollOffset + _preferredAppBarHeight / 2 ? 1.0 : 0.0;
        });
      });
  }

  int lenBio;

  @override
  void dispose() {
    _fadeSlideAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _configuraSalvate() async {
    var localAuth = LocalAuthentication();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool bio = await prefs.getBool("biometric_auth") ?? false;
    List<BiometricType> availableBiometrics = await localAuth.getAvailableBiometrics();
    setState(() {
      bioAuth = bio;
      lenBio = availableBiometrics.length;

    });
    if (lenBio == 0) _impostaBool("biometric_auth", false);

  }

  final StorageReference _firebaseStorage = FirebaseStorage.instance.ref();
  reAPI2 response;

  Future cambiaProfilo() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    final userName = response.user.matricola;
    final StorageUploadTask uploadTask = _firebaseStorage.child("profile_$userName.jpg").putFile(
      image,
      StorageMetadata(
        contentType: "image/jpeg",
      ),
    );
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print('URL Is $url');

    setState(() {
      globals.profileURL = url;
      profileCallback(_profileURL);
    });

    Firestore.instance.collection('utenti').document(response.user.matricola).setData({
      'profileImage': url,
    }, merge: true);

  }

  bool bioAuth = false;
  String _profileURL;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Column(children: <Widget>[
              FadeSlideTransition(
                controller: _fadeSlideAnimationController,
                slideAnimationTween: Tween<Offset>(
                  begin: Offset(0.0, 0.5),
                  end: Offset(0.0, 0.0),
                ),
                begin: 0.0,
                end: _listAnimationIntervalStart,
                child: PreferredSize(
                  preferredSize: Size.fromHeight(_preferredAppBarHeight),
                  child: AppBar(
                    title: AnimatedOpacity(
                      opacity: _appBarTitleOpacity,
                      duration: const Duration(milliseconds: 250),
                      child: Text(
                        "Impostazioni",
                      ),
                    ),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    elevation: _appBarElevation,
                    leading: BackButton(
                      color: Theme.of(context).textTheme.body1.color,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollBehavior(),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      10,
                      20,
                      20,
                    ),
                    child: Column(
                      children: <Widget>[
                        FadeSlideTransition(
                          controller: _fadeSlideAnimationController,
                          slideAnimationTween: Tween<Offset>(
                            begin: Offset(0.0, 0.5),
                            end: Offset(0.0, 0.0),
                          ),
                          begin: 0.0,
                          end: _listAnimationIntervalStart,
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Impostazioni",
                                style: Theme.of(context).textTheme.title.copyWith(fontSize: 32.0, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        FadeSlideTransition(
                            controller: _fadeSlideAnimationController,
                            slideAnimationTween: Tween<Offset>(
                              begin: Offset(0.0, 0.05),
                              end: Offset(0.0, 0.0),
                            ),
                            begin: _listAnimationIntervalStart - 0.15,
                            child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Stack(
                                      alignment: Alignment.bottomRight,
                                      children: <Widget>[
                                        ClipOval(
                                          child: new Container(
                                              width: 100,
                                              height: 100,
                                              color: Theme.of(context).scaffoldBackgroundColor,
                                              child: globals.profileURL != null
                                                  ? CachedNetworkImage(
                                                      imageUrl: globals.profileURL,
                                                      placeholder: (context, url) => Skeleton(),
                                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.asset("assets/images/profile.jpg")),
                                        ),
                                        Container(
                                            width: 40.0,
                                            height: 40.0,
                                            child: new RawMaterialButton(
                                              shape: new CircleBorder(),
                                              elevation: 5.0,
                                              fillColor: Theme.of(context).primaryColor,
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              onPressed: () {
                                                cambiaProfilo();
                                              },
                                            ))
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(response.user.nome + " " + response.user.cognome, style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                                    ),
                                    SettingsButton(Icons.exit_to_app, "Logout", "Cancella l'account memorizzato dall'app", () {
                                      _impostaBool("savedCredentials", false);

                                    }),
                                    ToggleButton(Icons.fingerprint, "Usa autenticazione biometrica", lenBio > 0 ? "Accedi all'app tramite autenticazione biometrica" : "Nessun metodo di accesso configurato", () {
                                      setState(() {
                                          bioAuth = !bioAuth;
                                        _impostaBool("biometric_auth", bioAuth);
                                      });
                                    }, bioAuth, lenBio > 0),
                                    SettingsButton(Icons.info, "Informazioni su mySobrero", "Ottieni informazioni sull'app", () {
                                      showDialog(context: context, builder: (BuildContext builder) {
                                        final ThemeData themeData = Theme.of(context);
                                        final TextStyle linkStyle = themeData.textTheme.body1.copyWith(color: themeData.accentColor);

                                        return AlertDialog(
                                          title: Text("Informazioni su mySobrero"),
                                            actions: <Widget>[
                                              // usually buttons at the bottom of the dialog
                                              new FlatButton(
                                                child: new Text("CHIUDI", style: TextStyle(color: Theme.of(context).primaryColor)),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          content: Column (
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                             RichText(
                                                text: TextSpan(
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      style: Theme.of(context).textTheme.body1,
                                                      text: 'mySobrero 2.0 - L\'app pensata appositamente per gli studenti del Sobrero - sviluppata da Federico Runco (4 AE - ',
                                                    ),
                                                    _LinkTextSpan(
                                                        style: linkStyle,
                                                        url: 'mailto:s00802@sobrero.it',
                                                        text: 's00802@sobrero.it'
                                                    ),
                                                    TextSpan(
                                                      style: Theme.of(context).textTheme.body1,
                                                      text: ').\n\nIl codice sorgente dell\'applicazione è disponibile su Github ',
                                                    ),
                                                    _LinkTextSpan(
                                                      style: linkStyle,
                                                      url: 'https://github.com/federunco/mySobrero',
                                                      text: 'a questo indirizzo'
                                                    ),
                                                    TextSpan(
                                                      style: Theme.of(context).textTheme.body1,
                                                      text: '.',
                                                    ),
                                                  ],

                                              ),
                                            ),
                                          ],)
                                        );
                                      });
                                    }),
                                  ],
                                )))
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  _impostaBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }
}

class SettingsButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String caption;
  final Function onPressed;

  SettingsButton(this.icon, this.title, this.caption, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(

      textColor: Theme.of(context).primaryColor,
      padding: EdgeInsets.fromLTRB(0, 15.0, 0 , 15),
      onPressed: this.onPressed,
      child: Row(
        children: <Widget>[
          Icon(this.icon),
          SizedBox(width: 20.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(this.title),
              SizedBox(height: 5.0),
              Text(this.caption, style: Theme.of(context).textTheme.caption),
            ],
          ),
        ],
      ),
    );
  }
}

class ToggleButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String caption;
  final Function onPressed;
  final bool booleanState;
  final bool enabled;


  ToggleButton(this.icon, this.title, this.caption, this.onPressed, this.booleanState, this.enabled);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      textColor: Theme.of(context).primaryColor,
      padding: EdgeInsets.fromLTRB(0, 15.0, 0 , 15),
      onPressed: enabled ? this.onPressed : null,
      child: Row(
        children: <Widget>[
          Icon(this.icon),
          SizedBox(width: 20.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(this.title),
                SizedBox(height: 5.0),
                Text(this.caption, style: Theme.of(context).textTheme.caption, softWrap: true,),
              ],
            ),
          ),
          Switch(
            value: enabled ? booleanState : false,
            onChanged: enabled ? (val){

            } : null,
          )
        ],
      ),
    );
  }
}

class _LinkTextSpan extends TextSpan {

  // Beware!
  //
  // This class is only safe because the TapGestureRecognizer is not
  // given a deadline and therefore never allocates any resources.
  //
  // In any other situation -- setting a deadline, using any of the less trivial
  // recognizers, etc -- you would have to manage the gesture recognizer's
  // lifetime and call dispose() when the TextSpan was no longer being rendered.
  //
  // Since TextSpan itself is @immutable, this means that you would have to
  // manage the recognizer from outside the TextSpan, e.g. in the State of a
  // stateful widget that then hands the recognizer to the TextSpan.

  _LinkTextSpan({ TextStyle style, String url, String text }) : super(
      style: style,
      text: text ?? url,
      recognizer: TapGestureRecognizer()..onTap = () {
        launch(url, forceSafariVC: false);
      }
  );
}

