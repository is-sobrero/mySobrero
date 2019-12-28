import 'package:flutter/material.dart';
import 'reapi.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'SobreroFeed.dart';

class Mainview extends StatefulWidget {
  reAPI response;
  SobreroFeed feed;
  Mainview(reAPI response, SobreroFeed feed){
    this.response = response;
    this.feed = feed;
  }
  @override
  _Mainview createState() => _Mainview(response, feed);
}

class _Mainview extends State<Mainview> {
  reAPI response;
  SobreroFeed feed;
  _Mainview(reAPI response, SobreroFeed feed){
    this.response = response;
    this.feed = feed;
  }
  @override
  Widget build(BuildContext context) {
    final nomeUtente = response.user.nome;
    final ultimoVoto = response.voti[0].voto;
    final ultimaMateria = response.voti[0].materia;
    final countCompiti = response.compiti.length.toString();
    final classeUtente = response.user.classe + " " + response.user.sezione;
    final indirizzoUtente = response.user.corso;
    final ultimaComunicazione = response.comunicazioni[0].contenuto.substring(0, 100) + "...";
    final ultimaComMittente = response.comunicazioni[0].mittente;

    return SingleChildScrollView(
        /*child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: */
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text('Classe $classeUtente - $indirizzoUtente',),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(11)),
                                  gradient: LinearGradient(
                                    begin: FractionalOffset.topRight,
                                    end: FractionalOffset.bottomRight,
                                    colors: <Color>[Color(0xFFfee140), Color(0xFFfa709a)],
                                  )

                              )
                              ,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      ultimoVoto,
                                      style: new TextStyle(
                                          fontSize: 70,
                                          color: Color(0xFFFFFFFF)
                                      ),
                                    ),
                                    Text(
                                      "Ultimo voto preso in $ultimaMateria",
                                      style: new TextStyle(
                                          color: Color(0xFFFFFFFF)
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(11)),
                                  gradient: LinearGradient(
                                    begin: FractionalOffset.topRight,
                                    end: FractionalOffset.bottomRight,
                                    colors: <Color>[Color(0xFF38f9d7), Color(0xFF43e97b)],
                                  )

                              )
                              ,
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
                                          color: Color(0xFF000000)
                                      ),
                                    ),
                                    Text(
                                      "Compiti per i prossimi giorni",
                                      style: new TextStyle(
                                          color: Color(0xFF000000)
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: AspectRatio(
                            aspectRatio: 2,
                            child: Container(
                              decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(11)),
                                  gradient: LinearGradient(
                                    begin: FractionalOffset.topRight,
                                    end: FractionalOffset.bottomRight,
                                    colors: <Color>[Color(0xFFfa71cd), Color(0xFFc471f5)],
                                  )
                              )
                              ,
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
                                          color: Color(0xFFFFFFFF)
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: Text(
                                        "Ultima comunicazione da $ultimaComMittente",
                                        style: new TextStyle(
                                            color: Color(0xFFFFFFFF)
                                        ),
                                      ),
                                    )
                                  ],
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
              color: Color(0x22000000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 20, bottom: 15),
                    child: Text(
                        "Ultime dal Sobrero",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                    ),
                  ),
                  Container(
                    height: 400,
                    child: ListView.builder(
                        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
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
                              color: Theme.of(context).backgroundColor,
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                              onPressed: () => openURL(context, item.link)
                                          )
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              )
                          );
                        }),
                  )
                ],
              ),
            )

          ],
        )
    );
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
          animation: new CustomTabsAnimation.slideIn(),
        extraCustomTabs: <String>[
          // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
          'org.mozilla.firefox',
          // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
          'com.microsoft.emmx',
        ],
      ),
    );
    } catch (e) {
    // An exception is thrown if browser app is not installed on Android device.
    debugPrint(e.toString());
    }
  }
}