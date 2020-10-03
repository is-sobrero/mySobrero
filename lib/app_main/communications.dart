// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';
import 'package:mySobrero/reAPI/reapi.dart';
import 'package:mySobrero/reAPI/types.dart';
import 'package:mySobrero/ui/list_button.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import 'package:mySobrero/common/utilities.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/tiles/date_time_tile.dart';
import 'package:mySobrero/ui/data_ui.dart';
import 'package:mySobrero/ui/helper.dart';
import 'package:mySobrero/ui/layouts.dart';


class CommunicationsPageView extends StatefulWidget {
  CommunicationsPageView({
    Key key,
  }) :  super(key: key);

  @override
  _CommunicationsPageState createState() => _CommunicationsPageState();
}

class _CommunicationsPageState extends State<CommunicationsPageView>
    with AutomaticKeepAliveClientMixin<CommunicationsPageView>{
  @override
  bool get wantKeepAlive => true;

  List<Widget> _displayAttachments(List<Attachment> attachment){
    List<Widget> list = [
      Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 10),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 7),
              child: Icon(
                TablerIcons.paperclip,
                size: 25,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              "Allegati",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    ];
    attachment.forEach((element) {
      list.add(
        SobreroListButton(
          icon: TablerIcons.file,
          onPressed: () => openURL(context, element.url),
          title: element.name,
          isBold: false,
          color: Theme.of(context).textTheme.bodyText1.color,
          showBorder: element != attachment.last
        ),
      );
    });
    return list;
  }

  Widget _displayCommunication(Notice element){
    print(element.id);
    String realSender = "Dirigente";
    if (element.sender.toUpperCase() != "DIRIGENTE")
      realSender = "Segreteria Amm.va";
    return DateTimeTile(
      title: realSender,
      date: element.date,
      dateFormat: 'dd/MM/yyyy',
      showHour: false,
      margin: EdgeInsets.zero,
      headerLayoutBuilder: (title, color) => Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(50),
                  blurRadius: 10,
                  spreadRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: title == "Dirigente"
                ? CircleAvatar(
                  backgroundImage: AssetImage("assets/images/rota.png"),
                  radius: 15,
                )
                : CircleAvatar(
                  child: Text("S", style: TextStyle(color: Colors.white)),
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 15,
                ),
          ),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      children: [
        //TODO: implementare lettura circolari
        /*FlatButton(
          onPressed: () => reAPI4.instance.markNoticeAsRead(element.id),
          child: Text("Conferma lettura"),
        ),*/
        Text(
          toBeginningOfSentenceCase(element.object),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Text(
            element.body,
            style: TextStyle(fontSize: 16),
          ),
        ),
        if (element.attachments.length > 0) Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _displayAttachments(element.attachments),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SobreroLayout.rPage(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            AppLocalizations.of(context).translate('allNotices'),
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 24,
            ),
          ),
        ),
        if (reAPI4.instance.getStartupCache().notices.length > 0) 
          WaterfallFlow.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: reAPI4.instance.getStartupCache().notices.length,
          itemBuilder: (_, i) => _displayCommunication(
              reAPI4.instance.getStartupCache().notices[i]
          ),
          gridDelegate: SliverWaterfallFlowDelegate(
            crossAxisCount: UIHelper.columnCount(context),
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            lastChildLayoutTypeBuilder: (i) =>
              i == reAPI4.instance.getStartupCache().notices.length 
                  ? LastChildLayoutType.foot
                  : LastChildLayoutType.none,
          ),
        ) else SobreroEmptyState(
          emptyStateKey: "noNotices",
        ),
      ],
    );
  }
}