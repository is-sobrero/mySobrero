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
    if (currentBrightness == Brightness.dark)
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    super.dispose();
  }
/*
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
  }*/

  final List<FilterEntry> _cast = <FilterEntry>[
    const FilterEntry('Ethernet', 0),
    const FilterEntry('LIM', 1),
    const FilterEntry('Computer', 2),
    const FilterEntry('Prese', 3),
  ];

  int filterIndex = 0;

  Iterable<Widget> get filterWidgets sync* {
    for (FilterEntry entry in _cast) {
      yield Padding(
        padding: const EdgeInsets.only( right: 6),
        child: FilterChip(
          backgroundColor: Color(0xffd35400),
          selectedColor: Color(0xfff39c12),
          label: Text(entry.name, style: TextStyle(color: Colors.white)),
          selected: (filterIndex >> entry.offset & 1) > 0,
          onSelected: (bool value) {
            setState(() {
              if (value) {
                filterIndex |= 1 << entry.offset;
              } else {
                filterIndex &= ~(1 << entry.offset);
              }
            });
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    currentBrightness = Theme.of(context).brightness;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: "ricercaaule_background",
            child: Container(color: Color(0xffF86925),),
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
                      child: Text("Ricerca aule", style: TextStyle(color: Colors.white)),
                    ),
                    backgroundColor: Color(0xffF86925),
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
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                          accentColor: Colors.white,
                                          primaryColor: Colors.white,
                                          hintColor: Colors.white
                                      ),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Aula da cercare',
                                          suffixIcon: IconButton(
                                            icon: Icon(Icons.search),
                                            color: Colors.white,
                                            onPressed: (){

                                            },
                                          )
                                        ),
                                        //controller: pwrdController,
                                      ),
                                    ),
                                    Wrap(
                                      children: filterWidgets.toList(),
                                      runSpacing: 0,
                                      spacing: 0,
                                    ),
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
