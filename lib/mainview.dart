import 'package:flutter/material.dart';
import 'reapi.dart';

class Mainview extends StatefulWidget {
  reAPI response;
  Mainview({Key key, @required this.response}) : super(key: key);
  @override
  _Mainview createState() => _Mainview(response);
}

class _Mainview extends State<Mainview> {
  reAPI response;
  _Mainview(reAPI response){
    this.response = response;
  }
  @override
  Widget build(BuildContext context) {
    final nomeUtente = response.user.nome;
    final ultimoVoto = response.voti[0].voto;
    final ultimaMateria = response.voti[0].materia;
    final countCompiti = response.compiti.length.toString();
    final classeUtente = response.user.classe + " " + response.user.sezione;
    final indirizzoUtente = response.user.corso;
    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
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

            ],
          ),
        ),
    );
  }
}