// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:animations/animations.dart';

import 'package:mySobrero/app_main/app_home.dart';

import 'package:mySobrero/app_main/more.dart';
import 'package:mySobrero/app_main/votes.dart';
import 'package:mySobrero/app_main/communications.dart';
import 'package:mySobrero/app_main/home.dart';
import 'package:mySobrero/feed/sobrero_feed.dart';
import 'package:mySobrero/impostazioni.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/reapi3.dart';
import 'package:mySobrero/sso/sso.dart';
import 'package:mySobrero/ui/button.dart';
import 'package:mySobrero/ui/helper.dart';
import 'package:mySobrero/ui/layouts.dart';
import 'package:mySobrero/ui/sobrero_appbar.dart';
import 'package:mySobrero/ui/drawer.dart';



class AppMain extends StatefulWidget {
  UnifiedLoginStructure unifiedLoginStructure;
  reAPI3 apiInstance;
  SobreroFeed feed;
  String profileUrl;
  bool isBeta = false;

  AppMain({
    Key key,
    @required this.unifiedLoginStructure,
    @required this.feed,
    @required this.profileUrl,
    @required this.isBeta,
    @required this.apiInstance}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppMainState();
}

class _AppMainState extends State<AppMain> with SingleTickerProviderStateMixin {
  int _currentPageIndex = 0;
  String _profileUrl;
  double _globalScroll = 0;

  int _scrollThreshold = 100;

  HomePage _homePageInstance;
  VotesPage _votesPageInstance;
  CommunicationsPageView _communicationsPageView;
  MorePageView _morePageInstance;
  Homepage _homepageNewInstance;

  PageController pageController = PageController();

  void switchPage(bool needToSwitch, int page){
    if (needToSwitch){
      pageController.animateToPage(
          page,
          duration: Duration(milliseconds: 200), curve: Curves.ease
      );
    }
    setState(() {
      _globalScroll = 0;
      _currentPageIndex = page;
    });
  }

