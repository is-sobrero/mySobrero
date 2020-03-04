import 'package:flutter/material.dart';
import 'package:mySobrero/pagelle.dart';
import 'package:mySobrero/ricercaaule.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'reapi2.dart';
import 'assenze.dart';
import 'argomenti.dart';
import 'materiale.dart';

class AltroView extends StatefulWidget {
  reAPI2 response;

  AltroView(reAPI2 response) {
    this.response = response;
  }
  @override
  _AltroView createState() => _AltroView(response);
}

class _AltroView extends State<AltroView> with AutomaticKeepAliveClientMixin<AltroView>{
  @override
  bool get wantKeepAlive => true;

  reAPI2 response;
  _AltroView(reAPI2 response) {
    this.response = response;
  }

  @override
  Widget build(BuildContext context) {
    int columnCount = MediaQuery.of(context).size.width > 550 ? 2 : 1;
    return SingleChildScrollView(
        child: SafeArea(
          top: false,
          child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Altro',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                    ),
                  ),
                ),
                WaterfallFlow.count(
                  primary: false,
                  shrinkWrap: true,
                  crossAxisCount: columnCount,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return AssenzeView(response.assenze);
                        }));
                      },
                      child: Hero(
                        tag: "assenze_background",
                        child: Container(
                          decoration: new BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Color(0xffff9692).withOpacity(0.4),
                                  offset: const Offset(1.1, 1.1),
                                  blurRadius: 10.0),
                            ],
                          ),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 0,
                              margin: EdgeInsets.only(bottom: 10),
                              clipBehavior: Clip.antiAlias,
                              color: Color(0xffff9692),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Text("Assenze",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                  ),
                                  Spacer(),
                                  Image.asset(
                                    "assets/images/assenze.png",
                                    height: 150,
                                  )
                                ],
                              )),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ArgomentiView(response.argomenti)),
                        );
                      },
                      child: Hero(
                        tag: "argomenti_background",
                        child: Container(
                          decoration: new BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Color(0xFF5352ed).withOpacity(0.2),
                                  offset: const Offset(1.1, 1.1),
                                  blurRadius: 10.0),
                            ],
                          ),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 0,
                              margin: EdgeInsets.only(bottom: 10),
                              clipBehavior: Clip.antiAlias,
                              color: Color(0xFF5352ed),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Text("Argomenti",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ),
                                  Spacer(),
                                  Image.asset(
                                    "assets/images/argomenti.png",
                                    height: 150,
                                    width: 200,
                                  )
                                ],
                              )),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MaterialeView(reMateriale: response.materiale, userID: response.session,)),
                        );
                      },
                      child: Hero(
                        tag: "materiale_background",
                        child: Container(
                          decoration: new BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Color(0xffe55039).withOpacity(0.2),
                                  offset: const Offset(1.1, 1.1),
                                  blurRadius: 10.0),
                            ],
                          ),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 0,
                              margin: EdgeInsets.only(bottom: 10),
                              clipBehavior: Clip.antiAlias,
                              color: Color(0xffe55039),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Text("Materiale didattico",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ),
                                  Spacer(),
                                  Image.asset(
                                    "assets/images/material.png",
                                    height: 150,
                                    width: 150,
                                  )
                                ],
                              )),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RicercaAuleView()),
                        );
                      },
                      child: Hero(
                        tag: "ricercaaule_background",
                        child: Container(
                          decoration: new BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Color(0xffF86925).withOpacity(0.2),
                                  offset: const Offset(1.1, 1.1),
                                  blurRadius: 10.0),
                            ],
                          ),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 0,
                              margin: EdgeInsets.only(bottom: 10),
                              clipBehavior: Clip.antiAlias,
                              color: Color(0xffF86925),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Text("Ricerca aule",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ),
                                  Spacer(),
                                  Image.asset(
                                    "assets/images/ricercaaule.png",
                                    height: 150,
                                    width: 170,
                                  )
                                ],
                              )),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PagelleView(response.pagelle)),
                        );
                      },
                      child: Hero(
                        tag: "pagelle_background",
                        child: Container(
                          decoration: new BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Color(0xff38ada9).withOpacity(0.2),
                                  offset: const Offset(1.1, 1.1),
                                  blurRadius: 10.0),
                            ],
                          ),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 0,
                              margin: EdgeInsets.only(bottom: 10),
                              clipBehavior: Clip.antiAlias,
                              color: Color(0xff38ada9),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Text("Pagelle",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ),
                                  Spacer(),
                                  Image.asset(
                                    "assets/images/pagelle.png",
                                    height: 150,
                                    fit: BoxFit.fitWidth,
                                    width: 200,
                                  )
                                ],
                              )),
                        ),
                      ),
                    )
                  ],
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 5,
                )

              ],
            ),
          ),
      ],
    ),
        ));
  }
}
