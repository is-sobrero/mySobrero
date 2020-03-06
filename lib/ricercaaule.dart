import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'fade_slide_transition.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

class RicercaAuleView extends StatefulWidget {

  RicercaAuleView({Key key}) : super(key: key);

  @override
  _RicercaAuleState createState() => _RicercaAuleState();
}

class FilterEntry {
  const FilterEntry(this.name, this.offset);
  final String name;
  final int offset;
}

class Aula {
  String id;
  String locale;
  String denominazione;
  bool computer;
  bool ethernet;
  bool prese;
  String piano;
  String plesso;

  Aula.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    locale = json['locale'];
    denominazione = json['denominazione'];
    computer = json['computer'];
    ethernet = json['ethernet'];
    prese = json['prese'];
    piano = json['piano'];
    plesso = json['plesso'];
  }
}

class _RicercaAuleState extends State<RicercaAuleView> with SingleTickerProviderStateMixin {

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
      double oldElevation = _appBarElevation;
      double oldOpacity = _appBarTitleOpacity;
      _appBarElevation = _scrollController.offset > _scrollController.initialScrollOffset ? 4.0 : 0.0;
      _appBarTitleOpacity = _scrollController.offset > _scrollController.initialScrollOffset + _preferredAppBarHeight / 2 ? 1.0 : 0.0;
      if (oldElevation != _appBarElevation || oldOpacity != _appBarTitleOpacity) setState(() {});
    });
  }

  @override
  void dispose() {
    _fadeSlideAnimationController.dispose();
    _scrollController.dispose();
    FlutterStatusbarcolor.setStatusBarWhiteForeground(currentBrightness == Brightness.dark);
    super.dispose();
  }

  Future<List<Aula>> _ottieniAule(String query, int filter) async {
    final endpointCartella = 'https://reapistaging.altervista.org/api/v3/searchAule?params=$filter&q=${Uri.encodeComponent(query)}';
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    final response = await http.get(endpointCartella, headers: headers);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)["results"];
      return jsonResponse.map((aula) => new Aula.fromJson(aula)).toList();
    } else {
      throw Exception('Impossibile ricercare le aule (${json.decode(response.body)["status"]["description"]})');
    }
  }

  final List<FilterEntry> _cast = <FilterEntry>[
    const FilterEntry('Prese', 0),
    const FilterEntry('Computer', 1),
    const FilterEntry('Ethernet', 2),
    const FilterEntry('Proiettore', 3),
    const FilterEntry('LIM', 4)
  ];

  int filterIndex = 0;

  Iterable<Widget> get filterWidgets sync* {
    for (FilterEntry entry in _cast) {
      yield Padding(
        padding: const EdgeInsets.only( right: 6),
        child: FilterChip(
          backgroundColor: Color(0xffd35400),
          selectedColor: Color(0xfff39c12),
          checkmarkColor: Colors.white,
          label: Text(entry.name, style: TextStyle(color: Colors.white)),
          selected: (filterIndex >> entry.offset & 1) > 0,
          onSelected: (bool value) {
            setState(() {
              if (value) {
                filterIndex |= 1 << entry.offset;
              } else {
                filterIndex &= ~(1 << entry.offset);
              }
              _risultatoAule = _ottieniAule(_searchController.text, filterIndex);
            });
          },
        ),
      );
    }
  }

  Future<List<Aula>> _risultatoAule;
  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    currentBrightness = Theme.of(context).brightness;
    AppBar titolo = AppBar(
      title: AnimatedOpacity(
        opacity: _appBarTitleOpacity,
        duration: const Duration(milliseconds: 250),
        child: Text("Ricerca aule", style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Color(0xffF86925),
      elevation: _appBarElevation,
      leading: BackButton(color: Colors.white,),
    );
    return Hero(
        tag: "ricercaaule_background",
        child: Scaffold(
          appBar: _fadeSlideAnimationController.isCompleted ? titolo : null,
          backgroundColor: Color(0xffF86925),
          body: SafeArea(
            bottom: !_fadeSlideAnimationController.isCompleted,
            child: Column(children: <Widget>[
              !_fadeSlideAnimationController.isCompleted ? FadeSlideTransition(
                controller: _fadeSlideAnimationController,
                slideAnimationTween: Tween<Offset>(
                  begin: Offset(0.0, 0.5),
                  end: Offset(0.0, 0.0),
                ),
                begin: 0.0,
                end: _listAnimationIntervalStart,
                child: PreferredSize(
                  preferredSize: Size.fromHeight(_preferredAppBarHeight),
                  child: titolo,
                ),
              ) : Container(),
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
                                "Ricerca aule",
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Theme(
                                            data: ThemeData(
                                              hintColor: Colors.white,
                                              primaryColor: Colors.white,
                                            ),
                                            child: TextField(
                                              cursorColor: Colors.white,
                                              style: new TextStyle(color: Colors.white),
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                                labelText: 'Aula da cercare',
                                                enabledBorder: const OutlineInputBorder(
                                                  borderSide: const BorderSide(color: Colors.white, width: 2),
                                                ),
                                              ),
                                              controller: _searchController,
                                              //controller: pwrdController,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Container(
                                            height:  57,
                                            width: 57,
                                            child: OutlineButton(
                                              borderSide: BorderSide(color: Colors.white, width: 2),
                                              child: Icon(Icons.search, color:  Colors.white,),
                                              highlightedBorderColor: Colors.white,
                                              onPressed: (){
                                                setState(() {
                                                  _risultatoAule = _ottieniAule(_searchController.text, filterIndex);
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Wrap(
                                      children: filterWidgets.toList(),
                                      runSpacing: 0,
                                      spacing: 0,
                                    ),

                                    FutureBuilder<List<Aula>>(
                                        future: _risultatoAule,
                                        builder: (context, snapshot){
                                          switch (snapshot.connectionState){
                                            case ConnectionState.none:
                                              return Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 15),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Icon(Icons.search, size: 40, color: Colors.white,),
                                                      Text("Premi il tasto di ricerca per iniziare", style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center,),
                                                    ],
                                                  ),
                                                ),
                                              );
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
                                                        child: Text("Sto cercando le aule...", style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center,),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            case ConnectionState.done:
                                              if (snapshot.hasData)
                                                return snapshot.data.length > 0 ? Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 10),
                                                      child: Text(
                                                        "Risultati ricerca (${snapshot.data.length} aule trovate)",
                                                        style: TextStyle(
                                                            fontSize: 24,
                                                            color: Colors.white),
                                                      ),
                                                    ),
                                                    ListView.builder(
                                                      primary: false,
                                                      shrinkWrap: true,
                                                      itemCount: snapshot.data.length,
                                                      itemBuilder: (c, i2){
                                                        //return Text(snapshot.data[i2].denominazione);
                                                        IconData descriptiveIcon = snapshot.data[i2].denominazione.contains("Lab") ? Icons.work : Icons.location_city;
                                                        descriptiveIcon = snapshot.data[i2].denominazione.contains("Palestra") ? Icons.directions_run : descriptiveIcon;
                                                        return Padding(
                                                            padding: const EdgeInsets.only(bottom: 15),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        color: Colors.black.withAlpha(12),
                                                                        blurRadius: 10,
                                                                        spreadRadius: 10
                                                                    )
                                                                  ],
                                                              ),
                                                              child: ExpandableNotifier(
                                                                  child: Container(
                                                                    child: Expandable(
                                                                      collapsed: ExpandableButton(
                                                                          child: Container(
                                                                            decoration: new BoxDecoration(
                                                                                color: Color(0xffF86925),
                                                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                //border: Border.all(width: 1.0, color: Colors.white)
                                                                            ),
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(15),
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(right: 5),
                                                                                    child: Icon(descriptiveIcon, color: Colors.white),
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                        snapshot.data[i2].denominazione,
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
                                                                            color: Color(0xffF86925),
                                                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                        ),
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: <Widget>[
                                                                            ExpandableButton(
                                                                              child: Container(
                                                                                decoration: new BoxDecoration(
                                                                                  color: Colors.white,
                                                                                  borderRadius: BorderRadius.all(Radius.circular(9)),
                                                                                ),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(15),
                                                                                  child: Column(
                                                                                    children: <Widget>[
                                                                                      Row(
                                                                                        children: <Widget>[
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.only(right: 5),
                                                                                            child: Icon(descriptiveIcon, color: Colors.black,),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: Text(
                                                                                                snapshot.data[i2].denominazione,
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
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                                                                                        child: Center(
                                                                                          child: SvgPicture.network(
                                                                                            'http://reapistaging.altervista.org/api/v3/getMappa?aula=${snapshot.data[i2].locale}&piano=${snapshot.data[i2].locale.substring(0,0)}',
                                                                                            fit: BoxFit.contain,
                                                                                            height: 120,
                                                                                            placeholderBuilder: (BuildContext context) => Container(
                                                                                              padding: const EdgeInsets.all(30.0),
                                                                                              child: Center(
                                                                                                child: Column(
                                                                                                  children: <Widget>[
                                                                                                    SpinKitDualRing(
                                                                                                      color: Colors.black,
                                                                                                      size: 40,
                                                                                                      lineWidth: 5,
                                                                                                    ),
                                                                                                    Padding(
                                                                                                      padding: const EdgeInsets.only(top: 8.0),
                                                                                                      child: Text("Sto caricando la mappa...", style: TextStyle(color: Colors.black, fontSize: 16), textAlign: TextAlign.center,),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(15),
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: <Widget>[
                                                                                  Text("Piano aula: ${snapshot.data[i2].piano}", style: TextStyle(color: Colors.white)),
                                                                                  Text("Locale aula: ${snapshot.data[i2].locale}", style: TextStyle(color: Colors.white)),
                                                                                  Text(
                                                                                      ("Aula dotata di " + (snapshot.data[i2].prese ? "prese, " : "") +
                                                                                          (snapshot.data[i2].ethernet ? "attacchi ethernet, " : "") +
                                                                                          (snapshot.data[i2].computer ? "computer, " : "")),
                                                                                      style: TextStyle(color: Colors.white)
                                                                                  ),
                                                                                  Text("Plesso: ${snapshot.data[i2].plesso}", style: TextStyle(color: Colors.white)),
                                                                                ],
                                                                              ),
                                                                            ),

                                                                          ],
                                                                        ),
                                                                      ),

                                                                    ),
                                                                  )
                                                              ),
                                                            )
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ) : Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 15),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Icon(Icons.cloud_queue, size: 40, color: Colors.white,),
                                                        Text("Nessuna aula che rispetti i criteri trovata", style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center,),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              if (snapshot.hasError)
                                                return Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 15),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Icon(Icons.error_outline, size: 40, color: Colors.white,),
                                                        Text("${snapshot.error}", style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center,),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                          }
                                          return null;
                                        }
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
