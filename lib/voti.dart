import 'package:flutter/material.dart';
import 'reapi.dart';

class VotiView extends StatefulWidget {
  List<Voti> voti;
  VotiView(List<Voti> voti){
    this.voti = voti;
  }
  @override
  _VotiView createState() => _VotiView(voti);
}

class _VotiView extends State<VotiView> {
  List<Voti> voti;
  _VotiView(List<Voti> voti){
    this.voti = voti;
  }

  List<Widget> generaVoti(){
    /*return Column(
      children: <Widget>[
        Text("Prova")
      ],
    );*/
    List<Widget> list = new List<Widget>();
    for(var i = 0; i < voti.length; i++){
      list.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(11)),
                  gradient: LinearGradient(
                    begin: FractionalOffset.topRight,
                    end: FractionalOffset.bottomRight,
                    colors: <Color>[Color(0xFF38f9d7), Color(0xFF43e97b)],
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Text(voti[i].voto, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black)),
                    ),
                    Expanded(
                        child: Text(voti[i].materia, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black) ))
                  ],
                ),
              ),
            ),
          )
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Tutti i voti',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                    ),
                  ),
                  Column(children: generaVoti())
                ],
              ),
            ),


          ],
        )
    );
  }
}