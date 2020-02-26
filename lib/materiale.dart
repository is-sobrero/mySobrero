import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'fade_slide_transition.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'reapi2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:async/async.dart';

class MaterialeView extends StatefulWidget {

  final List<MaterialeDocente> reMateriale;
  final String userID;

  MaterialeView({Key key, @required this.reMateriale, @required this.userID}) : super(key: key);

  @override
  _MaterialeState createState() => _MaterialeState();
}

class _MaterialeState extends State<MaterialeView> with SingleTickerProviderStateMixin {
  List<MaterialeDocente> reMateriale;

  final double _listAnimationIntervalStart = 0.65;
  final double _preferredAppBarHeight = 56.0;

  AnimationController _fadeSlideAnimationController;
  ScrollController _scrollController;
  double _appBarElevation = 0.0;
  double _appBarTitleOpacity = 0.0;

  Brightness currentBrightness;

  @override
  void initState() {
    super.initState();
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    _fadeSlideAnimationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
    _scrollController = ScrollController()..addListener(() {
        setState(() {
          _appBarElevation = _scrollController.offset > _scrollController.initialScrollOffset ? 4.0 : 0.0;
          _appBarTitleOpacity = _scrollController.offset > _scrollController.initialScrollOffset + _preferredAppBarHeight / 2 ? 1.0 : 0.0;
        });
    });
    reMateriale = widget.reMateriale;
  }

  @override
  void dispose() {
    _fadeSlideAnimationController.dispose();
    _scrollController.dispose();
    if (currentBrightness == Brightness.dark)
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    super.dispose();
  }

  Future<List<File>> _ottieniFile(String session, String idDocente, String idCartella) async {
    final endpointCartella = 'https://reapistaging.altervista.org/api/v3/getContenutiCartella/';
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    final response = await http.post(
        endpointCartella,
        headers: headers,
        body: {'session': session, 'idDocente':idDocente, 'idCartella': idCartella});
    print({'session': session, 'idDocente':idDocente, 'idCartella': idCartella}.toString());
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)["files"];
      return jsonResponse.map((file) => new File.fromJson(file)).toList();
    } else {
      throw Exception('Impossibile caricare il contenuto della cartella (${json.decode(response.body)["status"]["description"]})');
    }
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
    currentBrightness = Theme.of(context).brightness;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: "materiale_background",
            child: Container(color: Color(0xffe55039),),
          ),
          SafeArea(
            child: Column(children: <Widget>[
              FadeSlideTransition(
                controller: _fadeSlideAnimationController,
                slideAnimationTween: Tween<Offset>(
                  begin: Offset(0.0, 0.5),
                  end: Offset(0.0, 0.0),
                ),
                begin: 0.0,
                end: _listAnimationIntervalStart,
                child: PreferredSize(
                  preferredSize: Size.fromHeight(_preferredAppBarHeight),
                  child: AppBar(
                    title: AnimatedOpacity(
                      opacity: _appBarTitleOpacity,
                      duration: const Duration(milliseconds: 250),
                      child: Text("Materiale didattico", style: TextStyle(color: Colors.white)),
                    ),
                    backgroundColor: Color(0xffe55039),
                    elevation: _appBarElevation,
                    leading: BackButton(color: Colors.white,),
                  ),
                ),
              ),
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
                                                  child: ExpandableNotifier(
                                                      child: Expandable(
                                                        collapsed: ExpandableButton(
                                                            child: Container(
                                                              decoration: new BoxDecoration(
                                                                  color: Colors.white.withAlpha(20),
                                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                  border: Border.all(width: 1.0, color: Colors.white)),
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
                                                                color: Colors.white.withAlpha(20),
                                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                border: Border.all(width: 1.0, color: Colors.white)),
                                                            child: Column(
                                                              children: <Widget>[
                                                                ExpandableButton(
                                                                  child: Container(
                                                                    decoration: new BoxDecoration(
                                                                        color: Colors.white,
                                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(15),
                                                                      child: Row(
                                                                        children: <Widget>[
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(right: 5),
                                                                            child: Icon(Icons.folder_open, color: Colors.black,),
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
                                                                  ),
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
                                                                    return CircularProgressIndicator(backgroundColor: Colors.white,);
                                                                }
                                                                )
                                                              ],
                                                            ),
                                                          ),

                                                      )
                                                  )
                                                );
                                              },
                                            )
                                            /*ExpandableNotifier(
                                              child: Expandable(
                                                collapsed: ExpandableButton(
                                                  child: Text("ESPANDAMI")
                                                ),
                                                expanded: ExpandableButton(
                                                  child: Text("COMPRIMIMI"),
                                                ),
                                              )
                                            )*/
                                          ],
                                        );
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
        ],
      ),
    );
  }
}
