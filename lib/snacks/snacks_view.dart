// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:mySobrero/cloud_connector/cloud.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/reAPI/reapi.dart';
import 'package:mySobrero/snacks/snacks_detail.dart';
import 'package:mySobrero/snacks/snacks_history.dart';
import 'package:mySobrero/snacks/snacks_list.dart';
import 'package:mySobrero/tiles/leading_image.dart';
import 'package:mySobrero/ui/button.dart';
import 'package:mySobrero/ui/data_ui.dart';
import 'package:mySobrero/ui/detail_view.dart';
import 'package:mySobrero/ui/helper.dart';
import 'package:mySobrero/ui/textfield.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class SnacksView extends StatefulWidget {
  SnacksView({
    Key key
  }) : super(key: key);

  @override
  _SnacksListState createState() => _SnacksListState();
}

class _SnacksListState extends State<SnacksView> {
  Future<int> _snackBalance;
  Future<List<Snack>> _snacks;

  @override
  void initState(){
    super.initState();
    _snackBalance = CloudConnector.getSnacksBalance(
        token: reAPI4.instance.getSession(),
    );
    _snacks = CloudConnector.getAvailableSnacks();
  }

  @override
  Widget build(BuildContext context){
    return SobreroDetailView(
      title: "Snacks@Sobrero",
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SobreroTextField(
            hintText: AppLocalizations.of(context).translate(
              "SNACKS_SEARCH",
            ),
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            suffixIcon: IconButton(
              icon: Icon(TablerIcons.search),
              color: Theme.of(context).primaryColor,
              onPressed: () => print("ok"),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: SobreroButton(
                  margin: EdgeInsets.only(right: 5),
                  text: AppLocalizations.of(context).translate(
                    "SNACKS_ORDER_HISTORY",
                  ),
                  color: Theme.of(context).primaryColor,
                  suffixIcon: Icon(TablerIcons.history),
                  onPressed: () => Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (a, b, c) => SnacksHistoryView(),
                      transitionDuration: Duration(milliseconds: UIHelper.pageAnimDuration),
                      transitionsBuilder: (ctx, prim, sec, child) => SharedAxisTransition(
                        animation: prim,
                        secondaryAnimation: sec,
                        transitionType: SharedAxisTransitionType.scaled,
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: SobreroButton(
                  text: AppLocalizations.of(context).translate(
                    "SNACKS_DEPOSIT_POINTS",
                  ),
                  margin: EdgeInsets.fromLTRB(5,0,0,15),
                  color: Theme.of(context).primaryColor,
                  suffixIcon: Icon(TablerIcons.currency_dollar),
                  onPressed: () => print("ok"),
                ),
              ),
            ],
          ),
          FutureBuilder<List<Snack>>(
            future: _snacks,
            builder: (context, snapshot){
              switch (snapshot.connectionState){
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return SobreroLoading(
                    loadingStringKey: "SNACKS_LOADING",
                  );
                case ConnectionState.done:
                  if (snapshot.hasError)
                    return SobreroError(
                      snapshotError: snapshot.error,
                    );
                  if (snapshot.data.isEmpty)
                    return SobreroEmptyState(
                      emptyStateKey: "SNACKS_NO_SNACK_FOUND",
                    );
                  return WaterfallFlow.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, i) => LeadingImageTile(
                      height: 220,
                      padding: EdgeInsets.zero,
                      leadingImageUrl: snapshot.data[i].image,
                      title: snapshot.data[i].name,
                      onTap: () =>  Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (a, b, c) => SnackDetail(
                            snack: snapshot.data[i],
                          ),
                          transitionDuration: Duration(milliseconds: UIHelper.pageAnimDuration),
                          transitionsBuilder: (ctx, prim, sec, child) => SharedAxisTransition(
                            animation: prim,
                            secondaryAnimation: sec,
                            transitionType: SharedAxisTransitionType.scaled,
                            child: child,
                          ),
                        ),
                      ),
                    ),
                    gridDelegate: SliverWaterfallFlowDelegate(
                      crossAxisCount: UIHelper.columnCount(
                        context,
                        tileWidth: 160,
                      ),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      lastChildLayoutTypeBuilder:
                          (index) => index == snapshot.data.length
                          ? LastChildLayoutType.foot
                          : LastChildLayoutType.none,
                    ),
                  );
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}