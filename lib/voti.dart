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
                ],
              ),
            ),


          ],
        )
    );
  }
}