// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:mySobrero/cloud_connector/cloud.dart';
import 'package:mySobrero/common/pageswitcher.dart';
import 'package:mySobrero/common/utilities.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/reAPI/reapi.dart';
import 'package:mySobrero/snacks/snacks_list.dart';
import 'package:mySobrero/ui/button.dart';
import 'package:mySobrero/ui/data_ui.dart';
import 'package:mySobrero/ui/detail_view.dart';
import 'package:mySobrero/ui/helper.dart';

class SnackDetail extends StatefulWidget {
  SnackDetail({
    Key key,
    @required this.snack,
  }) : super(key: key);

  final Snack snack;

  @override
  _SnackDetailState createState() => _SnackDetailState();
}

class _SnackDetailState extends State<SnackDetail> {
  Future<int> _snackBalance;
  Future<bool> _transactionStatus;
  int _founds = 0;

  int _modalState = 0;

  @override
  void initState(){
    super.initState();
    _snackBalance = CloudConnector.getSnacksBalance(
      token: reAPI4.instance.getSession(),
    );
  }

  void _prepareBuy(context){
    bool _sufficentFounds = _founds >= widget.snack.cost;
    _modalState = 0;
    showModalBottomSheet(
      isDismissible: false,
        enableDrag: false,
        context: context,
        builder: (BuildContext bc){
          return WillPopScope(
            onWillPop: () {},
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(15),
                    topRight: const Radius.circular(15),
                  ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: StatefulBuilder(
                    builder: (context, setState){
                      Widget _confirmState = Wrap(
                        key: ValueKey<int>(0),
                        children: <Widget>[
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  Utilities.formatArgumentString(
                                    AppLocalizations.of(context).translate(
                                        "SNACKS_BUY_HEADING"
                                    ),
                                    args: [
                                      widget.snack.name,
                                    ],
                                  ),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                              Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12.withAlpha(12),
                                        blurRadius: 10,
                                        spreadRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: Text(widget.snack.cost.toString()),
                                        ),
                                        Image.asset("assets/images/snack_coin.png",
                                          width: 30,
                                        ),
                                      ],
                                    ),
                                  )
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: Icon(
                                    _sufficentFounds
                                        ? TablerIcons.check
                                        : TablerIcons.ban,
                                    color: _sufficentFounds
                                        ? Colors.green
                                        : Colors.red,
                                    size: 25,
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of(context).translate(
                                    _sufficentFounds
                                        ? "SNACKS_OK_TO_BUY"
                                        : "SNACKS_NO_FOUNDS",
                                  ),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _sufficentFounds
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: Icon(
                                    TablerIcons.calendar,
                                    size: 25,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    AppLocalizations.of(context).translate(
                                      "SNACKS_ORDER_POLICY"
                                    ),
                                    style: TextStyle(
                                        fontSize: 16
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SobreroButton(
                            text: AppLocalizations.of(context).translate(
                              _sufficentFounds
                                  ? "SNACKS_CONFIRM_BUY"
                                  : "SNACKS_NO_FOUNDS",
                            ),
                            color: _sufficentFounds
                                ? Color(0xff00CA71)
                                : Colors.grey,
                            suffixIcon: Icon(TablerIcons.shopping_cart),
                            onPressed: _sufficentFounds ? () => setState(() {
                              _transactionStatus = CloudConnector.authorizeTransaction(
                                snackId: widget.snack.id,
                                token: reAPI4.instance.getSession(),
                              );
                              _modalState = 1;
                            }) : null,
                            margin: EdgeInsets.only(top:15, bottom: 10),
                          ),
                          SobreroButton(
                            text: AppLocalizations.of(context).translate(
                              "SNACKS_GO_BACK"
                            ),
                            color: Colors.red,
                            suffixIcon: Icon(TablerIcons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                            margin: EdgeInsets.only(bottom: 15),
                          ),
                        ],
                      );
                      Widget _processState = Wrap(
                        key: ValueKey<int>(1),
                        children: [
                          FutureBuilder<bool>(
                            future: _transactionStatus,
                            builder: (context, snapshot){
                              switch (snapshot.connectionState){
                                case ConnectionState.none:
                                case ConnectionState.active:
                                case ConnectionState.waiting:
                                  return SobreroLoading(
                                    loadingStringKey: "SNACKS_AUTHORIZING_TRANSACTION",
                                  );
                                case ConnectionState.done:
                                  if (snapshot.hasError)
                                    return SobreroError(
                                      snapshotError: snapshot.error,
                                    );
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    key: ValueKey<int>(102),
                                    children: [
                                      SizedBox(width: double.infinity),
                                      Container(
                                        width: 200,
                                        height: 200,
                                        child: FlareActor(
                                          "assets/animations/success.flr",
                                          alignment: Alignment.center,
                                          fit:BoxFit.contain,
                                          animation: "root",
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          AppLocalizations.of(context).translate(
                                            "SNACKS_AUTHORIZED"
                                          ),
                                          style: TextStyle(
                                            color: Color(0xff00CA71),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SobreroButton(
                                        text: AppLocalizations.of(context).translate(
                                          "SNACKS_GO_BACK",
                                        ),
                                        color: Color(0xff00CA71),
                                        suffixIcon: Icon(TablerIcons.arrow_back),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        margin: EdgeInsets.only(top: 10, bottom: 10),
                                      ),
                                    ],
                                  );
                              }
                              return null;
                            },
                          ),
                        ],
                      );
                      return PageTransitionSwitcher2(
                        layoutBuilder: (_entries) => Stack(
                          children: _entries
                              .map<Widget>((entry) => entry.transition)
                              .toList(),
                          alignment: Alignment.topLeft,
                        ),
                        duration: Duration(milliseconds: UIHelper.pageAnimDuration),
                        transitionBuilder: (c, p, s) => SharedAxisTransition(
                          fillColor: Colors.transparent,
                          animation: p,
                          secondaryAnimation: s,
                          transitionType: SharedAxisTransitionType.horizontal,
                          child: c,
                        ),
                        child: _modalState == 0 ? _confirmState : _processState,
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return SobreroDetailView(
      appbarBuilder: (_, e, o ,t) => PreferredSize(
        preferredSize: Size(double.infinity, 65),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(e * 0.1),
                blurRadius: 10,
                spreadRadius: 10,
              ),
            ],
          ),
          child: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(5,3,20,3),
                child: Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        TablerIcons.chevron_left,
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                      tooltip: "Indietro",
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    AnimatedOpacity(
                      opacity: o,
                      duration: Duration(milliseconds: 250),
                      child: Text(
                        t,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    Spacer(),
                    Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withAlpha(12),
                              blurRadius: 10,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: FutureBuilder<int>(
                                  future: _snackBalance,
                                  builder: (_, snapshot){
                                    switch (snapshot.connectionState){
                                      case ConnectionState.none:
                                      case ConnectionState.active:
                                      case ConnectionState.waiting:
                                        return Container(
                                          child: SpinKitDualRing(
                                            color: Theme.of(context).textTheme
                                                .bodyText1.color,
                                            size: 20,
                                            lineWidth: 2,
                                          ),
                                        );
                                      case ConnectionState.done:
                                        if (snapshot.hasError)
                                          return Text("0E");
                                        _founds = snapshot.data;
                                        return Text(snapshot.data.toString());
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Image.asset("assets/images/snack_coin.png",
                                width: 30,
                              ),
                            ],
                          ),
                        )
                    ),
                  ],
                ),
              )
          ),
        ),
      ),
      title: widget.snack.name,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 10
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        widget.snack.image
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Html(
              data: widget.snack.description,
              padding: EdgeInsets.only(top: 10),
              showImages: false,
              onLinkTap: (url) {}
          ),
        ],
      ),
      bottom: SobreroButton(
        margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
        text: AppLocalizations.of(context).translate(
          widget.snack.available
              ? "SNACKS_BUY"
              : "SNACKS_NOT_AVAILABLE",
        ),
        color: Theme.of(context).primaryColor,
        suffixIcon: Icon(TablerIcons.shopping_cart),
        onPressed: () => _prepareBuy(context),
      ),
    );
  }
}