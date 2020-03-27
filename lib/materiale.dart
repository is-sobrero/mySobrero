import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'fade_slide_transition.dart';
import 'reapi3.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class MaterialeView extends StatefulWidget {
  reAPI3 apiInstance;
  MaterialeView({Key key, @required this.apiInstance}) : super(key: key);

  @override
  _MaterialeState createState() => _MaterialeState();
}

class _MaterialeState extends State<MaterialeView> with SingleTickerProviderStateMixin {
  //List<MaterialeDocente> reMateriale;

  Future<List<DocenteStructure>> _materiale;

  final double _listAnimationIntervalStart = 0.65;
  final double _preferredAppBarHeight = 56.0;

  AnimationController _fadeSlideAnimationController;
  ScrollController _scrollController;
  double _appBarElevation = 0.0;
  double _appBarTitleOpacity = 0.0;


  @override
  void initState() {
    super.initState();
    _fadeSlideAnimationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
    _scrollController = ScrollController()..addListener(() {
      double oldElevation = _appBarElevation;
      double oldOpacity = _appBarTitleOpacity;
      _appBarElevation = _scrollController.offset > _scrollController.initialScrollOffset ? 4.0 : 0.0;
      _appBarTitleOpacity = _scrollController.offset > _scrollController.initialScrollOffset + _preferredAppBarHeight / 2 ? 1.0 : 0.0;
      if (oldElevation != _appBarElevation || oldOpacity != _appBarTitleOpacity) setState(() {});
    });
    _materiale = widget.apiInstance.retrieveMateriale();
  }

