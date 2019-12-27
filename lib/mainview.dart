import 'package:flutter/material.dart';

class Mainview extends StatefulWidget {
  @override
  _Mainview createState() => _Mainview();
}

class _Mainview extends State<Mainview> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Ciao Federico!',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                  ),
              ),
              Text('Classe 4 AE - Elettronica ed Elettrotecnica',),
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
                                    "9",
                                  style: new TextStyle(
                                    fontSize: 70,
                                    color: Color(0xFFFFFFFF)
                                  ),
                                ),
                                Text(
                                    "Ultimo voto preso in Elettronica ed Elettrotecnica",
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
                                  "0",
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
            ],
          ),
        ),
      ),
    );
  }
}