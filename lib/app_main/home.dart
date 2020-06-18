// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:mySobrero/feed/feed_detail.dart';
import 'package:mySobrero/cloud_connector/cloud.dart';
import 'package:mySobrero/common/definitions.dart';
import 'package:mySobrero/common/expandedsection.dart';
import 'package:mySobrero/common/profiles.dart';
import 'package:mySobrero/common/skeleton.dart';
import 'package:mySobrero/common/tiles.dart';
import 'package:mySobrero/feed/sobrero_feed.dart';
import 'package:mySobrero/common/ui.dart';
import 'package:mySobrero/reapi3.dart';
import 'package:mySobrero/globals.dart' as globals;

class HomePage extends StatefulWidget {
  UnifiedLoginStructure unifiedLoginStructure;
  reAPI3 apiInstance;
  SobreroFeed feed;
  SwitchPageCallback callback;
  List<CompitoStructure> weekAssignments;

  HomePage({Key key, @required this.unifiedLoginStructure, @required this.apiInstance, @required this.feed, @required this.callback,}) {
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
  
  RemoteNews _remoteNotice = RemoteNews.preFetch();

  bool expandedParentNotice = false;
  TapGestureRecognizer _parentNoticeRecognizer;

  bool accountStudente;

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
    getRemoteHeadingNews().then(
            (value) => setState((){
              _remoteNotice = value;
            })
    );

    _parentNoticeRecognizer = TapGestureRecognizer()..onTap = (){
      setState((){
        expandedParentNotice = !expandedParentNotice;
      });
    };
    accountStudente = widget.unifiedLoginStructure.user.livello == "4";
  }

  @override
  void dispose(){
    _parentNoticeRecognizer.dispose();
    super.dispose();
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
                  !accountStudente ? Padding(
                    padding: EdgeInsets.only(bottom: _remoteNotice.headingNewsEnabled ? 10 : 0),
                    child: Container(
                      decoration: new BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Color(0xFFFF416C).withOpacity(0.4),
                              offset: const Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                                decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(11)),
                                    gradient: LinearGradient(
                                      begin: FractionalOffset.topRight,
                                      end: FractionalOffset.bottomRight,
                                      colors: <Color>[
                                        Color(0xFFFF416C),
                                        Color(0xFFFF4B2B),
                                      ],
                                    )),
                                child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(color: Colors.white, width: 1.0,)
                                                )
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(bottom: 5.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.error,
                                                    size: 25,
                                                    color: Colors.white,
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 8.0,),
                                                      child: Text("Attenzione", style: new TextStyle(
                                                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16
                                                      ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        RichText(
                                          text: new TextSpan(
                                            children: [
                                              new TextSpan(
                                                text: "Hai eseguito l'accesso a mySobrero con le credenziali da genitore. ",
                                                style: new TextStyle(color: Colors.white),
                                              ),
                                              TextSpan(
                                                  text: expandedParentNotice ? "Per saperne di meno" : "Per saperne di più...",
                                                  style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.white, decoration: TextDecoration.underline),
                                                  recognizer: _parentNoticeRecognizer
                                              ),
                                            ],
                                          ),
                                        ),
                                        ExpandedSection(
                                          expand: expandedParentNotice,
                                          child:  Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text("Utilizzando le credenziali da genitore mySobrero continua a funzionare, ma alcune funzionalità potrebbero non essere disponibili, come la selezione dello studente, i sondaggi interni o l'accesso a Resell@Sobrero.\nSe sei uno studente e stai usando le credenziali dei tuoi genitori, richiedi le credenziali a te riservate in Segreteria Amministrativa per sfruttare al massimo mySobrero.", style: TextStyle(color: Colors.white)),
                                          ),
                                        )
                                      ],
                                    ))),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                  ) : Container(),
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
                  GradientToggleTile(
                    padding: EdgeInsets.only(bottom: _remoteNotice.headingNewsEnabled ? 10 : 0),
                    highColor: Color(0xFFff5858),
                    lowColor: Color(0xFFf09819),
                    expand: _remoteNotice.headingNewsEnabled,
                    onTap: null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.white, width: 1.0,)
                                )
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.info_outline,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0,),
                                      child: Text("Informazioni per gli studenti", style: new TextStyle(
                                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16
                                      ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Text(_remoteNotice.headingNewsBody, style: TextStyle(color: Colors.white)),
                      ],
                    )
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
                                padding: EdgeInsets.only(right: 5),
                                highColor: Color(0xFFfee140),
                                lowColor: Color(0xFFfa709a),
                                textColor: Colors.white,
                                primaryText: lastMark,
                                secondaryText: lastMark.isEmpty ? "Nessun voto inserito" : "Voto preso di $lastSubject",
                                showImage: lastMark.isEmpty,
                                image: "assets/icons/test",
                              ),
                              // TODO: implementare apertura compiti con hero
                              CounterTile(
                                onTap: () => widget.callback(1),
                                padding: EdgeInsets.only(left: 5),
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
                      GradientTile(
                        aspectRatio: 2,
                        padding: EdgeInsets.fromLTRB(isWide ? 10 : 0, 10 , 0, 10),
                        flex: isWide ? 1 : 0,
                        onTap: () => widget.callback(2),
                        highColor: Color(0xFFfa71cd),
                        lowColor: Color(0xFFc471f5),
                        child: Column(
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
            color: Theme.of(context).brightness == Brightness.dark ? AppColorScheme().darkSectionColor : AppColorScheme().sectionColor,
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
          ),
          ExpandedSection(
            expand: _remoteNotice.bottomNoticeEnabled,
            child: ImageLinkTile(
              context: context,
              highColor: Color(0xFFfa71cd),
              lowColor: Color(0xFF6a11cb),
              isWide: isWide,
              imageUrl: _remoteNotice.bottomNoticeHeadingURL,
              title: _remoteNotice.bottomNoticeTitle,
              body: _remoteNotice.bottomNotice,
              detailsText: _remoteNotice.bottomNoticeLinkTitle,
              detailsUrl: _remoteNotice.bottomNoticeLink
            ),
          )
        ],
      ),
    );
  }
}