  @override
  void dispose() {
    _fadeSlideAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _launchURL(String uri) async {
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: "materiale_background",
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: AnimatedOpacity(
              opacity: _appBarTitleOpacity,
              duration: const Duration(milliseconds: 250),
              child: Text("Materiale didattico", style: TextStyle(color: Colors.white)),
            ),
            backgroundColor: Color(0xffe55039),
            elevation: _appBarElevation,
            brightness: Brightness.dark,
            leading: BackButton(color: Colors.white,),
          ),
          backgroundColor: Color(0xffe55039),
          body: SafeArea(
            bottom: false,
            child: Column(children: <Widget>[
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollBehavior(),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20,),
                    child: Column(
                      children: <Widget>[
                        FadeSlideTransition(
                          controller: _fadeSlideAnimationController,
                          slideAnimationTween: Tween<Offset>(
                            begin: Offset(0.0, 0.5),
                            end: Offset(0.0, 0.0),
                          ),
                          begin: 0.0,
                          end: _listAnimationIntervalStart,
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Materiale didattico",
                                style: Theme.of(context).textTheme.title.copyWith(
                                    fontSize: 32.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ),
                        FadeSlideTransition(
                            controller: _fadeSlideAnimationController,
                            slideAnimationTween: Tween<Offset>(
                              begin: Offset(0.0, 0.05),
                              end: Offset(0.0, 0.0),
                            ),
                            begin: _listAnimationIntervalStart - 0.15,
                            child: Padding(

                                padding: EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    FutureBuilder<List<DocenteStructure>>(
                                      future: _materiale,
                                      builder: (context, snapshot){
                                        switch (snapshot.connectionState){
                                          case ConnectionState.none:
                                          case ConnectionState.active:
                                          case ConnectionState.waiting:
                                            return Padding(
                                              padding: const EdgeInsets.all(15.0),
                                              child: Center(
                                                child: Column(
                                                  children: <Widget>[
                                                    SpinKitDualRing(
                                                      color: Colors.white,
                                                      size: 40,
                                                      lineWidth: 5,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 8.0),
                                                      child: Text("Sto caricando il materiale...", style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center,),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          case ConnectionState.done:
                                            if (snapshot.hasError) {
                                              return Padding(
                                                padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 15),
                                                child: Column(
                                                  children: <Widget>[
                                                    Icon(Icons.warning, size: 40, color: Colors.white,),
                                                    Text("${snapshot.error}", style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center,),
                                                  ],
                                                ),
                                              );
                                            }
                                            return ListView.builder(
                                                primary: false,
                                                shrinkWrap: true,
                                                itemCount: snapshot.data.length,
                                                itemBuilder: (context, index){
                                                  return Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.only(bottom: 10, top: 5),
                                                        child: Text(
                                                            snapshot.data[index].docente,
                                                            style: TextStyle(
                                                                fontSize: 24,
                                                                color: Colors.white)
                                                        ),
                                                      ),
                                                      ListView.builder(
                                                        primary: false,
                                                        shrinkWrap: true,
                                                        itemCount: snapshot.data[index].cartelle.length,
                                                        itemBuilder: (ctx, i){
                                                          return Padding(
                                                              padding: const EdgeInsets.only(bottom: 15),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        color: Colors.black.withAlpha(20),
                                                                        blurRadius: 10,
                                                                        spreadRadius: 10
                                                                    )
                                                                  ],
                                                                ),
                                                                child: ExpandableNotifier(
                                                                    child: Expandable(
                                                                      collapsed: ExpandableButton(
                                                                          child: Container(
                                                                            decoration: new BoxDecoration(
                                                                              //color: Colors.white.withAlpha(20),
                                                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                color: Color(0xffe55039)
                                                                              //border: Border.all(width: 1.0, color: Colors.white)
                                                                            ),
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(15),
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(right: 5),
                                                                                    child: Icon(Icons.folder_open, color: Colors.white),
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                        snapshot.data[index].cartelle[i].descrizione,
                                                                                        style: TextStyle(
                                                                                            fontSize: 18,
                                                                                            fontWeight:
                                                                                            FontWeight.bold,
                                                                                            color: Colors.white
                                                                                        )
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          )
                                                                      ),
                                                                      expanded: Container(
                                                                        decoration: new BoxDecoration(
                                                                          color: Color(0xffe55039),
                                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                          //border: Border.all(width: 1.0, color: Colors.white)
                                                                        ),
                                                                        child: Column(
                                                                          children: <Widget>[
                                                                            ExpandableButton(
                                                                                child: Container(
                                                                                  decoration: new BoxDecoration(
                                                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(15),
                                                                                    child: Row(
                                                                                      children: <Widget>[
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(right: 5),
                                                                                          child: Icon(Icons.folder_open, color: Colors.black),
                                                                                        ),
                                                                                        Expanded(
                                                                                          child: Text(
                                                                                              snapshot.data[index].cartelle[i].descrizione,
                                                                                              style: TextStyle(
                                                                                                  fontSize: 18,
                                                                                                  fontWeight:
                                                                                                  FontWeight.bold,
                                                                                                  color: Colors.black
                                                                                              )
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                            ),
                                                                            FutureBuilder<List<FileStructure>>(
                                                                                future: widget.apiInstance.retrieveContenutiCartella(snapshot.data[index].id, snapshot.data[index].cartelle[i].idCartella),
                                                                                builder: (context, snapshot){
                                                                                  if (snapshot.hasData){
                                                                                    return snapshot.data.length > 0 ?ListView.builder(
                                                                                      primary: false,
                                                                                      shrinkWrap: true,
                                                                                      itemCount: snapshot.data.length,
                                                                                      itemBuilder: (c, i2){
                                                                                        //return Text(snapshot.data[i2].nome);
                                                                                        return FlatButton(
                                                                                            padding: EdgeInsets.zero,
                                                                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(15.0),
                                                                                              child: Row(
                                                                                                children: <Widget>[
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(right: 8.0),
                                                                                                    child: Icon(Icons.insert_drive_file, color: Colors.white),
                                                                                                  ),
                                                                                                  Expanded(child: Text(snapshot.data[i2].nome, style: TextStyle(color: Colors.white),)),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            onPressed: (){
                                                                                              _launchURL(snapshot.data[i2].url);
                                                                                            }
                                                                                        );
                                                                                      },
                                                                                    ) : Padding(
                                                                                      padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 15),
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Icon(Icons.cloud_queue, size: 40, color: Colors.white,),
                                                                                          Text("La cartella è vuota", style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center,),
                                                                                        ],
                                                                                      ),
                                                                                    );
                                                                                  } else if (snapshot.hasError) {
                                                                                    return Padding(
                                                                                      padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 15),
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Icon(Icons.error_outline, size: 40, color: Colors.white,),
                                                                                          Text("${snapshot.error}", style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center,),
                                                                                        ],
                                                                                      ),
                                                                                    );
                                                                                  }
                                                                                  return Padding(
                                                                                    padding: const EdgeInsets.all(15.0),
                                                                                    child: Column(
                                                                                      children: <Widget>[
                                                                                        SpinKitDualRing(
                                                                                          color: Colors.white,
                                                                                          size: 40,
                                                                                          lineWidth: 5,
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(top: 15.0),
                                                                                          child: Text("Sto caricando i contenuti...", style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center,),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  );
                                                                                }
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),

                                                                    )
                                                                ),
                                                              )
                                                          );
                                                        },
                                                      )
                                                    ],
                                                  );
                                                },
                                            );
                                        }
                                        return null;

                                        /*
                                        ListView.builder(
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount: reMateriale.length,
                                      itemBuilder: (context, index){
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 10, top: 5),
                                              child: Text(
                                                  reMateriale[index].docente,
                                                  style: TextStyle(
                                                      fontSize: 24,
                                                      color: Colors.white)
                                              ),
                                            ),
                                            ListView.builder(
                                              primary: false,
                                              shrinkWrap: true,
                                              itemCount: reMateriale[index].cartelle.length,
                                              itemBuilder: (ctx, i){
                                                //return Text(reMateriale[index].cartelle[i].descrizione);
                                                return Padding(
                                                    padding: const EdgeInsets.only(bottom: 15),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors.black.withAlpha(20),
                                                              blurRadius: 10,
                                                              spreadRadius: 10
                                                          )
                                                        ],
                                                      ),
                                                      child: ExpandableNotifier(
                                                          child: Expandable(
                                                            collapsed: ExpandableButton(
                                                                child: Container(
                                                                  decoration: new BoxDecoration(
                                                                      //color: Colors.white.withAlpha(20),
                                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                      color: Color(0xffe55039)
                                                                      //border: Border.all(width: 1.0, color: Colors.white)
                                                                  ),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(15),
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(right: 5),
                                                                          child: Icon(Icons.folder_open, color: Colors.white),
                                                                        ),
                                                                        Expanded(
                                                                          child: Text(
                                                                              reMateriale[index].cartelle[i].descrizione,
                                                                              style: TextStyle(
                                                                                  fontSize: 18,
                                                                                  fontWeight:
                                                                                  FontWeight.bold,
                                                                                  color: Colors.white
                                                                              )
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                            ),
                                                            expanded: Container(
                                                              decoration: new BoxDecoration(
                                                                  color: Color(0xffe55039),
                                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                  //border: Border.all(width: 1.0, color: Colors.white)
                                                              ),
                                                              child: Column(
                                                                children: <Widget>[
                                                                  ExpandableButton(
                                                                      child: Container(
                                                                        decoration: new BoxDecoration(
                                                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                            color: Colors.white,
                                                                        ),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(15),
                                                                          child: Row(
                                                                            children: <Widget>[
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(right: 5),
                                                                                child: Icon(Icons.folder_open, color: Colors.black),
                                                                              ),
                                                                              Expanded(
                                                                                child: Text(
                                                                                    reMateriale[index].cartelle[i].descrizione,
                                                                                    style: TextStyle(
                                                                                        fontSize: 18,
                                                                                        fontWeight:
                                                                                        FontWeight.bold,
                                                                                        color: Colors.black
                                                                                    )
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                                  ),
                                                                  FutureBuilder<List<File>>(
                                                                      future: _ottieniFile(widget.userID, reMateriale[index].id, reMateriale[index].cartelle[i].id.toString()),
                                                                      builder: (context, snapshot){
                                                                        if (snapshot.hasData){
                                                                          return snapshot.data.length > 0 ?ListView.builder(
                                                                            primary: false,
                                                                            shrinkWrap: true,
                                                                            itemCount: snapshot.data.length,
                                                                            itemBuilder: (c, i2){
                                                                              //return Text(snapshot.data[i2].nome);
                                                                              return FlatButton(
                                                                                  padding: EdgeInsets.zero,
                                                                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(15.0),
                                                                                    child: Row(
                                                                                      children: <Widget>[
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(right: 8.0),
                                                                                          child: Icon(Icons.insert_drive_file, color: Colors.white),
                                                                                        ),
                                                                                        Expanded(child: Text(snapshot.data[i2].nome, style: TextStyle(color: Colors.white),)),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  onPressed: (){
                                                                                    _launchURL(snapshot.data[i2].url);
                                                                                  }
                                                                              );
                                                                            },
                                                                          ) : Padding(
                                                                            padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 15),
                                                                            child: Column(
                                                                              children: <Widget>[
                                                                                Icon(Icons.cloud_queue, size: 40, color: Colors.white,),
                                                                                Text("La cartella è vuota", style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center,),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        } else if (snapshot.hasError) {
                                                                          return Padding(
                                                                            padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 15),
                                                                            child: Column(
                                                                              children: <Widget>[
                                                                                Icon(Icons.error_outline, size: 40, color: Colors.white,),
                                                                                Text("${snapshot.error}", style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center,),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        }
                                                                        return Padding(
                                                                          padding: const EdgeInsets.all(15.0),
                                                                          child: Column(
                                                                            children: <Widget>[
                                                                              SpinKitDualRing(
                                                                                color: Colors.white,
                                                                                size: 40,
                                                                                lineWidth: 5,
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 15.0),
                                                                                child: Text("Sto caricando i contenuti...", style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center,),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      }
                                                                  )
                                                                ],
                                                              ),
                                                            ),

                                                          )
                                                      ),
                                                    )
                                                );
                                              },
                                            )
                                          ],
                                        );
                                      },
                                    )
                                         */
                                      },
                                    )
                                  ],
                                )))
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ),
        )
    );
  }
}
