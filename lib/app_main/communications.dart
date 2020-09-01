// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/ui/data_ui.dart';
import 'package:mySobrero/ui/helper.dart';
import 'package:mySobrero/ui/layouts.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import 'package:mySobrero/common/tiles.dart';
import 'package:mySobrero/common/ui.dart';
import 'package:mySobrero/common/utilities.dart';
import 'package:mySobrero/reapi3.dart';

class CommunicationsPageView extends StatefulWidget {
  UnifiedLoginStructure unifiedLoginStructure;
  reAPI3 apiInstance;
  List<ComunicazioneStructure> communications;

  CommunicationsPageView({
    Key key,
    @required this.unifiedLoginStructure,
    @required this.apiInstance,
  }) :  assert(unifiedLoginStructure != null),
        communications = unifiedLoginStructure.comunicazioni,
        assert(apiInstance != null),
        super(key: key);

  @override
  _CommunicationsPageState createState() => _CommunicationsPageState();
}

class _CommunicationsPageState extends State<CommunicationsPageView>
    with AutomaticKeepAliveClientMixin<CommunicationsPageView>{
  @override
  bool get wantKeepAlive => true;

  List<Widget> _displayAttachments(List<AllegatoStructure> allegati){
    List<Widget> list = new List<Widget>();
    allegati.forEach((element) {
      list.add(
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(500),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).primaryColor.withAlpha(50),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: Offset(0,3)
              ),
            ],
          ),
          child: ActionChip(
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () => openURL(context, element.url),
            avatar: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                LineIcons.paperclip,
                color: Colors.white,
                size: 20,
              ),
            ),
            label: Text(
              element.nome,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        )
      );
    });
    return list;
  }

  Widget _displayCommunication(ComunicazioneStructure element){
    String realSender = "Dirigente";
    if (element.mittente.toUpperCase() != "DIRIGENTE")
      realSender = "Segreteria Amm.va";
    return SobreroFlatTile(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
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
                child: realSender == "Dirigente" ?
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/images/rota.png"),
                    radius: 15,
                  ) :
                  CircleAvatar(
                    child: Text("S", style: TextStyle(color: Colors.white)),
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: 15,
                  ),

              ),
              Text(
                realSender,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(element.data)
            ],
          ),
        ),
        Text(
          toBeginningOfSentenceCase(element.titolo),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Text(
            element.contenuto,
            style: TextStyle(fontSize: 16),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _displayAttachments(element.allegati),
        )
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
        if (widget.communications.length > 0) WaterfallFlow.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: widget.communications.length,
          itemBuilder: (_, i) => _displayCommunication(widget.communications[i]),
          gridDelegate: SliverWaterfallFlowDelegate(
            crossAxisCount: UIHelper.columnCount(context),
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            lastChildLayoutTypeBuilder: (i) =>
              i == widget.communications.length ? LastChildLayoutType.foot
                  : LastChildLayoutType.none,
          ),
        ) else SobreroEmptyState(
          emptyStateKey: "noNotices",
        ),
      ],
    );
  }
}