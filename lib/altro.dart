import 'package:flutter/material.dart';
import 'reapi2.dart';
import 'assenze.dart';
import 'argomenti.dart';

class AltroView extends StatefulWidget {
  reAPI2 response;

  AltroView(reAPI2 response) {
    this.response = response;
  }
  @override
  _AltroView createState() => _AltroView(response);
}

class _AltroView extends State<AltroView> {
  reAPI2 response;
  _AltroView(reAPI2 response) {
    this.response = response;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
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
              )
            ],
          ),
        ),
      ],
    ));
  }
}
