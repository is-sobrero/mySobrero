import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mySobrero/FeedDetail.dart';

import 'package:mySobrero/common/definitions.dart';
import 'package:mySobrero/common/profiles.dart';
import 'package:mySobrero/common/skeleton.dart';
import 'package:mySobrero/common/tiles.dart';
import 'package:mySobrero/SobreroFeed.dart';
import 'package:mySobrero/common/ui.dart';
import 'package:mySobrero/reapi3.dart';
import 'package:mySobrero/globals.dart' as globals;

class HomePage extends StatefulWidget {
  UnifiedLoginStructure unifiedLoginStructure;
  reAPI3 apiInstance;
  SobreroFeed feed;
  SwitchPageCallback callback;
  List<CompitoStructure> weekAssignments;
  String profileUrl;

  HomePage({Key key, @required this.unifiedLoginStructure, @required this.apiInstance, @required this.feed, @required this.callback, @required this.profileUrl}) {
    DateTime today = DateTime.now();
    bool isCurrentWeek = false;
    var weekStart = today.subtract(new Duration(days: today.weekday - 1));
    var formatter = new DateFormat('DD/MM/yyyy');
    this.weekAssignments = List<CompitoStructure>();
    for (int i = 0; i < unifiedLoginStructure.compiti.length; i++) {
      DateTime assignmentDate = formatter.parse(unifiedLoginStructure.compiti[i].data);
      isCurrentWeek = assignmentDate.compareTo(weekStart) >= 0;
      if (isCurrentWeek) this.weekAssignments.add(unifiedLoginStructure.compiti[i]);
    }
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage> {
  @override
  bool get wantKeepAlive => true;

  String lastMark = "", lastSubject;
  String lastCircular = "", lastCircularSender;

  @override
  void initState(){
    super.initState();
    if (widget.unifiedLoginStructure.voti1Q.length > 0){
      lastMark = widget.unifiedLoginStructure.voti1Q[0].votoTXT;
      lastSubject = widget.unifiedLoginStructure.voti1Q[0].materia;
    }
    if (widget.unifiedLoginStructure.voti2Q.length > 0){
      lastMark = widget.unifiedLoginStructure.voti2Q[0].votoTXT;
      lastSubject = widget.unifiedLoginStructure.voti2Q[0].materia;
    }
    if (widget.unifiedLoginStructure.comunicazioni.length > 0){
      lastCircular = widget.unifiedLoginStructure.comunicazioni[0].contenuto;
      if (lastCircular.length > 100) lastCircular = lastCircular.substring(0, 100) + "...";
      lastCircularSender = widget.unifiedLoginStructure.comunicazioni[0].mittente;
      final String tempSender = widget.unifiedLoginStructure.comunicazioni[0].mittente;
      if (tempSender.toUpperCase() == "DIRIGENTE") lastCircularSender = "Dirigente";
      else lastCircularSender = "Gianni Rossi";
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isWide = MediaQuery.of(context).size.width > 550;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Ciao ${widget.unifiedLoginStructure.user.nome}!',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 24,
                                ),
                              ),
                              Text('Classe ${widget.unifiedLoginStructure.user.classe} ${widget.unifiedLoginStructure.user.sezione} - ${widget.unifiedLoginStructure.user.corso}',),
                            ],
                          ),
                        ),
                        Container(
                          decoration: new BoxDecoration(
                            boxShadow: [BoxShadow(
                                color: Colors.black.withAlpha(50),
                                offset: Offset(0, 5),
                                blurRadius: 10
                            )],
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: new Container(
                                width: 50,
                                height: 50,
                                color: Theme.of(context).scaffoldBackgroundColor,
                                child: globals.profileURL != null ? CachedNetworkImage(
                                  imageUrl: globals.profileURL,
                                  placeholder: (context, url) => Skeleton(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                  fit: BoxFit.cover,
                                ) : Image.asset("assets/images/profile.jpg")
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Flex(
                    direction: isWide ? Axis.horizontal : Axis.vertical,
                    children: <Widget>[
                      Expanded(
                        flex: isWide ? 1 : 0,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              CounterTile(
                                onTap: () => widget.callback(1),
                                aspectRatio: 1,
                                padding: EdgeInsets.only(right: 5),
                                flex: 1,
                                highColor: Color(0xFFfee140),
                                lowColor: Color(0xFFfa709a),
                                textColor: Colors.white,
                                primaryText: lastMark,
                                secondaryText: lastMark.isEmpty ? "Nessun voto inserito" : "Voto preso di $lastSubject",
                                showImage: lastMark.isEmpty,
                                imagePath: "assets/icons/test",
                              ),
                              // TODO: implementare apertura compiti con hero
                              CounterTile(
                                onTap: () => widget.callback(1),
                                padding: EdgeInsets.only(left: 5),
                                flex: 1,
                                aspectRatio: 1,
                                highColor: Color(0xFF38f9d7),
                                lowColor: Color(0xFF43e97b),
                                textColor: Colors.black,
                                primaryText: widget.weekAssignments.length.toString(),
                                secondaryText: "Compiti per la settimana",
                              ),
                            ],
                          ),
                        ),
                      ),
                      DetailTile(
                        aspectRatio: 2,
                        padding: EdgeInsets.fromLTRB(isWide ? 10 : 0, 10 , 0, 10),
                        flex: isWide ? 1 : 0,
                        onTap: () => widget.callback(2),
                        highColor: Color(0xFFfa71cd),
                        lowColor: Color(0xFFc471f5),
                        body: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: <Widget>[
                                  CircularProfile(
                                      sender: lastCircularSender,
                                      radius: 15
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      toBeginningOfSentenceCase(lastCircularSender),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            AutoSizeText(
                              lastCircular,
                              minFontSize: 12,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: new TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: AutoSizeText(
                                "Ultima comunicazione ricevuta",
                                style: new TextStyle(color: Color(0xFFFFFFFF)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Theme.of(context).brightness == Brightness.dark ?
              AppColorScheme().darkSectionColor : AppColorScheme().sectionColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, top: 20,),
                    child: Text(
                        "Ultime dal Sobrero",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                ),
                Container(
                  height: 450,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 16),
                    itemCount: widget.feed.items.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) =>
                        NewsTile(
                          context: context,
                          safeLeft: false,
                          safeRight:  false,
                          leadingImageUrl: widget.feed.items[index].thumbnail,
                          title: widget.feed.items[index].title,
                          detailView: FeedDetailView(articolo: widget.feed.items[index]),
                        ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}