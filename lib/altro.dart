import 'package:flutter/material.dart';
import 'reapi.dart';
import 'assenze.dart';
import 'argomenti.dart';

class AltroView extends StatefulWidget {
  reAPI response;

  AltroView(reAPI response){
    this.response = response;
  }
  @override
  _AltroView createState() => _AltroView(response);
}

class _AltroView extends State<AltroView> {
  reAPI response;
  _AltroView(reAPI response){
    this.response = response;
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
                              child: Text(
                                  "Assenze",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                )
                              ),
                            ),
                            Spacer(),
                            Image.asset("assets/images/assenze.png", height: 150,)
                          ],
                        )
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ArgomentiView(response.regclasse)),
                      );
                    },
                    child: Hero(
                      tag: "argomenti_background",
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
                                child: Text(
                                    "Argomenti",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    )
                                ),
                              ),
                              Spacer(),
                              Image.asset("assets/images/argomenti.png", height: 150,)
                            ],
                          )
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        )
    );
  }
}