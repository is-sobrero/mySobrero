// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'skeleton.dart';
import 'package:image_picker/image_picker.dart';
import 'globals.dart' as globals;
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mySobrero/hud.dart';
import 'package:mySobrero/cloud_connector/cloud2.dart';
import 'package:mySobrero/common/sobreroicons.dart';
import 'package:mySobrero/common/tiles.dart';
import 'package:mySobrero/common/utilities.dart';
import 'package:mySobrero/reapi3.dart';
import 'package:mySobrero/ui/button.dart';
import 'package:mySobrero/ui/detail_view.dart';
import 'package:mySobrero/ui/dialogs.dart';
import 'package:mySobrero/ui/list_button.dart';
import 'package:mySobrero/agreement/agreement_dialog.dart';

class ImpostazioniView extends StatefulWidget {
  String session;
  String profileURL;
  Function(String url) profileCallback;
  UnifiedLoginStructure unifiedLoginStructure;

  ImpostazioniView ({
    Key key,
    @required this.session,
    @required this.unifiedLoginStructure,
    @required this.profileURL,
    @required this.profileCallback
  }) : super(key: key);

  @override
  _ImpostazioniState createState() => _ImpostazioniState();
}

class _ImpostazioniState extends State<ImpostazioniView> {
  @override
  void initState() {
    super.initState();
    _configuraSalvate();
  }

  int lenBio = 0;

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

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<bool> cambiaProfilo(image) async {
    bool res = await CloudConnector.setProfilePicture(
      token: widget.session,
      image: image,
    );

    setState(() {
      globals.profileURL = "url";
      widget.profileCallback(_profileURL);
    });

    return true;
  }

  bool bioAuth = false;
  String _profileURL;

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return SobreroDetailView(
      title: "Impostazioni",
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                ClipOval(
                  child: Container(
                    width: 130,
                    height: 130,
                    child: CachedNetworkImage(
                      imageUrl: globals.profileURL,
                      placeholder: (a, b) => Skeleton(),
                      errorWidget: (a, b, c) =>
                          Image.asset("assets/images/profile.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: 40.0,
                  height: 40.0,
                  child: new RawMaterialButton(
                    shape: new CircleBorder(),
                    elevation: 5.0,
                    fillColor: Theme.of(context).primaryColor,
                    child: Icon(
                      LineIcons.pencil,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => picker.getImage(
                      source: ImageSource.gallery,
                      imageQuality: 70,
                    ).then((file){
                      if (file != null) showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (c) => dialogoHUD(
                          future: cambiaProfilo(file),
                          titolo: "Aggiornamento dell'immagine di profilo in corso...",
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                widget.unifiedLoginStructure.user.nomeCompleto,
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold,),
              ),
            ),
            SobreroFlatTile(
              margin: EdgeInsets.only(top: 15),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 7),
                        child: Icon(
                          LineIcons.user,
                          size: 25,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        "Account",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
                SobreroListButton(
                  title: "Logout",
                  caption: "Cancella l'account memorizzato da mySobrero",
                  icon: LineIcons.sign_out,
                  onPressed: () => showModalBottomSheet(
                    isDismissible: false,
                    context: context,
                    builder: (context) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              "assets/images/logout.png",
                              width: 250,
                            ),
                          ),
                          //TODO: responsive logout
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                            child: Text(
                              "Proseguo con la disconnessione da mySobrero?",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: 220,
                            child: SobreroButton(
                              color: Colors.red,
                              text: "Continua con il logout",
                              onPressed: (){
                                Navigator.of(context).pop();
                                final snackBar = SnackBar(
                                  content: Text(
                                    "Verrai disconnesso da mySobrero alla chiusura completa dell'applicazione",
                                    textAlign: TextAlign.center,
                                  ),
                                  duration: Duration(seconds: 3),
                                );
                                scaffoldKey.currentState.showSnackBar(snackBar);
                                _impostaBool("savedCredentials", false);
                                _impostaBool("agreementAccepted", false);
                              },
                            ),
                          ),
                          SafeArea(
                            top: false,
                            bottom: true,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Per annullare il logout, scorri in basso la finestra di dialogo",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                  )
                ),
                SobreroListToggle(
                  onChanged: (b) => setState(() {
                    bioAuth = b;
                    _impostaBool("biometric_auth", bioAuth);
                  }),
                  value: bioAuth,
                  title: "Usa autenticazione biometrica",
                  caption: lenBio > 0 ?
                    "Accedi all'app tramite autenticazione biometrica" :
                    "Nessun metodo di accesso configurato",
                  icon: LineIcons.lock,
                  enabled: lenBio > 0,
                  showBorder: false,
                ),
              ],
            ),
            SobreroFlatTile(
              margin: EdgeInsets.only(top: 10),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 7),
                        child: Icon(
                          LineIcons.gears,
                          size: 25,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        "Generali",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
                SobreroListButton(
                  onPressed: () => openURL(
                    context,
                    "https://forms.gle/tDt4RZD1XWK5kkH39",
                  ),
                  title: "Lascia un feedback",
                  caption: "Scrivi un feedback o un suggerimento per l'app (solo con account @sobrero)",
                  icon: LineIcons.smile_o,
                ),
                //TODO: termini di utilizzo
                SobreroListButton(
                  onPressed: () => Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___)  => AgreementScreen(
                        isInformative: true,
                      ),
                      transitionDuration: Duration(milliseconds: 1000),
                      transitionsBuilder: (ctx, prim, sec, child) =>
                          SharedAxisTransition(
                        animation: prim,
                        secondaryAnimation: sec,
                        transitionType: SharedAxisTransitionType.scaled,
                        child: child,
                      ),
                    ),
                  ),
                  title: "Termini di utilizzo",
                  caption: "Consulta i termini di utilizzo di mySobrero",
                  icon: SobreroIcons2.handshake,
                ),
                SobreroListButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => SobreroDialogSingle(
                      title: "Informazioni su mySobrero",
                      headingWidget: Icon(
                        LineIcons.info,
                        size: 40,
                        color: Theme.of(context).primaryColor,
                      ),
                      //headingImage: "assets/images/errore.png",
                      buttonCallback: () => Navigator.of(context).pop(),
                      buttonText: "Chiudi",
                      content: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              style: Theme.of(context).textTheme.bodyText1,
                              text: 'mySobrero 2.0 - L\'app per gli studenti del Sobrero - sviluppata da Federico Runco (4 AE - ',
                            ),
                            _LinkTextSpan(
                              style: Theme.of(context).textTheme.bodyText1
                                  .copyWith(
                                color: Theme.of(context).primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                              url: 'mailto:s00802@sobrero.it',
                              text: 's00802@sobrero.it',
                            ),
                            TextSpan(
                              style: Theme.of(context).textTheme.bodyText1,
                              text: ').\n\nIl codice sorgente dell\'applicazione è disponibile su Github ',
                            ),
                            _LinkTextSpan(
                              style: Theme.of(context).textTheme.bodyText1
                                  .copyWith(
                                color: Theme.of(context).primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                              url: 'https://github.com/is-sobrero/mySobrero',
                              text: 'a questo indirizzo',
                            ),
                            TextSpan(
                              style: Theme.of(context).textTheme.bodyText1,
                              text: '.',
                            ),
                          ],

                        ),
                      ),
                    ),
                  ),
                  title: "Informazioni su mySobrero",
                  caption: "Ottieni informazioni sull'app",
                  icon: LineIcons.info,
                  showBorder: false,

                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _impostaBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
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