  Future<bool> _handleBackButton() async {
    if (_currentPageIndex != 0) {
      switchPage(true, 0);
      return false;
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return true;
  }

  void _updateProfilePicture(String url) {
    setState(() {
      _profileUrl = url;
    });
  }

  @override
  void initState(){
    super.initState();
    _profileUrl = widget.profileUrl;
    print(_profileUrl);
    _homePageInstance = HomePage(
        unifiedLoginStructure: widget.unifiedLoginStructure,
        apiInstance: widget.apiInstance,
        feed: widget.feed,
        callback: (page) => switchPage(true, page),
    );
    _votesPageInstance = VotesPage(
      unifiedLoginStructure: widget.unifiedLoginStructure,
      apiInstance: widget.apiInstance,
    );
    _homepageNewInstance = Homepage(
      unifiedLoginStructure: widget.unifiedLoginStructure,
      apiInstance: widget.apiInstance,
      feed: widget.feed,
      switchPageCallback: (page) => switchPage(true, page),
    );
    _communicationsPageView = CommunicationsPageView(
      unifiedLoginStructure: widget.unifiedLoginStructure,
      apiInstance: widget.apiInstance,
    );
    _morePageInstance = MorePageView(
      unifiedLoginStructure: widget.unifiedLoginStructure,
      apiInstance: widget.apiInstance,
    );
  }

  bool elaboraScroll(ScrollNotification scrollNotification) {
    if (scrollNotification is ScrollUpdateNotification) {
      double oldScroll = _globalScroll;
      _globalScroll = scrollNotification.metrics.pixels;
      if (_globalScroll < 0)
        _globalScroll = 0;
      else if (_globalScroll > _scrollThreshold)
        _globalScroll = 1;
      else
        _globalScroll /= _scrollThreshold;
      if (oldScroll - _globalScroll != 0) setState(() {});
    }
    return true;
  }

  // TODO: setState a rotazione schermo

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackButton,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Theme.of(context).brightness
        ),
        child: SobreroLayout.rScaffold(
          isWide: UIHelper.isPad(context),
          appBar: SobreroAppBar(
            elevation: _globalScroll,
            topCorrection: window.padding.top > 0 ? 3 : 0,
            profilePicUrl: _profileUrl,
            loginStructure: widget.unifiedLoginStructure,
            session: widget.apiInstance.getSession(),
            setProfileCallback: (url) => setState((){
              _profileUrl = url;
            }),
          ),
          drawer: SobreroDrawer(
            isPad: false,
            children: [
              SobreroDrawerButton(
                margin: EdgeInsets.only(top: 15),
                suffixIcon: LineIcons.home,
                text: AppLocalizations.of(context).translate('home'),
                color: Theme.of(context).primaryColor,
                isSelected: _currentPageIndex == 0,
                onPressed: () => switchPage(true, 0),
              ),
              SobreroDrawerButton(
                margin: EdgeInsets.only(top: 15),
                suffixIcon: LineIcons.bar_chart,
                text: AppLocalizations.of(context).translate('marks'),
                color: Theme.of(context).primaryColor,
                isSelected: _currentPageIndex == 1,
                onPressed: () => switchPage(true, 1),
              ),
              SobreroDrawerButton(
                margin: EdgeInsets.only(top: 15),
                suffixIcon: LineIcons.envelope_o,
                text: AppLocalizations.of(context).translate('memos'),
                color: Theme.of(context).primaryColor,
                isSelected: _currentPageIndex == 2,
                onPressed: () => switchPage(true, 2),
              ),
              SobreroDrawerButton(
                margin: EdgeInsets.only(top: 15, bottom: 10),
                suffixIcon: LineIcons.ellipsis_h,
                text: AppLocalizations.of(context).translate('more'),
                color: Theme.of(context).primaryColor,
                isSelected: _currentPageIndex == 3,
                onPressed: () => switchPage(true, 3),
              ),
              SobreroDrawerButton(
                margin: EdgeInsets.only(top: 15),
                suffixIcon: LineIcons.unlock_alt,
                text: AppLocalizations.of(context).translate("authorizeApp"),
                color: Theme.of(context).primaryColor,
                onPressed: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (a, b, c) => SSOProvider(
                      session: widget.apiInstance.getSession(),
                    ),
                    transitionDuration: Duration(
                      milliseconds: UIHelper.pageAnimDuration,
                    ),
                    transitionsBuilder: (_, p, s, c) => SharedAxisTransition(
                      animation: p,
                      secondaryAnimation: s,
                      transitionType: SharedAxisTransitionType.scaled,
                      child: c,
                    ),
                  ),
                ),
              ),
              SobreroDrawerButton(
                margin: EdgeInsets.only(bottom: 10),
                suffixIcon: LineIcons.gear,
                text: AppLocalizations.of(context).translate("settings"),
                color: Theme.of(context).primaryColor,
                onPressed: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (a, b, c) => ImpostazioniView(
                      unifiedLoginStructure: widget.unifiedLoginStructure,
                      profileURL: _profileUrl,
                      profileCallback: (url) => setState((){
                        _profileUrl = url;
                      }),
                      session: widget.apiInstance.getSession(),
                    ),
                    transitionDuration: Duration(
                      milliseconds: UIHelper.pageAnimDuration,
                    ),
                    transitionsBuilder: (_, p, s, c) => SharedAxisTransition(
                      animation: p,
                      secondaryAnimation: s,
                      transitionType: SharedAxisTransitionType.scaled,
                      child: c,
                    ),
                  ),
                ),
              ),
              SobreroDrawerButton(
                margin: EdgeInsets.only(top: 15),
                suffixIcon: LineIcons.sign_out,
                text: "Disconnettiti",
                color: Colors.red,
              ),
            ],
          ),
          body: PageView.builder(
              controller: pageController,
              onPageChanged: (index) => switchPage(false, index),
              itemCount: 4,
              itemBuilder: (context, i) {
                var schermata;
                if (i == 0) schermata = _homepageNewInstance;
                if (i == 1) schermata = _votesPageInstance;
                if (i == 2) schermata = _communicationsPageView;
                if (i == 3) schermata = _morePageInstance;
                return NotificationListener<ScrollNotification>(
                    onNotification: elaboraScroll,
                    child: schermata
                );
              },
            ),
        ),
      ),
    );
  }
}
