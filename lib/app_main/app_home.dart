import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import 'package:mySobrero/cloud_connector/cloud2.dart';
import 'package:mySobrero/common/utilities.dart';
import 'package:mySobrero/feed/feed_detail.dart';
import 'package:mySobrero/common/definitions.dart';
import 'package:mySobrero/common/expandedsection.dart';
import 'package:mySobrero/common/profiles.dart';
import 'package:mySobrero/common/skeleton.dart';
import 'package:mySobrero/common/tiles.dart';
import 'package:mySobrero/feed/sobrero_feed.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/reapi3.dart';
import 'package:mySobrero/globals.dart' as globals;
import 'package:mySobrero/ui/tiles.dart';


class Homepage extends StatefulWidget {
  UnifiedLoginStructure unifiedLoginStructure;
  reAPI3 apiInstance;
  SobreroFeed feed;
  SwitchPageCallback votesPageCallback;
  List<CompitoStructure> weekAssignments;

  Homepage({
    Key key,
    @required this.unifiedLoginStructure,
    @required this.apiInstance,
    @required this.feed,
    @required this.votesPageCallback,
  }) :  assert(unifiedLoginStructure != null),
        assert(apiInstance != null),
        assert(feed != null),
        assert(votesPageCallback != null),
        super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with AutomaticKeepAliveClientMixin<Homepage> {
  @override
  bool get wantKeepAlive => true;

  RemoteNews _remoteNotice = RemoteNews.preFetch();
  bool expandedParentNotice = false;
  TapGestureRecognizer _parentNoticeRecognizer;

  String lastMark = "", lastSubject;
  String lastCircular = "", lastNoticeSender;
  bool studentAccount;

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
      if (lastCircular.length > 100)
        lastCircular = lastCircular.substring(0, 100) + "...";
      lastNoticeSender = widget.unifiedLoginStructure.comunicazioni[0].mittente;
      String _sender = widget.unifiedLoginStructure.comunicazioni[0].mittente;
      if (_sender.toUpperCase() == "DIRIGENTE")
        lastNoticeSender = "Dirigente";
      else lastNoticeSender = "Segreteria Amm.va";
    }

    CloudConnector.getRemoteHeadingNews().then(
            (value) => setState((){
          _remoteNotice = value;
        })
    );

    _parentNoticeRecognizer = TapGestureRecognizer()..onTap = (){
      setState((){
        expandedParentNotice = !expandedParentNotice;
      });
    };
    studentAccount = widget.unifiedLoginStructure.user.livello == "4";
  }

  @override
  void dispose(){
    _parentNoticeRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.only(
        bottom: 64 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        children: [
          SafeArea(
            top: false,
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
              child: Column(
                children: [
                  if (!studentAccount) SobreroGradientTile(
                    margin: EdgeInsets.only(
                      bottom: _remoteNotice.headingNewsEnabled ? 10 : 0,
                    ),
                    colors: [
                      Color(0xFFFF416C),
                      Color(0xFFFF4B2B),
                    ],
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              LineIcons.warning,
                              size: 25,
                              color: Colors.white,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  AppLocalizations.of(context).translate('warning'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: AppLocalizations.of(context).translate(
                                  'loggedAsParent'),
                              style: TextStyle(color: Colors.white),
                            ),
                            TextSpan(
                              text: expandedParentNotice
                                  ? AppLocalizations.of(context).translate(
                                    'showLess')
                                  : AppLocalizations.of(context).translate(
                                    'toLearnMore'),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: _parentNoticeRecognizer,
                            ),
                          ],
                        ),
                      ),
                      ExpandedSection(
                        expand: expandedParentNotice,
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            AppLocalizations.of(context).translate(
                                'parentNotice'),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}