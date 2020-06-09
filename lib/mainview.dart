import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mySobrero/FeedDetail.dart';
import 'package:mySobrero/compiti.dart';
import 'package:mySobrero/expandedsection.dart';
import 'package:mySobrero/reapi3.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'SobreroFeed.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'skeleton.dart';
import 'globals.dart' as globals;

typedef SwitchPageCallback = void Function(int page);

class Mainview extends StatefulWidget {
  //reAPI2 response;
  UnifiedLoginStructure unifiedLoginStructure;
  reAPI3 apiInstance;
  SobreroFeed feed;
  SwitchPageCallback callback;
  List<CompitoStructure> compitiSettimana;
  String profileUrl;

  Mainview({Key key, @required this.unifiedLoginStructure, @required this.apiInstance, @required this.feed, @required this.callback, @required this.profileUrl}) {
    DateTime today = DateTime.now();
    bool okLista = false;
    var inizioSettimana = today.subtract(new Duration(days: today.weekday - 1));
    var formatter = new DateFormat('DD/MM/yyyy');
    compitiSettimana = List<CompitoStructure>();
    for (int i = 0; i < unifiedLoginStructure.compiti.length; i++) {
      DateTime dataCompito = formatter.parse(unifiedLoginStructure.compiti[i].data);
      if (dataCompito.compareTo(inizioSettimana) >= 0) okLista = true;
      if (okLista) this.compitiSettimana.add(unifiedLoginStructure.compiti[i]);
    }
  }

  static _Mainview of(BuildContext context) => context.findAncestorStateOfType<_Mainview>();

  @override
  _Mainview createState() => _Mainview();
}

final stateMain = new GlobalKey<_Mainview>();

class RemoteNotice {
  bool enabled;
  String description;
  bool bottomNoticeEnabled;
  String bottomNoticeTitle;
  String bottomNotice;
  String bottomNoticeHeadingURL;
  String bottomNoticeLinkTitle;
  String bottomNoticeLink;

  RemoteNotice(
      {this.enabled,
        this.description,
        this.bottomNoticeEnabled,
        this.bottomNoticeTitle,
        this.bottomNotice,
        this.bottomNoticeHeadingURL,
        this.bottomNoticeLinkTitle,
        this.bottomNoticeLink});

  RemoteNotice.fromJson(Map<String, dynamic> json) {
    enabled = json['enabled'];
    description = json['description'];
    bottomNoticeEnabled = json['bottomNoticeEnabled'];
    bottomNoticeTitle = json['bottomNoticeTitle'];
    bottomNotice = json['bottomNotice'];
    bottomNoticeHeadingURL = json['bottomNoticeHeadingURL'];
    bottomNoticeLinkTitle = json['bottomNoticeLinkTitle'];
    bottomNoticeLink = json['bottomNoticeLink'];
  }

  RemoteNotice.preFetch(){
    enabled = false;
    description = "";
    bottomNoticeEnabled = false;
    bottomNoticeTitle = "";
    bottomNotice = "";
    bottomNoticeHeadingURL = "";
    bottomNoticeLinkTitle = "";
    bottomNoticeLink = "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['enabled'] = this.enabled;
    data['description'] = this.description;
    data['bottomNoticeEnabled'] = this.bottomNoticeEnabled;
    data['bottomNoticeTitle'] = this.bottomNoticeTitle;
    data['bottomNotice'] = this.bottomNotice;
    data['bottomNoticeHeadingURL'] = this.bottomNoticeHeadingURL;
    data['bottomNoticeLinkTitle'] = this.bottomNoticeLinkTitle;
    data['bottomNoticeLink'] = this.bottomNoticeLink;
    return data;
  }
}

class _Mainview extends State<Mainview> with AutomaticKeepAliveClientMixin<Mainview>{
  @override
  bool get wantKeepAlive => true;

  /*reAPI2 response;
  SobreroFeed feed;
  SwitchPageCallback callback;*/
  //String _profileURL; g

  _Mainview() {}

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String infoAggiuntiveTXT = "";
  bool disponibiliInfo = false;

