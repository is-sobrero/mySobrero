import 'package:flutter/material.dart';
import 'package:mySobrero/compiti.dart';
import 'reapi.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'SobreroFeed.dart';

typedef SwitchPageCallback = void Function(int page);

class Mainview extends StatefulWidget {
  reAPI response;
  SobreroFeed feed;
  SwitchPageCallback callback;

  Mainview(reAPI response, SobreroFeed feed, SwitchPageCallback callback) {
    this.response = response;
    this.feed = feed;
    this.callback = callback;
  }

  @override
  _Mainview createState() => _Mainview(response, feed, callback);
}

class _Mainview extends State<Mainview> {
  reAPI response;
  SobreroFeed feed;
  SwitchPageCallback callback;

  _Mainview(reAPI response, SobreroFeed feed, SwitchPageCallback callback) {
    this.response = response;
    this.feed = feed;
    this.callback = callback;
  }

  @override
  Widget build(BuildContext context) {
    final nomeUtente = response.user.nome;
    final ultimoVoto = response.voti[0].voto;
    final ultimaMateria = response.voti[0].materia;
    final countCompiti = response.compiti.length.toString();
    final classeUtente = response.user.classe + " " + response.user.sezione;
    final indirizzoUtente = response.user.corso;
    final ultimaComunicazione =
        response.comunicazioni[0].contenuto.substring(0, 100) + "...";
    final ultimaComMittente = response.comunicazioni[0].mittente;
    final accountStudente = true;

    return SingleChildScrollView(
        /*child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: */
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
              Row(
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
                                      color: Color(0xFFfa709a).withOpacity(0.4),
                                      offset: const Offset(1.1, 1.1),
                                      blurRadius: 10.0),
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(11)),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    ultimoVoto,
                                    style: new TextStyle(
                                        fontSize: 70, color: Color(0xFFFFFFFF)),
                                  ),
                                  Text(
                                    "Ultimo voto preso in $ultimaMateria",
                                    style:
                                        new TextStyle(color: Color(0xFFFFFFFF)),
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
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return Compiti();
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
                                            offset: const Offset(1.1, 1.1),
                                            blurRadius: 10.0),
                                      ],
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(11)),
                                      gradient: LinearGradient(
                                        begin: FractionalOffset.topRight,
                                        end: FractionalOffset.bottomRight,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      countCompiti,
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
                    /*Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: new BoxDecoration(
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Color(0xFF43e97b)
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
                                  Color(0xFF38f9d7),
                                  Color(0xFF43e97b)
                                ],
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  countCompiti,
                                  style: new TextStyle(
                                      fontSize: 70, color: Color(0xFF000000)),
                                ),
                                Text(
                                  "Compiti per i prossimi giorni",
                                  style:
                                      new TextStyle(color: Color(0xFF000000)),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),*/

                    flex: 1,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        callback(2);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: AspectRatio(
                          aspectRatio: 2,
                          child: Container(
                            decoration: new BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Color(0xFFc471f5).withOpacity(0.4),
                                      offset: const Offset(1.1, 1.1),
                                      blurRadius: 10.0),
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(11)),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    ultimaComunicazione,
                                    style: new TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFFFFFF)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: Text(
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
                    flex: 1,
                  ),
                ],
              ),
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
                                  child: Image.network(
                                    item.thumbnail,
                                    width: 300.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
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
