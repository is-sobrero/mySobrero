import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mySobrero/compiti.dart';
import 'reapi2.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'SobreroFeed.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'skeleton.dart';

typedef SwitchPageCallback = void Function(int page);

class Mainview extends StatefulWidget {
  reAPI2 response;
  SobreroFeed feed;
  SwitchPageCallback callback;
  List<Compiti> compitiSettimana;

  Mainview(reAPI2 response, SobreroFeed feed, SwitchPageCallback callback) {
    this.response = response;
    this.feed = feed;
    this.callback = callback;
    this.compitiSettimana = List<Compiti>();
    DateTime today = DateTime.now();
    bool okLista = false;
    var inizioSettimana = today.subtract(new Duration(days: today.weekday - 1));
    var formatter = new DateFormat('DD/MM/yyyy');
    for (int i = 0; i < response.compiti.length; i++) {
      DateTime dataCompito = formatter.parse(response.compiti[i].data);
      if (dataCompito.compareTo(inizioSettimana) >= 0) okLista = true;
      if (okLista) this.compitiSettimana.add(response.compiti[i]);
    }
  }

  @override
  _Mainview createState() =>
      _Mainview(response, feed, callback, compitiSettimana);
}

class _Mainview extends State<Mainview> {
  reAPI2 response;
  SobreroFeed feed;
  SwitchPageCallback callback;
  List<Compiti> compitiSettimana;

  _Mainview(reAPI2 response, SobreroFeed feed, SwitchPageCallback callback,
      List<Compiti> compitiSettimana) {
    this.response = response;
    this.feed = feed;
    this.callback = callback;
    this.compitiSettimana = compitiSettimana;
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

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
  }

  @override
  Widget build(BuildContext context) {
    final nomeUtente = response.user.nome;
    var ultimoVoto = "null";
    var ultimaMateria = "null";
    if (response.voti.length > 0){
      ultimoVoto = response.voti[0].voto;
      ultimaMateria = response.voti[0].materia;
    }
    final classeUtente =
        response.user.classe.toString() + " " + response.user.sezione.trim();
    final indirizzoUtente = response.user.corso;
    final ultimaComunicazione =
        response.comunicazioni[0].contenuto.substring(0, 100) + "...";
    final ultimaComMittente = response.comunicazioni[0].mittente;
    final accountStudente = response.user.livello == "4";
    bool isWide = MediaQuery.of(context).size.width > 500;
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              !accountStudente
                  ? Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Container(
                                decoration: new BoxDecoration(
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Color(0xFFFF416C)
                                              .withOpacity(0.4),
                                          offset: const Offset(1.1, 1.1),
                                          blurRadius: 10.0),
                                    ],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(11)),
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
                                      children: <Widget>[
                                        RichText(
                                          text: TextSpan(
                                            style: new TextStyle(
                                                color: Colors.white),
                                            children: [
                                              WidgetSpan(
                                                child: Icon(
                                                  Icons.warning,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    "  Hai eseguito l'accesso al mySobrero con le credenziali per genitori, questo può provocare errori inaspettati. Effettua il logout e riaccedi con le credenziali da studente.",
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 6),
                                          child: Text(
                                            "Se non hai a disposizione le credenziali a te riservate puoi andare a richiederle in Segreteria Amministrativa.",
                                            style: new TextStyle(
                                                color: Color(0xFFFFFFFF)),
                                          ),
                                        )
                                      ],
                                    ))),
                          ),
                          flex: 1,
                        ),
                      ],
                    )
                  : Container(),
              Text(
                'Ciao $nomeUtente!',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  'Classe $classeUtente - $indirizzoUtente',
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
                                callback(1);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    decoration: new BoxDecoration(
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: Color(0xFFfa709a)
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
                                                fontSize: 70,
                                                color: Color(0xFFFFFFFF)),
                                          ) : new Container(),
                                          Text(
                                            ultimoVoto != "null" ? "Ultimo voto preso di $ultimaMateria" : "Nessun voto per il periodo corrente",
                                            style: new TextStyle(
                                                color: Color(0xFFFFFFFF)),
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
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return CompitiView(
                                      response.compiti, compitiSettimana);
                                }));
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
                                                    color: Color(0xFF43e97b)
                                                        .withOpacity(0.4),
                                                    offset:
                                                        const Offset(1.1, 1.1),
                                                    blurRadius: 10.0),
                                              ],
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(11)),
                                              gradient: LinearGradient(
                                                begin:
                                                    FractionalOffset.topRight,
                                                end: FractionalOffset
                                                    .bottomRight,
                                                colors: <Color>[
                                                  Color(0xFF38f9d7),
                                                  Color(0xFF43e97b)
                                                ],
                                              )),
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
                                              compitiSettimana.length
                                                  .toString(),
                                              style: new TextStyle(
                                                  fontSize: 70,
                                                  color: Color(0xFF000000)),
                                            ),
                                            Text(
                                              "Compiti per i prossimi giorni",
                                              style: new TextStyle(
                                                  color: Color(0xFF000000)),
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
                          ),
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
                              callback(2);
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
                                              "Ultima comunicazione da $ultimaComMittente",
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
              )
            ],
          ),
        ),
        Container(
          color: Theme.of(context).brightness == Brightness.dark
              ? Color(0x2F000000)
              : Color(0x10000000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 20, bottom: 15),
                child: Text("Ultime dal Sobrero",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              Container(
                height: 400,
                child: ListView.builder(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    itemCount: feed.items.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext ctxt, int index) {
                      final item = feed.items[index];
                      return Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Theme.of(context).textTheme.body1.color,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 0,
                          margin: EdgeInsets.only(right: 10),
                          clipBehavior: Clip.antiAlias,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: Container(
                            width: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Expanded(
                                    child: CachedNetworkImage(
                                  imageUrl: item.thumbnail,
                                  placeholder: (context, url) =>
                                      Skeleton(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  fit: BoxFit.cover,
                                )),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        item.title.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      OutlineButton(
                                          child: Text("LEGGI"),
                                          onPressed: () =>
                                              openURL(context, item.link))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ));
                    }),
              )
            ],
          ),
        )
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