  Future<RemoteNotice> ottieniInformazioniAggiuntive() async{
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    await remoteConfig.fetch(expiration: const Duration(seconds: 0));
    await remoteConfig.activateFetched();
    final notice = jsonDecode(remoteConfig.getString('notice_setting'));
    return RemoteNotice.fromJson(notice);
  }

  @override
  void dispose(){
    _parentNoticeRecognizer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _parentNoticeRecognizer = TapGestureRecognizer()..onTap = (){
      setState((){
        expandedParentNotice = !expandedParentNotice;
      });
    };
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print(token);
    });

    ottieniInformazioniAggiuntive().then((notice){
      setState((){
        remoteNotice = notice;
      });
    });
  }

  RemoteNotice remoteNotice = RemoteNotice.preFetch();
  bool expandedParentNotice = false;
  TapGestureRecognizer _parentNoticeRecognizer;
  @override
  Widget build(BuildContext context) {
    Widget immagineProfilo = Container(
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
            width: 50,
            height: 50,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: globals.profileURL != null ? CachedNetworkImage(
              imageUrl: globals.profileURL,
              placeholder: (context, url) =>
                  Skeleton(),
              errorWidget: (context, url, error) =>
                  Icon(Icons.error),
              fit: BoxFit.cover,
            ) : Image.asset("assets/images/profile.jpg")
        ),
      ),
    );
    final nomeUtente = widget.unifiedLoginStructure.user.nome;
    var ultimoVoto = "null";
    var ultimaMateria = "null";
    if (widget.unifiedLoginStructure.voti1Q.length > 0){
      ultimoVoto = widget.unifiedLoginStructure.voti1Q[0].votoTXT;
      ultimaMateria = widget.unifiedLoginStructure.voti1Q[0].materia;
    }
    if (widget.unifiedLoginStructure.voti2Q.length > 0){
      ultimoVoto = widget.unifiedLoginStructure.voti2Q[0].votoTXT;
      ultimaMateria = widget.unifiedLoginStructure.voti2Q[0].materia;
    }
    final classeUtente = widget.unifiedLoginStructure.user.classe.toString() + " " + widget.unifiedLoginStructure.user.sezione.trim();
    final indirizzoUtente = widget.unifiedLoginStructure.user.corso;
    var ultimaComunicazione = widget.unifiedLoginStructure.comunicazioni[0].contenuto;
    if (ultimaComunicazione.length > 100) ultimaComunicazione = ultimaComunicazione.substring(0, 100) + "...";
    final ultimaComMittente = widget.unifiedLoginStructure.comunicazioni[0].mittente;
    String realDestinatario = "Dirigente";
    if (ultimaComMittente.toUpperCase() != "DIRIGENTE") realDestinatario = "Gianni Rossi";
    final accountStudente = widget.unifiedLoginStructure.user.livello == "4";
    bool isWide = MediaQuery.of(context).size.width > 550;

    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                !accountStudente ? Padding(
                  padding: EdgeInsets.only(bottom: remoteNotice.enabled ? 10 : 0),
                  child: Container(
                    decoration: new BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Color(0xFFFF416C).withOpacity(0.4),
                            offset: const Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(11)),
                                  gradient: LinearGradient(
                                    begin: FractionalOffset.topRight,
                                    end: FractionalOffset.bottomRight,
                                    colors: <Color>[
                                      Color(0xFFFF416C),
                                      Color(0xFFFF4B2B),
                                    ],
                                  )),
                              child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(color: Colors.white, width: 1.0,)
                                              )
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 5.0),
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.error,
                                                  size: 25,
                                                  color: Colors.white,
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 8.0,),
                                                    child: Text("Attenzione", style: new TextStyle(
                                                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16
                                                    ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      RichText(
                                        text: new TextSpan(
                                          children: [
                                            new TextSpan(
                                              text: "Hai eseguito l'accesso a mySobrero con le credenziali da genitore. ",
                                              style: new TextStyle(color: Colors.white),
                                            ),
                                            TextSpan(
                                              text: expandedParentNotice ? "Per saperne di meno" : "Per saperne di più...",
                                              style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.white, decoration: TextDecoration.underline),
                                              recognizer: _parentNoticeRecognizer
                                            ),
                                          ],
                                        ),
                                      ),
                                      ExpandedSection(
                                        expand: expandedParentNotice,
                                        child:  Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text("Utilizzando le credenziali da genitore mySobrero continua a funzionare, ma alcune funzionalità potrebbero non essere disponibili, come la selezione dello studente, i sondaggi interni o l'accesso a Resell@Sobrero.\nSe sei uno studente e stai usando le credenziali dei tuoi genitori, richiedi le credenziali a te riservate in Segreteria Amministrativa per sfruttare al massimo mySobrero.", style: TextStyle(color: Colors.white)),
                                        ),
                                      )
                                    ],
                                  ))),
                          flex: 1,
                        ),
                      ],
                    ),
                  ),
                ) : Container(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Ciao $nomeUtente!',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 24,
                              ),
                            ),
                            Text('Classe $classeUtente - $indirizzoUtente',),
                          ],
                        ),
                      ),
                     immagineProfilo
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: remoteNotice.enabled ? 10 : 0),
                  child: Container(
                    decoration: new BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Color(0xFFff5858).withOpacity(0.4),
                            offset: const Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: ExpandedSection(
                      expand: remoteNotice.enabled,
                      debug: true,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                                decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(11)),
                                    gradient: LinearGradient(
                                      begin: FractionalOffset.topRight,
                                      end: FractionalOffset.bottomRight,
                                      colors: <Color>[
                                        Color(0xFFff5858),
                                        Color(0xFFf09819),
                                      ],
                                    )),
                                child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(color: Colors.white, width: 1.0,)
                                                )
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(bottom: 5.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.info_outline,
                                                    size: 25,
                                                    color: Colors.white,
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 8.0,),
                                                      child: Text("Informazioni per gli studenti", style: new TextStyle(
                                                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16
                                                      ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(remoteNotice.description, style: TextStyle(color: Colors.white)),
                                      ],
                                    ))),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Flex(
                  direction: isWide ? Axis.horizontal : Axis.vertical,
                  children: <Widget>[
                    Expanded(
                      flex: isWide ? 1 : 0,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  widget.callback(1);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Container(
                                      decoration: new BoxDecoration(
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: Color(0xFFfa709a).withOpacity(0.4),
                                                offset: const Offset(1.1, 1.1),
                                                blurRadius: 10.0),
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(11)),
                                          gradient: LinearGradient(
                                            begin: FractionalOffset.topRight,
                                            end: FractionalOffset.bottomRight,
                                            colors: <Color>[
                                              Color(0xFFfee140),
                                              Color(0xFFfa709a)
                                            ],
                                          )),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            ultimoVoto != "null" ? Text(
                                              ultimoVoto,
                                              style: new TextStyle(
                                                  fontSize: 65,
                                                  color: Color(0xFFFFFFFF)),
                                            ) : new Container(),
                                            AutoSizeText(
                                              ultimoVoto != "null" ? "Ultimo voto preso di $ultimaMateria" : "Nessun voto per il periodo corrente",
                                              style: new TextStyle(
                                                  color: Color(0xFFFFFFFF), fontSize: 14),
                                              maxLines: 2,
                                              minFontSize: 7,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(11)),
                                  child: OpenContainer(
                                    tappable: true,
                                    closedColor: Color(0xFF43e97b),
                                    openColor: Color(0xFF43e97b),
                                    transitionDuration: Duration(milliseconds: 300),
                                    openBuilder: (ctx, action) => CompitiView(
                                      compiti: widget.unifiedLoginStructure.compiti,
                                      settimana: widget.compitiSettimana,
                                    ),
                                    closedBuilder: (ctx, action) => Stack(
                                      children: <Widget>[
                                        AspectRatio(
                                          aspectRatio: 1,
                                          child: Container(
                                            decoration: new BoxDecoration(
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                      color: Color(0xFF43e97b).withOpacity(0.4),
                                                      offset: const Offset(1.1, 1.1),
                                                      blurRadius: 10.0),
                                                ],
                                                gradient: LinearGradient(
                                                  begin:
                                                  FractionalOffset.topRight,
                                                  end: FractionalOffset.bottomRight,
                                                  colors: <Color>[
                                                    Color(0xFF38f9d7),
                                                    Color(0xFF43e97b)
                                                  ],
                                                )
                                            ),

                                          ),
                                        ),
                                        AspectRatio(
                                          aspectRatio: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  widget.compitiSettimana.length.toString(),
                                                  style: new TextStyle(
                                                      fontSize: 70,
                                                      color: Color(0xFF000000)),
                                                ),
                                                Text(
                                                  "Compiti per i prossimi giorni",
                                                  style: new TextStyle(color: Color(0xFF000000)),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            /*Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CompitiView(
                                        compiti: widget.unifiedLoginStructure.compiti,
                                        settimana: widget.compitiSettimana,
                                      ),
                                      fullscreenDialog: true,
                                    )
                                  );
                                },
                                child: Stack(
                                  children: <Widget>[
                                    Hero(
                                      tag: "compiti_background",
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: Container(
                                            decoration: new BoxDecoration(
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                      color: Color(0xFF43e97b).withOpacity(0.4),
                                                      offset: const Offset(1.1, 1.1),
                                                      blurRadius: 10.0),
                                                ],
                                                borderRadius: BorderRadius.all(Radius.circular(11)),
                                                gradient: LinearGradient(
                                                  begin:
                                                      FractionalOffset.topRight,
                                                  end: FractionalOffset.bottomRight,
                                                  colors: <Color>[
                                                    Color(0xFF38f9d7),
                                                    Color(0xFF43e97b)
                                                  ],
                                                )
                                                ),

                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                widget.compitiSettimana.length.toString(),
                                                style: new TextStyle(
                                                    fontSize: 70,
                                                    color: Color(0xFF000000)),
                                              ),
                                              Text(
                                                "Compiti per i prossimi giorni",
                                                style: new TextStyle(color: Color(0xFF000000)),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              flex: 1,
                            ),*/
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: isWide ? 1 : 0,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                widget.callback(2);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: isWide ? 10.0 : 0),
                                  child: AspectRatio(
                                    aspectRatio: 2,
                                    child: Container(
                                      decoration: new BoxDecoration(
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: Color(0xFFc471f5)
                                                    .withOpacity(0.4),
                                                offset: const Offset(1.1, 1.1),
                                                blurRadius: 10.0),
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(11)),
                                          gradient: LinearGradient(
                                            begin: FractionalOffset.topRight,
                                            end: FractionalOffset.bottomRight,
                                            colors: <Color>[
                                              Color(0xFFfa71cd),
                                              Color(0xFFc471f5)
                                            ],
                                          )),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 8.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(100.0),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors.black.withAlpha(50),
                                                              blurRadius: 10,
                                                              spreadRadius: 4,
                                                              offset: Offset(0, 2)
                                                          )
                                                        ]
                                                    ),
                                                    child: ultimaComMittente.toUpperCase() == "DIRIGENTE" ?
                                                    CircleAvatar(
                                                      backgroundImage: AssetImage("assets/images/rota.png"),
                                                      radius: 15,
                                                    ) :
                                                    CircleAvatar(
                                                      child: Text("GR", style: TextStyle(color: Colors.black)),
                                                      backgroundColor: Colors.white,
                                                      radius: 15,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 8.0),
                                                    child: Text(toBeginningOfSentenceCase(realDestinatario), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                                                  )
                                                ],
                                              ),
                                            ),
                                            AutoSizeText(
                                              ultimaComunicazione,
                                              minFontSize: 12,
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,
                                              style: new TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFFFFFFFF)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 12.0),
                                              child: AutoSizeText(
                                                "Ultima comunicazione ricevuta",
                                                style: new TextStyle(
                                                    color: Color(0xFFFFFFFF)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          color: Theme.of(context).brightness == Brightness.dark ? Color(0xFF212121) : Color(0xFFfafafa),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 20,),
                  child: Text("Ultime dal Sobrero",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
              ),
              Container(
                height: 450,
                child: ListView.builder(
                    padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 16),
                    itemCount: widget.feed.items.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext ctxt, int index) {
                      final item = widget.feed.items[index];

                      return SafeArea(
                        bottom: false,
                        left: index == 0,
                        right: index == widget.feed.items.length -1,
                        top: false,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).cardColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(30),
                                  blurRadius: 10,
                                  spreadRadius: 5
                                )
                              ]
                            ),

                            width: 300,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: OpenContainer(
                                  closedColor: Theme.of(context).scaffoldBackgroundColor,
                                  openColor: Theme.of(context).scaffoldBackgroundColor,
                                  closedBuilder: (c, action) => Stack(
                                    alignment: Alignment.bottomLeft,
                                    children: <Widget>[
                                      Positioned.fill(
                                        child: CachedNetworkImage(
                                          imageUrl: item.thumbnail,
                                          placeholder: (context, url) => Skeleton(),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                                  color: Theme.of(context).textTheme.body1.color.withAlpha(40),
                                                  width: 300,
                                                  child: Center(child: Icon(Icons.broken_image, size: 70))
                                              ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Container(
                                        width: 300,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: [Colors.black87, Colors.transparent],
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter
                                            )
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(15,30,15,25),
                                          child: Text(
                                            item.title,
                                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  openBuilder: (c, action) => FeedDetailView(articolo: widget.feed.items[index]),
                                  tappable: true
                              )
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
        SafeArea(
          top: false,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
            child: Container(
              //height: isWide ? 200 : null,
              decoration: new BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Color(0xFF6a11cb).withOpacity(Theme.of(context).brightness == Brightness.light ? 0.4 : 0),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(11)),
                  gradient: LinearGradient(
                    begin: FractionalOffset.topRight,
                    end: FractionalOffset.bottomRight,
                    colors: <Color>[
                      Color(0xFFfa71cd),
                      Color(0xFF6a11cb)
                    ],
                  )),
              child: isWide ? IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(11)),
                      child: Container(
                        width: 300,
                        color: Colors.red,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              child: CachedNetworkImage(
                                imageUrl: remoteNotice.bottomNoticeHeadingURL,
                                placeholder: (context, url) => Skeleton(),
                                errorWidget: (context, url, error) => Container(
                                        color: Theme.of(context).textTheme.body1.color.withAlpha(40),
                                        height: 200,
                                        child: Center(child: Icon(Icons.broken_image, size: 70, color: Colors.white,))
                                    ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                              child: Text(
                                remoteNotice.bottomNoticeTitle,
                                style: new TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFFFFFF)),
                              ),
                            ),
                            Text(
                              remoteNotice.bottomNotice,
                              style: new TextStyle(color: Color(0xFFFFFFFF)),
                            ),
                            FlatButton(
                              child: Row(
                                children: <Widget>[
                                  Text(remoteNotice.bottomNoticeLinkTitle, style: TextStyle(color: Colors.white),),
                                  Icon(Icons.arrow_forward_ios, color: Colors.white,)
                                ],
                              ),
                              onPressed: () => openURL(context, remoteNotice.bottomNoticeLink),
                              padding: EdgeInsets.zero,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ) : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(11)),
                    child: Container(
                      width: isWide ? 300 : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          CachedNetworkImage(
                            imageUrl: remoteNotice.bottomNoticeHeadingURL,
                            height: 200,
                            placeholder: (context, url) => Skeleton(),
                            errorWidget: (context, url, error) =>
                                Container(
                                    color: Theme.of(context).textTheme.body1.color.withAlpha(40),
                                    height: 200,
                                    child: Center(child: Icon(Icons.broken_image, size: 70, color: Colors.white,))
                                ),
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                          child: Text(
                            remoteNotice.bottomNoticeTitle,
                            style: new TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFFFFF)),
                          ),
                        ),
                        Text(
                          remoteNotice.bottomNotice,
                          style: new TextStyle(color: Color(0xFFFFFFFF)),
                        ),
                        FlatButton(
                          child: Row(
                            children: <Widget>[
                              Text(remoteNotice.bottomNoticeLinkTitle, style: TextStyle(color: Colors.white),),
                              Icon(Icons.arrow_forward_ios, color: Colors.white,)
                            ],
                          ),
                          onPressed: () => openURL(context, remoteNotice.bottomNoticeLink),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }

  void openURL(BuildContext context, String url) async {
    try {
      await launch(
        url,
        option: new CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          extraCustomTabs: <String>[
            'org.mozilla.firefox',
            'com.microsoft.emmx',
          ],
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
